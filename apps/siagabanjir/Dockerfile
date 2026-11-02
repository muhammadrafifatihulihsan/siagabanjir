# Stage 1: Build Flutter Web menggunakan CirrusLabs Flutter Stable
FROM ghcr.io/cirruslabs/flutter:3.27.0 AS builder

WORKDIR /app

# Salin dependensi Flutter
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

# Salin kode sumber aplikasi
COPY . .

# Kompilasi Flutter Web dalam mode rilis
RUN flutter config --enable-web && flutter build web --release

# Stage 2: Sajikan hasil build menggunakan Nginx Alpine
FROM nginx:1.27-alpine AS runner

COPY --from=builder /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
