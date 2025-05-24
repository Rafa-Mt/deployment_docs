# Build stage
FROM python:3.11-alpine as builder

WORKDIR /app

COPY requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

COPY mkdocs/ .

RUN /root/.local/bin/mkdocs build --site-dir /app/site

# Runtime stage
FROM nginx:alpine
COPY --from=builder /app/site /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]