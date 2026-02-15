FROM golang:1.24 AS builder

ARG OTELSOAK_REF=main

RUN CGO_ENABLED=0 GO111MODULE=on go install "github.com/elastic/opentelemetry-collector-components/loadgen/cmd/otelsoak@${OTELSOAK_REF}"

FROM ubuntu:24.04

RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*

COPY --from=builder /go/bin/otelsoak /usr/bin/otelcol-contrib

ENTRYPOINT ["/usr/bin/otelcol-contrib"]
