FROM golang:1.22.5-alpine AS base

WORKDIR /app

COPY go.mod ./

RUN go mod download

COPY . .


FROM base AS dev

RUN go install github.com/go-delve/delve/cmd/dlv@v1.8.2
RUN go install github.com/cosmtrek/air@1.22.0

CMD ["air", "-c", ".air.toml"]


FROM base AS builder

RUN CGO_ENABLED=0 GOOS=linux go build -o main .


FROM scratch AS prod

WORKDIR /app

COPY --from=builder /app/main .

COPY --from=builder /app/static ./static

EXPOSE 8080

CMD ["./main"]