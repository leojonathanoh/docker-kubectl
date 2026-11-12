FROM alpine:3.24
ARG TARGETPLATFORM
ARG BUILDPLATFORM
RUN echo "I am running on $BUILDPLATFORM, building for $TARGETPLATFORM"

RUN apk add --no-cache ca-certificates

# When $TARGETPLATFORM is linux/arm/v7, strip out the '/v6' or '/v7' from it
RUN set -eux; \
    BIN_URL=https://dl.k8s.io/release/v1.25.16/bin/$( echo $TARGETPLATFORM | sed 's@/v[67]$@@' )/kubectl; \
    SHA512=$( wget -qO- "$BIN_URL.sha512" ); \
    wget -qO- "$BIN_URL"  > /usr/local/bin/kubectl; \
    chmod +x /usr/local/bin/kubectl; \
    sha512sum /usr/local/bin/kubectl | grep "^$SHA512 "; \
    kubectl version --client

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD [ "kubectl" ]
