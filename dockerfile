FROM golang:1.22.7-alpine AS base

COPY go.mod ./

RUN go mod download

WORKDIR /app

COPY . .


FROM base AS dev

RUN apk add --no-cache git make
RUN go install github.com/go-delve/delve/cmd/dlv@v1.8.2
RUN go install github.com/cosmtrek/air@v1.40.4

EXPOSE 8080

CMD ["air", "-c", ".air.toml"]

FROM base AS builder

RUN CGO_ENABLED=0 GOOS=linux go build -o main .


FROM scratch AS prod

WORKDIR /app

COPY --from=builder /app/main .

COPY --from=builder /app/static ./static

EXPOSE 8080

CMD ["./main"]