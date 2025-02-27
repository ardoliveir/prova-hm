# Usar a imagem base oficial do Python
FROM python:3.10-slim

# Definir diretório de trabalho
WORKDIR /app

# Copiar arquivos necessários para o container
COPY src/ /app/

# Instalar dependências
RUN pip install --no-cache-dir -r requirements.txt

# Expor a porta 8080
EXPOSE 8080

# Comando para iniciar o servidor Flask usando Gunicorn
CMD ["gunicorn", "-b", "0.0.0.0:8080", "app:app"]
