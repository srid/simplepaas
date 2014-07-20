FROM ubuntu
RUN mkdir /data && echo 'hello world' > /data/hello.txt
WORKDIR /data
EXPOSE 80
CMD ["python3", "-m", "http.server", "80"]


