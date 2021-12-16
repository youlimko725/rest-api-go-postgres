# start from golang base image with alias builder
FROM golang:alpine as builder

# enable go modules in the image
ENV GO111MODULE=on

# install git since alpine image doesn't have git in it
RUN apk update && apk add --no-cache git

# set current working directory
WORKDIR /app

# caching all the dependencies & downloading them to 
# avoid downloading dependencies every time image is built

# copy go mod & sum files
COPY go.mod ./
COPY go.sum ./

# dowload all dependencies
RUN go mod download

# copy source code
COPY . .

# build application by creating a binary file for our API
# (CGO_ENABLED is disabled for cross system compilation)
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o ./bin/main .

# docker multi-stage build - create small image size
# involves starting new stage from scratch (empty image)
FROM scratch

# copy the pre-built binary file
COPY --from=builder /app/bin/main .

# run executable
CMD ["./main"]