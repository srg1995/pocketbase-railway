FROM golang:1.22-alpine AS builder

ARG PB_VERSION=0.30.0

RUN apk add --no-cache unzip

WORKDIR /pb

# Descargar PocketBase
ADD https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_amd64.zip /tmp/pb.zip
RUN unzip /tmp/pb.zip -d /pb/

# Copiar main.go personalizado
COPY main.go /build/main.go
COPY go.mod /build/go.mod
COPY go.sum /build/go.sum

WORKDIR /build

RUN go mod tidy && go build -o pocketbase main.go

# Final stage
FROM alpine:latest

RUN apk add --no-cache ca-certificates bash curl

# Crear carpeta de datos persistente
RUN mkdir -p /pb_data

# Copiar el binario compilado
COPY --from=builder /build/pocketbase /pb/pocketbase

EXPOSE 8080

CMD ["/pb/pocketbase", "serve", "--dir", "/pb_data", "--http=0.0.0.0:8080"]