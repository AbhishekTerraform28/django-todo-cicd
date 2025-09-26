# Use a Python version compatible with Django 3.2
FROM python:3.11

# Set working directory
WORKDIR /data

# Install Django
RUN pip install --no-cache-dir django==3.2

# Copy project files
COPY . .

# Apply migrations
RUN python manage.py migrate

# Expose port 8000
EXPOSE 8000

# Run Django server
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
