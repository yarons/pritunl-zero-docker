FROM alpine

RUN apk add --no-cache openssh

RUN adduser --disabled-password bastion
RUN mkdir /ssh
RUN mkdir /ssh_mount

RUN echo -e "bastion\n" > /ssh/principals
RUN chown -R bastion:bastion /ssh

ADD init.sh /ssh/init.sh

ENTRYPOINT ["sh", "/ssh/init.sh"]
