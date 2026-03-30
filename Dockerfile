FROM golang:alpine AS builder

ARG PTZTAG
ARG TARGETOS
ARG TARGETARCH
ENV GOPATH=/go
ENV GOOS=$TARGETOS
ENV GOARCH=$TARGETARCH
WORKDIR /
RUN apk add --no-cache git
RUN git clone --depth 1 --branch ${PTZTAG} https://github.com/pritunl/pritunl-zero.git /go/src/github.com/pritunl/pritunl-zero && \
    cd /go/src/github.com/pritunl/pritunl-zero && \
    go install .

FROM alpine
WORKDIR /root/go/
ARG MONGO_URI
ARG BASTION_IMAGE
ADD docker-entrypoint.sh /root/
COPY --from=builder /go/bin /root/go/bin
COPY --from=builder /go/src/github.com/pritunl/pritunl-zero/www /root/go/src/github.com/pritunl/pritunl-zero/www
RUN apk add --no-cache libc6-compat docker-cli
ENTRYPOINT ["/root/docker-entrypoint.sh"]