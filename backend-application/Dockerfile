# Etapa 1: Construção do backend Flask
FROM python:3.10-slim AS backend

WORKDIR /app

COPY src/ /app/
COPY requirements.txt /app/

RUN pip install --no-cache-dir -r requirements.txt

# Etapa 2: Configuração do Nginx
FROM nginx:latest

# Copiar a configuração do Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copiar o backend Flask da primeira etapa
COPY --from=backend /app /app

# Expor a porta do Nginx (80)
EXPOSE 80

# Iniciar Nginx e Flask simultaneamente
CMD ["sh", "-c", "gunicorn -b 0.0.0.0:8080 app:app & nginx -g 'daemon off;'"]
