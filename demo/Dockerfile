FROM ubuntu
ENV VIRTUAL_HOST test.srid.name
RUN mkdir /data && echo 'hello world' > /data/hello.txt
WORKDIR /data
EXPOSE 80
CMD ["python3", "-m", "http.server", "80"]


