install:
	docker pull jwilder/nginx-proxy

run:
	docker run -d -p 80:80 -v /var/run/docker.sock:/tmp/docker.sock jwilder/nginx-proxy

test:
	cd demo && docker build -t simplepaas/demo .
	docker run --rm -p 80 -e VIRTUAL_HOST=${CNAME} simplepaas/demo
