# Dockerfile for Backend Service
FROM python:3.12-slim

# Define workdir
WORKDIR /app

# Copy requirements.txt to workdir
COPY ./requirements.txt .

# Install requirements.txt packages with pip
RUN pip install --no-cache-dir -r requirements.txt

# Copy source code to workdir
COPY src/ ./src

# Expose BE port
EXPOSE 5001

CMD ["python", "src/main.py"]