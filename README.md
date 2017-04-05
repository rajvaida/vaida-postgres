
#Quick Start

docker run --name postgresql -itd --restart always --publish 5432:5432 --env 'PG_PASSWORD=4amys3c6927' --env 'DB_USER=clipper' --env 'DB_PASS=ClipPos76resPa$$' --env 'DB_NAME=clipal'  --volume /opt/docker/backups/postgresql.$(date +%Y%m%d%H%M%S):/var/lib/postgresql vaida/vaida-postgres:latest  -c log_connections=on

#SQL Prompt

docker exec -it postgresql sudo -u postgres psql clipal clipper

#bash

docker exec -it postgresql bash