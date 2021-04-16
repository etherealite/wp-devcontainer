# [Choice] Debian version: buster, stretch
ARG VARIANT=7

FROM wordpress:cli

FROM mcr.microsoft.com/vscode/devcontainers/php:dev-${VARIANT}

COPY --from=0 /usr/local/bin/wp /usr/local/bin/wp

# ** [Optional] Uncomment this section to install additional packages. **
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
		mariadb-client;


RUN set -eux; \
	mkdir -p /usr/local/etc/certs; \
	printf "[dn]\nCN=localhost\n[req]\ndistinguished_name = dn\n[EXT]\nsubjectAltName=DNS:localhost\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth" \
		| openssl req -x509 -out /usr/local/etc/certs/localhost.crt -keyout /usr/local/etc/certs/localhost.key \
			-newkey rsa:2048 -nodes -sha256 \
			-subj '/CN=localhost' -extensions EXT -config /dev/fd/3 3<&0; \
	chmod +r /usr/local/etc/certs/localhost.key;