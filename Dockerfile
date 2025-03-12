from python:3
workdir /app
copy manage.py ./
run pip install Django==5.1.7
copy . .
run  python manage.py migrate
expose 8000
cmd ["python","manage.py", "runserver", "0.0.0.0:8000"]

