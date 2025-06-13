# CodeQuiz

Este proyecto llamado CodeQuiz es una aplicación web educativa que está orientada a los estudiantes de ciclos formativos de informática, diseñada como un juego de preguntas y respuestas para reforzar conocimientos vistos en clase. El objetivo es hacer que el aprendizaje sea más dinámico, entretenido y competitivo, mediante partidas individuales o en modo estilo Kahoot, donde varios alumnos compiten en tiempo real.

# Tecnologías utilizadas

- Lenguaje principal: Ruby 3.0.3
- Framework web: Ruby on Rails 7
- Base de datos: PostgreSQL 15.1
- WebSockets: ActionCable
- Cola de mensajes: Redis 7
- Frontend: Bootstrap 5, JavaScript (ES6)
- Servidor web: Puma
- Sistema de autenticación: Devise
- Contenedores: Docker & Docker Compose
- Control de dependencias JS: Yarn
- Control de dependencias Ruby: Bundler

# Dependencias Ruby (Gemfile)

Algunas de las gemas clave utilizadas:

- `rails` – Framework principal
- `pg` – Adaptador para PostgreSQL
- `redis` – Soporte para Redis y ActionCable
- `devise` – Autenticación de usuarios
- `webpacker` – Gestión de assets JS (o `jsbundling-rails` si usas la nueva estructura)


# Bibliotecas externas JavaScript

- Bootstrap 5 – Interfaz responsive
- ActionCable – Para comunicación en tiempo real vía WebSockets

# Trello

- https://trello.com/b/Cs8oOYuK


# Contenedores Docker

- codequiz_web: contenedor de la aplicación Rails
- codequiz_db: contenedor PostgreSQL para la base de datos
- codequiz_redis: contenedor Redis para ActionCable

# Cómo desplegar
1. Ejecuta:

bash
docker-compose down -v
docker-compose up --build

2. Ejecutar desde la raiz del proyecto el archivo restore_dump_to_container.sh que puebla las tablas con una copia de seguridad que está en la raíz llamada codequiz.dump

bash
./restore_dump_to_container.sh

esto creara un usuario admin@gmail.com contraseña Admin123 para poder acceder como administrador a la aplicación.

