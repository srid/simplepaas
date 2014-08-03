# Simple PaaS for the lazy

TODO: simplify instructions

## install

* get yourself a Ubuntu 14.04 server VM

* install latest Docker (`curl -sSL https://get.docker.io/ubuntu/ | sudo sh`)

* run `make install` to install everything

## running

* run `make run_nginx` to run ngnix front

* run `make run_app CNAME=yourpaas.yourdomain.com`

* go to hub.docker.com and add a wehbook for
  yourpaas.yourdomain.com/webhook in your trusted build for the ./demo
  app

* push the image; your app should be deployed (per CNAME specified in
  demo/Dockerfile)
