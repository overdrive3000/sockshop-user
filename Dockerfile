FROM golang:1.16-buster AS build

WORKDIR /app
COPY go.mod ./
COPY go.sum ./
#RUN go mod download
RUN go env -w GOPROXY=direct && go mod download
COPY . .

RUN go build -o /user

FROM gcr.io/distroless/base-debian11
WORKDIR /
COPY --from=build /user /user

ENV MONGO_HOST mytestdb:27017
ENV HATEAOS user
ENV USER_DATABASE mongodb

EXPOSE 8084

ENTRYPOINT ["/user"]
