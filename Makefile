.PHONY: build-fe build-be deploy build

build: build-fe build-be

build-fe: 
	cd frontend && yarn build

build-be:
	cd backend && ./build.sh

deploy: build-fe build-be
	cd terraform && make deploy

deploy-be: build-be
	cd terraform && make deploy

