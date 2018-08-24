FROM golang:1.8 as builder

WORKDIR /go/src/app
COPY app.go .

# Install app dependencies
RUN go get -d -v ./...
RUN go install -v ./...

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app .

FROM alpine:latest as prod
RUN apk --no-cache add ca-certificates

WORKDIR /root/

# Add a script for waiting until mysql service is up and running.
ADD https://raw.githubusercontent.com/eficode/wait-for/master/wait-for ./wait-for-it.sh
RUN chmod +x ./wait-for-it.sh

COPY --from=builder /go/src/app/app .

CMD ["./app"]
