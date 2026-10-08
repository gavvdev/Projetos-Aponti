# build (instala dependências)
FROM node:20-alpine3.21 AS builder
WORKDIR /build
COPY app/ ./app/
WORKDIR /build/app
RUN if [ -f package-lock.json ]; then npm ci --omit=dev; \
    elif [ -f package.json ]; then npm install --omit=dev; fi \
    && npm cache clean --force

# runtime (somente o necessário)
FROM node:20-alpine3.21
ENV NODE_ENV=production
WORKDIR /app/app

COPY --from=builder --chown=node:node /build/app/ ./

USER node

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD node -e "require('net').connect(3000,'127.0.0.1').on('connect',()=>process.exit(0)).on('error',()=>process.exit(1))"

CMD ["node", "server.js"]