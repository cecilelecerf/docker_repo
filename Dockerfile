FROM alpine as git 
WORKDIR /app
RUN apk -add git
RUN git clone ...

FROM golang:1.23-alpine3.19 as builder
WORKDIR /app 
COPY --from=git /app .
RUN go mod init my-go-app
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64
RUN go build -o myapp  

FROM scratch
COPY --from=builder app/myapp .
EXPOSE 8080
CMD ["./myapp" ]