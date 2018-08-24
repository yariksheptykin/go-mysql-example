all: clean build run

run: .env
	docker-compose up app

clean: .env
	docker-compose down -v

build: .env
	docker-compose build

.env: .env.dist
	cp $< $@

.PHONY: all clean build run
