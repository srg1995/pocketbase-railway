FROM alpine:latest

ARG PB_VERSION=0.30.0

RUN apk add --no-cache unzip ca-certificates bash curl

# Crear carpeta de datos persistente
RUN mkdir -p /pb_data /pb

# Descargar y descomprimir PocketBase
ADD https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_amd64.zip /tmp/pb.zip
RUN unzip /tmp/pb.zip -d /pb/

EXPOSE 8080

# Arrancar PocketBase usando la carpeta persistente
CMD ["/pb/pocketbase", "serve", "--dir", "/pb_data", "--http=0.0.0.0:8080"]