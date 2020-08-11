FROM node:14-alpine
LABEL maintainer="Julio Cesar <julio@blackdevs.com.br>"

WORKDIR /app

COPY ./package.json ./yarn.lock /app/
RUN yarn install
COPY ./ /app
RUN chmod +x /app/docker-entrypoint.sh

EXPOSE 40000

CMD ["yarn", "start"]
