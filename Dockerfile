FROM golang:1.23-alpine AS builder

WORKDIR /src

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 go build -trimpath -ldflags="-s -w" -o /imds-credential-server .

FROM alpine:latest

RUN apk add --no-cache ca-certificates

COPY --from=builder /imds-credential-server /usr/local/bin/imds-credential-server

ENTRYPOINT ["/usr/local/bin/imds-credential-server"]
