FROM golang:1.8 as builder

# Add app sources.
WORKDIR /go/src/app
COPY app.go .

# Install app dependencies
RUN go get -d -v ./...
RUN go install -v ./...

# Build the app binary targeted on alpine linux.
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app .

# Create a lightweight execution environment for the app.
# See: https://docs.docker.com/develop/develop-images/multistage-build/#name-your-build-stages
FROM alpine:latest as prod
RUN apk --no-cache add ca-certificates

WORKDIR /root/

# Add a script for waiting until mysql service is up and running.
ADD https://raw.githubusercontent.com/eficode/wait-for/master/wait-for ./wait-for-it.sh
RUN chmod +x ./wait-for-it.sh

COPY --from=builder /go/src/app/app .

CMD ["./app"]
