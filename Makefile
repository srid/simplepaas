IMG := srid/simplepaas

install:
	docker pull jwilder/nginx-proxy
	docker build -t ${IMG} .

run:	run_nginx run_app
	@true

# http routing for containers
run_nginx:
	docker rm -vf nginx || true
	docker run -d --name=nginx \
		-p 80:80 -v /var/run/docker.sock:/tmp/docker.sock jwilder/nginx-proxy

# wehbook app 
run_app:
	docker run --rm --name=simplepaas \
		-v /var/run/docker.sock:/tmp/docker.sock -e VIRTUAL_HOST=${CNAME} ${IMG}

shell:
	docker run --rm --name=simplepaas-shell \
		-i -t -v /var/run/docker.sock:/tmp/docker.sock ${IMG} bash

test:
	cd demo && docker build -t ${IMG}-demo-local .
	docker run --rm -p 80 ${IMG}-demo-local


