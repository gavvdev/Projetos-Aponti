FROM ubuntu:latest

WORKDIR /app

COPY . .

RUN apt-get update
RUN apt-get install -y nodejs npm

RUN npm install

ENV DB_PASSWORD=123456

EXPOSE 3000

CMD ["node", "app/server.js"]