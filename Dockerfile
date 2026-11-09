FROM node:24-alpine@sha256:a34ab6d7f6f4813f4d0c5469d74685604b962fbdbf5793a7bc7b4998ecb867c8 AS deps
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci

FROM node:24-alpine@sha256:a34ab6d7f6f4813f4d0c5469d74685604b962fbdbf5793a7bc7b4998ecb867c8 AS build
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN npm run build
ARG GIT_SHA
RUN echo "$GIT_SHA" | grep -Eq '^[0-9a-f]{40}$' && printf '%s' "$GIT_SHA" > /app/revision.txt

FROM alpine:3.23@sha256:469c9ea410b9215eaee7976ba6c0639039b444be8e5d638f7abbada189971eb2 AS runtime
RUN apk add --no-cache libstdc++ && addgroup -S app && adduser -S -G app app
WORKDIR /app
ENV NODE_ENV=production PORT=3000 HOSTNAME=0.0.0.0
COPY --from=build /usr/local/bin/node /usr/local/bin/node
COPY --from=build /app/.next/standalone ./
COPY --from=build /app/.next/static ./.next/static
COPY --from=build /app/revision.txt ./revision.txt
USER app
EXPOSE 3000
CMD ["node", "server.js"]
