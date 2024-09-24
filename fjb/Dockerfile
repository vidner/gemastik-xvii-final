FROM node:20-slim AS base

ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"

RUN corepack enable

WORKDIR /app

COPY ./frontend/package.json ./frontend/pnpm-lock.yaml /app/
RUN pnpm install --frozen-lockfile

FROM base AS build

COPY ./frontend/ /app/
RUN pnpm run build

FROM ghcr.io/circleous/httpd:latest@sha256:8a353b1208a4871233845d9a84eb4f40c4581a7acaed505de4ccdd52c8d56615

WORKDIR /app

COPY ./kauth /app/kauth/

RUN set eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		openssh-server \
		pkg-config \
		gcc \
		curl \
		make \
		lua5.3 \
		liblua5.3-dev \
		libsodium-dev \
		libsqlite3-dev \
		luarocks \
	; \
    luarocks-5.3 install lua-cjson; \
    luarocks-5.3 install lsqlite3; \
    luarocks-5.3 install bcrypt; \
	cd kauth; \
	luarocks-5.3 make; \
	cd ..; \
	rm -rf kauth;\
	apt-get remove -y \
		pkg-config \
		gcc \
		make \
		lua5.3 \
		liblua5.3-dev; \
	echo root:${PASSWORD} | chpasswd \
	echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config; \
	echo "PermitRootLogin yes" >> /etc/ssh/sshd_config; \
	service ssh start; \
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false;		

COPY httpd-foreground /usr/local/bin/
COPY ./httpd.conf /usr/local/apache2/conf/httpd.conf
COPY --chown=www-data:www-data ./fjb.db /app/data/fjb.db
COPY --from=build /app/dist /usr/local/apache2/htdocs
COPY ./src/ /app/lua/

RUN sed -ri "s/SECRETSECRETSECRETSECRETSECRETSE/$(openssl rand -hex 16)/g" /app/lua/secret.lua && \
	chmod 644 /app/lua/secret.lua

EXPOSE 80
CMD ["httpd-foreground"]
