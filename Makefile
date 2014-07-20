install:
	docker pull jwilder/nginx-proxy
	docker build -t srid/simplepaas .

run:	run_nginx run_app
	@true

run_nginx:
	docker run -d -p 80:80 -v /var/run/docker.sock:/tmp/docker.sock jwilder/nginx-proxy

run_app:
	docker run --rm -p 80 -v /var/run/docker.sock:/tmp/docker.sock -e VIRTUAL_HOST=${CNAME} srid/simplepaas

test:
	cd demo && docker build -t srid/simplepaas-demo-local .
	docker run --rm -p 80 -e VIRTUAL_HOST=${CNAME} srid/simplepaas-demo-local

