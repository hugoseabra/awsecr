FROM golang:1.9-alpine
MAINTAINER Hugo Seabra <hugoseabra19@gmail.com>

RUN apk add --no-cache python3 git docker \
    && pip3 install --no-cache --upgrade pip

COPY ./container-setup.py /setup.py
COPY ./renderer.py /renderer.py
COPY ./docker-entrypoint.sh /docker-entrypoint.sh
COPY ./pull /pull
COPY ./push /push

COPY ./requirements.pip /usr/local/etc/awsecr
RUN pip install --no-cache-dir --upgrade -r requirements.pip

WORKDIR /usr/local/etc/awsecr

COPY ./ /usr/local/etc/awsecr

RUN chmod 775 /docker-entrypoint.sh /pull /push
RUN cd /usr/bin && ln -s /pull && ln -s /push
RUN go get -u github.com/awslabs/amazon-ecr-credential-helper/ecr-login/cli/docker-credential-ecr-login

ENTRYPOINT ["/docker-entrypoint.sh"]
