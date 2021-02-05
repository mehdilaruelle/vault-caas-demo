init:
	docker run --rm -v $$(pwd)/terraform:/app/ -w /app/ hashicorp/terraform:light init

infra:
	docker run --rm -v $$(pwd)/terraform:/app/ -w /app/ hashicorp/terraform:light apply -auto-approve

app:
	docker run --rm -v $$(pwd)/terraform:/app/ -w /app/ hashicorp/terraform:light apply -auto-approve

build:
	docker-compose -f app.yml build

clean:
	docker run --rm -v $$(pwd)/terraform:/app/ -w /app/ hashicorp/terraform:light destroy -auto-approve
	rm terraform/terraform.tfstate
