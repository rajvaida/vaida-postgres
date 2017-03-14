all: build

build:
	@docker build --tag=vaida/clipper-postgres .

release: build
	@docker build --tag=vaida/clipper-postgres:$(shell cat VERSION) .
