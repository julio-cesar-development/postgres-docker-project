FROM node:14-alpine
LABEL AUTHOR="Julio Cesar <julio.scheidt@leads2b.com>"

WORKDIR /app

ARG API_PORT
ENV API_PORT=${API_PORT:-40000}
RUN echo "API port ${API_PORT}"

RUN apk update && \
    apk add postgresql && \
    apk add netcat-openbsd

COPY ./package*.json ./
RUN npm install
COPY . .

EXPOSE $API_PORT

CMD ["node", "index.js"]

# apk update
# apk add postgresql
# apk add netcat-openbsd
# apk list

# network troubleshooting
# nc -vvv pg-db 5432
# ping pg-db

# sudo - postgres

# psql -h ${POSTGRES_HOST} -p 5432 -U ${POSTGRES_USER} -W
# psql -h pg-db -p 5432 -U postgres -W

# SELECT * FROM postgres_table;

# -h, --host=HOSTNAME      database server host or socket directory (default: "local socket")
# -p, --port=PORT          database server port (default: "5432")
# -U, --username=USERNAME  database user name (default: "postgres")
# -w, --no-password        never prompt for password
# -W, --password           force password prompt (should happen automatically)

# list databases
# \l

# connect to a database
# \c ${POSTGRES_DB}
# \c postgres_db

# list tables
# \dt

# docker container exec -it pg-api sh
