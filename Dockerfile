FROM alpine AS git 
WORKDIR /app
RUN apk upgrade
RUN apk add git
RUN git clone git@github.com:cecilelecerf/docker_repo.git

FROM golang:1.23-alpine3.19 AS builder
WORKDIR /app 
COPY --from=git /app .
RUN go mod init my-go-app
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64
RUN go build -o myapp . 

FROM scratch
COPY --from=builder app/myapp ./myapp
USER 1000
EXPOSE 8080
CMD ["/myapp" ]