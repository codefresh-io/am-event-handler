FROM golang:1.9.2 AS builder

RUN go get -u github.com/golang/dep/cmd/dep 

WORKDIR /go/src/github.com/codefresh-io/am-event-handler/

RUN mkdir -p /go/src/github.com/codefresh-io/am-event-handler/
COPY vendor ./vendor/
COPY cmd ./cmd/

RUN CGO_ENABLED=0 go build -o /usr/local/bin/am-event-handler . && \
    rm -rf /go/* && \
    chmod +x /usr/local/bin/am-event-handler


FROM alpine:3.7

# ENV KUBECTL_VERSION="v1.8.6"

# RUN apk add --update ca-certificates curl curl-dev openssl bash jq aws-cli \
#     && curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
#     && chmod +x /usr/local/bin/kubectl

# WORKDIR /opt/codefresh/

COPY --from=builder /usr/local/bin/am-event-handler /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/am-event-handler"]