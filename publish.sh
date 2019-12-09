#!/bin/bash

hugo
rsync --verbose --recursive --chmod=ug=rwX,o=rX --delete public/ 192.168.13.14:public
