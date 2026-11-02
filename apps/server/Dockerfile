# Stage 1: Build TypeScript ke JavaScript
FROM node:24-alpine AS builder

WORKDIR /app

# Aktifkan pnpm via Corepack
RUN corepack enable && corepack prepare pnpm@10.34.9 --activate

# Salin manifest dependensi
COPY apps/server/package.json apps/server/pnpm-lock.yaml ./

# Pasang seluruh dependensi untuk proses build
RUN pnpm install --frozen-lockfile

# Salin source code dan konfigurasi build
COPY apps/server/tsconfig*.json ./
COPY apps/server/src ./src

# Kompilasi TypeScript ke dist
RUN pnpm build

# Stage 2: Runtime image yang ringan dan aman
FROM node:24-alpine AS runner

RUN apk add --no-cache ffmpeg poppler-utils

WORKDIR /app

ENV NODE_ENV=development \
    HOST=0.0.0.0 \
    PORT=3000

# Aktifkan pnpm via Corepack
RUN corepack enable && corepack prepare pnpm@10.34.9 --activate

# Salin manifest dan pasang hanya production dependencies
COPY apps/server/package.json apps/server/pnpm-lock.yaml ./
RUN pnpm install --prod --frozen-lockfile

# Salin hasil kompilasi dari builder
COPY --from=builder /app/dist ./dist

# Salin migrations, openapi spec, dan entrypoint
COPY apps/server/migrations ./migrations
COPY apps/server/docker-entrypoint.sh ./docker-entrypoint.sh
COPY docs/openapi.json ./docs/openapi.json

RUN chmod +x ./docker-entrypoint.sh

EXPOSE 3000

ENTRYPOINT ["./docker-entrypoint.sh"]
