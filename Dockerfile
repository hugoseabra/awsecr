FROM golang:1.9-alpine
MAINTAINER Hugo Seabra <hugoseabra19@gmail.com>

RUN apk add --no-cache python3 git docker
RUN pip3 install --no-cache --upgrade pip awscli jinja2 docker

COPY ./container-setup.py /setup.py
COPY ./renderer.py /renderer.py
COPY ./docker-entrypoint.sh /docker-entrypoint.sh
COPY ./pull /pull
COPY ./push /push
COPY ./ /usr/local/etc/awsecr

RUN chmod 775 /docker-entrypoint.sh /pull /push
RUN cd /usr/bin && ln -s /pull && ln -s /push
RUN go get -u github.com/awslabs/amazon-ecr-credential-helper/ecr-login/cli/docker-credential-ecr-login

WORKDIR /usr/local/etc/awsecr

ENTRYPOINT ["/docker-entrypoint.sh"]
