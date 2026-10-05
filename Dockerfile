# Используем официальный образ Python
FROM python:3.11-slim

# Устанавливаем Poetry
RUN pip install poetry

# 🔽 КРИТИЧЕСКИЙ МОМЕНТ: Отключаем создание виртуального окружения
# Docker-образ сам по себе является изолированной средой [citation:2][citation:3][citation:10]
RUN poetry config virtualenvs.create false

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем файлы зависимостей
COPY pyproject.toml poetry.lock ./

# Устанавливаем зависимости (без dev-зависимостей)
RUN poetry install --no-dev --no-interaction --no-ansi

# Копируем код проекта
COPY . .

# Команда для запуска (будет переопределена в docker-compose)
CMD ["gunicorn", "mysite.wsgi:application", "--bind", "0.0.0.0:8000"]
