FROM golang:alpine AS builder

ARG PTZTAG
ENV GOPATH /go
ENV GOOS $TARGETOS
ENV GOARCH $BUILDTARGET
WORKDIR /
RUN go install github.com/pritunl/pritunl-zero@${PTZTAG}

FROM alpine:3.18.3
WORKDIR /root/go/
ARG MONGO_URI
ARG BASTION_IMAGE
ADD docker-entrypoint.sh /root/
COPY --from=builder /go/bin /root/go/bin
COPY --from=builder /go/pkg/mod/github.com/pritunl /root/go/pkg/mod/github.com/pritunl
RUN apk add --no-cache libc6-compat docker-cli
RUN mkdir -p /root/go/src/github.com/pritunl/pritunl-zero && \
    find /root/go/pkg/mod/github.com -type d -name www -print0 | xargs -0 -I {} cp -r "{}" /root/go/src/github.com/pritunl/pritunl-zero
ENTRYPOINT ["/root/docker-entrypoint.sh"]