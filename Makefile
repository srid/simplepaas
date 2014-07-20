install:
	docker pull jwilder/nginx-proxy

run:
	docker run -d -p 80:80 -v /var/run/docker.sock:/tmp/docker.sock jwilder/nginx-proxy

