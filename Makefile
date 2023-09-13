help:
	@echo "Targets:"
	@echo "    make start"
	@echo "    make down"
	@echo "    make pull"
	@echo "    make build"
	@echo "    make lint"

start:
	docker-compose up -d

down:
	docker-compose down

pull:
	docker-compose pull

build:
	docker-compose build

lint:
	docker-compose run --rm backend pre-commit run --all-files

configure:
	echo "Creating user"
	curl -X 'POST' \
		'http://0.0.0.0:8000/users/' \
		-H 'accept: application/json' \
		-H 'Content-Type: application/json' \
		-d '{ "name": "cesar", "email": "cesar@cesar.com", "password": "cesar" }'
	echo "login"
	export BEARER_TOKEN=$(shell curl -X 'POST' \
		'http://0.0.0.0:8000/login/' \
		-H 'accept: application/json' \
		-H 'Content-Type: application/x-www-form-urlencoded' \
		-d 'grant_type=&username=cesar%40cesar.com&password=cesar' | jq -r '.access_token')

create-blog:
	curl -X 'POST' \
		'http://0.0.0.0:8000/blog/' \
		-H 'accept: application/json' \
		-H 'Authorization: Bearer ${BEARER_TOKEN}' \
		-H 'Content-Type: application/json' \
		-d '{"title": "Test blog title", "body": "Test blog body"}'

get-blogs:
	curl -X 'GET' \
		'http://0.0.0.0:8000/blog/' \
		-H 'accept: application/json' \
		-H 'Authorization: Bearer ${BEARER_TOKEN}'
