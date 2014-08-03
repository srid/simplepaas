FROM ubuntu

RUN apt-get -qy update && apt-get -qy install python3-bottle python3-pip && apt-get -y clean
RUN pip3 install docker-py

ADD . /simplepaas
WORKDIR /simplepaas
EXPOSE 80
CMD ["python3", "-u", "app.py"]

# TODO: have this image automatically bootstrap other containers such as nginx
