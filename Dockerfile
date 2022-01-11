FROM golang:alpine AS builder

ARG PTZTAG
ENV GOPATH /go
ENV GOOS linux
ENV GOARCH arm64
WORKDIR /
RUN go get -u github.com/pritunl/pritunl-zero@${PTZTAG} || \
    find /go/pkg/mod/github.com/pritunl/ -name search.go -print0 | xargs -0 sed -i 's@gopkg.in/olivere/elastic.v7@github.com/olivere/elastic/v7@' && \
    go install github.com/pritunl/pritunl-zero@${PTZTAG} && echo done && exit

FROM alpine
WORKDIR /root/go/
ARG MONGO_URI
COPY --from=builder /go/bin /root/go/bin
COPY --from=builder /go/pkg/mod/github.com/pritunl /root/go/pkg/mod/github.com/pritunl
RUN apk add --no-cache libc6-compat docker-cli
RUN mkdir -p /root/go/src/github.com/pritunl/pritunl-zero && \
    find /root/go/pkg/mod/github.com -type d -name www -print0 | xargs -0 -I {} cp -r "{}" /root/go/src/github.com/pritunl/pritunl-zero
RUN /root/go/bin/pritunl-zero mongo $MONGO_URI
ENTRYPOINT ["/root/go/bin/pritunl-zero","start"]
