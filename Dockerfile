FROM golang AS builder

ARG PTZTAG
ENV GOPATH /go
ENV GOOS linux
ENV GOARCH arm64
WORKDIR /
# This ugly patch is running the pritunl go installation
# fails, modifying the source files and give it a second
# shot, it was already fixed in latest commit so I'll
# have to remove it with the next tag.
RUN go get -u github.com/pritunl/pritunl-zero@${PTZTAG} || \
    find /go/pkg/mod/github.com/pritunl/ -name search.go -print0 | xargs -0 sed -i 's@gopkg.in/olivere/elastic.v7@github.com/olivere/elastic/v7@' && \
    go install github.com/pritunl/pritunl-zero@${PTZTAG}

FROM debian
WORKDIR /root/go/
ARG MONGO_URI
COPY --from=builder /go/bin /root/go/bin
COPY --from=builder /go/pkg/mod/github.com/pritunl /root/go/pkg/mod/github.com/pritunl
RUN mkdir -p /root/go/src/github.com/pritunl/pritunl-zero && \
    find /root/go/pkg/mod/github.com -type d -name www -print0 | xargs -0 -I {} cp -r "{}" /root/go/src/github.com/pritunl/pritunl-zero
RUN /root/go/bin/pritunl-zero mongo $MONGO_URI
ENTRYPOINT ["/root/go/bin/pritunl-zero","start"]
