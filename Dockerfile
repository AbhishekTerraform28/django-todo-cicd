# 1️⃣ Base image
FROM python:3.10-slim

# 2️⃣ Set working directory
WORKDIR /data

# 3️⃣ Copy requirement file first (better caching)
COPY requirements.txt .

# 4️⃣ Install dependencies (and fix distutils issue)
RUN apt-get update && apt-get install -y python3-distutils && \
    pip install --no-cache-dir -r requirements.txt

# 5️⃣ Copy rest of the project
COPY . .

# 6️⃣ Run migrations
RUN python manage.py migrate

# 7️⃣ Expose Django default port
EXPOSE 8000

# 8️⃣ Run the app
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
