@echo off
setlocal enabledelayedexpansion

REM Проверка аргумента
if "%~1"=="" (
    echo Укажи имя проекта при запуске: setup_hello_world.bat project-name
    exit /b 1
)

set "PROJECT=%~1"

REM Создание backend-проекта
echo ==== Creating %PROJECT%_back ====
uv init %PROJECT%_back --python 3.12
cd %PROJECT%_back
uv venv
uv add fastapi --extra standard
uv add sqlalchemy pydantic-settings
uv add --dev ruff pylint
git init
git add .
git commit -m "init"
git checkout -b dev
cd ..

REM Создание проекта для тестов
echo ==== Creating %PROJECT%_test ====
uv init %PROJECT%_test --python 3.12
cd %PROJECT%_test
uv venv
uv add --dev ruff pylint pytest httpx sqlalchemy pydantic-settings
git init
git add .
git commit -m "init"
git checkout -b dev
cd ..

REM Создание проекта для базы данных
echo ==== Creating %PROJECT%_db ====
uv init %PROJECT%_db --python 3.12
cd %PROJECT%_db
uv venv
uv add sqlalchemy alembic
uv add --dev ruff pylint
git init
git add .
git commit -m "init"
git checkout -b dev

REM Инициализация Alembic
uv run alembic init alembic


REM Замена строки подключения в alembic.ini
powershell -Command "(Get-Content alembic.ini) -replace 'sqlalchemy.url = .*', 'sqlalchemy.url = sqlite:///./db.sqlite3' | Set-Content alembic.ini"

cd ..

echo ==== Готово! ====
pause

