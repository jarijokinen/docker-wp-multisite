local:
	docker build -t jarijokinen/wp-multisite -f ./Dockerfile .

push:
	docker push jarijokinen/wp-multisite
