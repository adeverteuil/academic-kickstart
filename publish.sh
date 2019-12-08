#!/bin/bash

hugo
rsync --verbose --recursive --chmod=ug=rwX,o=rX --delete output/ 192.168.13.14:public
