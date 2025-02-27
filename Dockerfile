# Base
FROM node:18-alpine as base
ENV NODE_ENV production

RUN corepack enable && corepack prepare pnpm@8.4.0 --activate

# Build
FROM base as build
WORKDIR /root
COPY package*.json ./
COPY pnpm-lock.yaml ./
RUN pnpm i --frozen-lockfile --prod

# Prod
FROM base as prod
USER node
WORKDIR /home/node
COPY --chown=node:node . /home/node
COPY --chown=node:node --from=build /root/node_modules /home/node/node_modules
EXPOSE 1080 1025
ENV MAILDEV_WEB_PORT 1080
ENV MAILDEV_SMTP_PORT 1025
ENTRYPOINT ["bin/maildev"]
HEALTHCHECK --interval=10s --timeout=1s \
  CMD wget -O - http://localhost:1080/healthz || exit 1
