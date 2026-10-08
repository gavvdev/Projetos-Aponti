FROM node:20-alpine3.21 AS build
WORKDIR /build
COPY app/package.json ./
RUN npm install --omit=dev --ignore-scripts && npm cache clean --force
COPY app/ ./

FROM node:20-alpine3.21
ENV NODE_ENV=production
WORKDIR /app
COPY --from=build --chown=node:node /build /app
USER node
EXPOSE 3000
CMD ["node", "server.js"]
