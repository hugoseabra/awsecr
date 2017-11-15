FROM golang:1.9-alpine
MAINTAINER Hugo Seabra <hugoseabra19@gmail.com>

RUN apk add --no-cache python3 git docker
RUN pip3 install --no-cache --upgrade pip awscli jinja2 docker

COPY ./setup.py /setup.py
COPY ./file.py /file.py
COPY ./docker-entrypoint.sh /docker-entrypoint.sh
COPY ./pull.py /pull.py
COPY ./pull.sh /pull.sh
COPY ./push /push
COPY ./ /usr/local/etc/awspull

RUN chmod 775 /docker-entrypoint.sh /pull.sh
RUN cd /usr/bin && ln -s /pull.sh pull && ln -s /push
RUN go get -u github.com/awslabs/amazon-ecr-credential-helper/ecr-login/cli/docker-credential-ecr-login

WORKDIR /usr/local/etc/awspull

ENTRYPOINT ["/docker-entrypoint.sh"]
