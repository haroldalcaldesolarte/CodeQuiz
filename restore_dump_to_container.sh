#!/bin/bash

DUMP_FILE=codequiz.dump
CONTAINER=codequiz_db
DB_NAME=CodeQuiz_development

echo "Copiando '$DUMP_FILE' al contenedor '$CONTAINER'..."
docker cp $DUMP_FILE $CONTAINER:/tmp/$DUMP_FILE

echo "Restaurando base de datos '$DB_NAME' dentro del contenedor..."
docker exec -u postgres "$CONTAINER" pg_restore --data-only --disable-triggers -d "$DB_NAME" "/tmp/$DUMP_FILE"

echo "Limpiando archivos temporales..."
docker exec $CONTAINER rm /tmp/$DUMP_FILE

echo "✅ Base de datos restaurada correctamente."
