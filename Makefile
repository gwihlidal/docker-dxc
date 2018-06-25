NS = gwihlidal
VERSION ?= latest

REPO = dxc
NAME = dxc
INSTANCE = default

.PHONY: build push shell run start stop rm release

build:
	docker build -t $(NS)/$(REPO):$(VERSION) .

push: build
	docker push $(NS)/$(REPO):$(VERSION)

shell: build
	docker run --rm --name $(NAME)-$(INSTANCE) --entrypoint=/bin/sh -i -t $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(REPO):$(VERSION)

run: build
	docker run --rm --name $(NAME)-$(INSTANCE) $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(REPO):$(VERSION)

start: build
	docker run -d --name $(NAME)-$(INSTANCE) $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(REPO):$(VERSION)

release: build
	make push -e VERSION=$(VERSION)

stop:
	docker stop $(NAME)-$(INSTANCE)

rm:
	docker rm $(NAME)-$(INSTANCE)

default: build