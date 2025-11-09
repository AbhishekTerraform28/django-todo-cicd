# Use full Python image instead of slim to avoid missing core packages
FROM python:3.10

# Set work directory
WORKDIR /data

# Copy requirement file first
COPY requirements.txt .

# Install dependencies cleanly
RUN apt-get update && apt-get install -y --no-install-recommends gcc && \
    pip install --upgrade pip setuptools wheel && \
    pip install -r requirements.txt && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy rest of the code
COPY . .

# Run Django migrations
RUN python manage.py migrate || true

# Expose port 8000 for the app
EXPOSE 8000

# Start the Django server
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
