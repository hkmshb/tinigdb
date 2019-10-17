.PHONY: recreate-volume rebuild-image rcv rbi

recreate-volume:
	docker-compose down
	docker volume rm tinigdb-database_data
	docker volume create --name=tinigdb-database_data

rebuild-image: recreate-volume
	docker-compose build --no-cache

update-tinigdb:
	docker-compose exec database tinigdb-update.sh

rcv: recreate-volume
rbi: rebuild-image
udb: update-tinigdb
