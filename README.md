# Simple PaaS for the lazy

## install

* get yourself a Digital Ocean Ubuntu 14.04 server VM

* install Docker

* run `./install.sh`

* run `make test CNAME=<your.domain.com>` and access that URL; you should see hello.txt

## running

* run `make run_app CNAME=mypaas.com`

* add http://mypaas.com/webhook as webhook in hub.docker.com

* push your image

