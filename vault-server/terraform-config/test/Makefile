up:
	docker run --rm -v $$(pwd)/../:/app/ -w /app/ hashicorp/terraform:light init
	docker-compose up

down:
	docker-compose down
	rm ../terraform.tfstate
