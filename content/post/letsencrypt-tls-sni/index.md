---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "Let's Encrypt on load balancers and reverse proxies with tls-sni-01"
subtitle: ""
summary: "How to use certbot --manual to obtain and renew Let's Encrypt SSL certificates on an Nginx or HAProxy load balancer."
authors: []
tags: ["sysadmin", "protocols", "prog", "foss"]
categories: ["informatique"]
date: 2019-04-16
lastmod: 2019-04-16
featured: false
draft: false

# Featured image
# To use, add an image named `featured.jpg/png` to your page's folder.
# Focal points: Smart, Center, TopLeft, Top, TopRight, Left, Right, BottomLeft, Bottom, BottomRight.
image:
  caption: ""
  focal_point: ""
  preview_only: false

# Projects (optional).
#   Associate this post with one or more of your projects.
#   Simply enter your project's folder or file name without extension.
#   E.g. `projects = ["internal-project"]` references `content/project/deep-learning/index.md`.
#   Otherwise, set `projects = []`.
projects: []
---

I'm working on a proof of concept at work to make our load balancers
obtain and renew Let's Encrypt SSL certificates. It has to work with
both Nginx Plus and HAProxy on Ubuntu 14.04.

The easiest and most popular authenticator to use is http-01, for which
the reverse proxy can simply override the `/.well-known/acme-challenge`
location and serve it locally. However, some sites do layer 4 load
balancing on port 80. Therefore, the webroot plugin is useless in those
cases.

The tls-sni-01 validation method, while requiring a little more reading
to understand, is quite simple and applies to every situation regardless
of the load-balancing mode. And if port 443 is load-balanced at layer 4,
then you wouldn't be doing SSL offloading anyways.

To summarize tls-sni-01, the ACME server will challenge you to construct
a self-signed SSL certificate with the token and validator values hashed
and encoded into the serverAlternateNames of the certificate, which you
must configure your server to provide during the TLS handshake with the
SNI extension enabled.

This is exactly what Certbot's Nginx authenticator does, but I also want
to support HAProxy, hence why I started to write these scripts.

I will be using certbot's manual plugin with `--manual-auth-hook` and
`--manual-cleanup-hook` scripts. Our Ansible playbook will call certbot
with the manual plugin for SSL certs that are not yet obtained. Certbot
saves the configuration in `/etc/letsencrypt/renewal` so that certbot's
renew script uses the same parameters.

    - name: check if nginx is running
      command: killall -0 nginx
      register: nginx_status
      ignore_errors: yes
      changed_when: no

    - name: request certificates by tls-sni
      command: certbot certonly --cert-name {{ item.cert_name }}{% for domain in item.domains %} -d {{ domain }}{% endfor %} --non-interactive{% if letsencrypt_staging %} --staging{% endif %} --manual --manual-auth-hook /usr/local/bin/tls-sni-auth.sh --manual-cleanup-hook /usr/local/bin/tls-sni-cleanup.sh --manual-public-ip-logging-ok
        args:
          creates: /etc/letsencrypt/live/{{ item.cert_name }}
       with_items: "{{ letsencrypt_certificates }}"
       when: nginx_status|success

During the initial provisioning of a load-balancer, the letsencrypt role
is run before the reverse proxy is installed because we want the SSL
certificates to be ready by that time. To resolve the chicken-and-egg
problem, I first check if the reverse proxy is already running. If
not, then I use the `--standalone` plugin instead, and reconfigure the
renewal to use the `--manual` plugin later.

    - name: request certificates by standalone server
      command: certbot certonly --cert-name {{ item.cert_name }}{% for domain in item.domains %} -d {{ domain }}{% endfor %} --non-interactive{% if letsencrypt_staging %} --staging{% endif %} --standalone
      args:
        creates: /etc/letsencrypt/live/{{ item.cert_name }}
      with_items: "{{ letsencrypt_certificates }}"
      when: nginx_status|failed
    
    - name: set the renewal authenticator to manual
      ini_file:
        dest: /etc/letsencrypt/renewal/{{ item[0].cert_name }}.conf
        section: renewalparams
        option: "{{ item[1].option }}"
        value: "{{ item[1].value|default(omit) }}"
        state: "{{ item[1].state|default('present') }}"
      with_nested:
        - "{{ letsencrypt_certificates }}"
        - - option: authenticator
            value: manual
          - option: manual_public_ip_logging_ok
            value: "True"
          - option: manual_auth_hook
            value: /usr/local/bin/tls-sni-auth.sh
          - option: manual_cleanup_hook
            value: /usr/local/bin/tls-sni-cleanup.sh
          - option: installer
            value: "None"
          - option: pref_challs
            state: absent


# Environment variables provided by certbot --manual

    CERTBOT_DOMAIN:      The domain being authenticated
    CERTBOT_VALIDATION:  The validation string
    CERTBOT_TOKEN:       Resource name part of the challenge

Additionally for cleanup:

    CERTBOT_AUTH_OUTPUT: Whatever the auth script wrote to stdout


# Haproxy

I haven't implemented this part yet, but here is the concept.

A `crt` setting should point to the directory where this script will
place the certificates. By reloading haproxy, certificates in this directory
will be loaded to memory.

[https://cbonte.github.io/haproxy-dconv/1.7/configuration.html#5.1-crt]()


# Nginx and Nginx Plus

A `.conf` file will be dropped in `/etc/nginx/conf.tls-sni.d` and
included when nginx is reloaded. This will add an SNI enabled virtual
server listening on port 443.

This is closely inspired by the nginx plugin to certbot.

[https://github.com/certbot/certbot/blob/master/certbot-nginx/certbot_nginx/tls_sni_01.py]()


# Scripts

## /usr/local/bin/tls-sni-auth.sh

This script assumes that the `http{}` block in your Ngnix configuration includes any `.conf` files in `/etc/nginx/conf.tls-sni.d`, which does not exist by default.

```bash
#!/bin/bash

key_bits='2048'
valid_days='1'
work_dir=/var/local/letsencrypt
key_file=${work_dir}/tls-sni/private.key
cert_file=${work_dir}/tls-sni/certificate.crt
ssl_config=${work_dir}/tls-sni-openssl.cnf

mkdir -p ${work_dir}/tls-sni

# SAN A/B (64 characters)
san_a="$(sha256sum <<< ${CERTBOT_TOKEN})"
san_b="$(sha256sum <<< ${CERTBOT_VALIDATION})"

# create dNSName in the following format: x.y.acme.invalid
# create dNSName in the following format: x.y.ka.acme.invalid
san_a_subject="${san_a:0:32}.${san_a:32:32}.acme.invalid"
san_b_subject="${san_b:0:32}.${san_b:32:32}.ka.acme.invalid"


# create openssl configuration
cat <<EOF > ${ssl_config}
[req]
distinguished_name = req_distinguished_name
x509_extensions = v3_req
prompt = no

[req_distinguished_name]
C = CA
O = ACME TLS-SNI AUTHORIZATION

[v3_req]
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid,issuer
basicConstraints = CA:TRUE
subjectAltName = @alt_names

[alt_names]
DNS.1 = ${san_a_subject}"
DNS.2 = ${san_b_subject}"
EOF

# create openssl certificate
openssl req \
    -x509 \
    -nodes \
    -days ${valid_days} \
    -newkey rsa:${key_bits} \
    -keyout ${key_file} \
    -out ${cert_file} \
    -config ${ssl_config}

# Cleanup any old Nginx config files
rm -f /etc/nginx/conf.tls-sni.d/*

# Configure Nginx
nginx_config=$(mktemp /etc/nginx/conf.tls-sni.d/tls-sni-XXXXX.conf)
cat <<EOF > ${nginx_config}
server {
    listen *:443;
    server_name *.acme.invalid;
    ssl_certificate ${cert_file};
    ssl_certificate_key ${key_file};
}
EOF

# Check the configuration and reload
nginx -t
service nginx reload
```


## /usr/local/bin/tls-sni-cleanup.sh

```
#!/bin/bash

rm -f /etc/nginx/conf.tls-sni.d/*
```


## /etc/cron.daily/letsencrypt-renew

```
#!/bin/bash

/usr/local/bin/certbot renew --quiet --non-interactive --post-hook "service nginx reload"
```


# References:

 * Inspired from:
   [https://github.com/lukas2511/dehydrated/issues/271#issuecomment-250755980]()
 * ACME protocol TLS SNI validation reference:
   [https://ietf-wg-acme.github.io/acme/#tls-with-server-name-indication-tls-sni]()


# Testing a server:

To test whether a server is presenting the desired SSL certificate, you can use
openssl s_client. For example:

```bash
openssl s_client -server localhost:443 -servername x.y.acme.invalid [-showcerts] < /dev/null
```

This will display the server certificate information. The -servername
option and parameter sets the SNI extension in the ClientHello
message. Redirecting stdin to /dev/null closes the connexion as soon
as the TLS handshake completes.

See `s_client(1)` for more information.
