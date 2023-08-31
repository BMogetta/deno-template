# First Stage - Build the project
FROM denoland/deno:alpine-1.34.3

ENV DENO_DIR=/app/.cache
WORKDIR /app

COPY . .
RUN deno cache --lock-write deps.ts

CMD [ "deno", "task", "server" ]