FROM golang:alpine
RUN mkdir /app
ADD src/main.go /app/
WORKDIR /app
RUN go build -o main .
EXPOSE 8080
CMD ["/app/main"]