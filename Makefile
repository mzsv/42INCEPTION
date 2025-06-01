USERNAME	:=	johndoe

CERT_SCRIPT	=	srcs/requirements/tools/generateCerts.sh
ENV_SCRIPT	=	srcs/requirements/tools/generateEnv.sh

DUMMY_SECRETS_SCRIPT	=	srcs/requirements/tools/generateDummySecrets.sh

.DEFAULT_GOAL	=	all

all:	env	certs
	@bash	srcs/requirements/mariadb/tools/createDbPaths.sh
	@docker	compose	-f	./srcs/docker-compose.yml	up	-d	--build

build:	env	certs
	@bash	srcs/requirements/mariadb/tools/createDbPaths.sh
	@docker	compose	-f	./srcs/docker-compose.yml	build

down:
	@docker	compose	-f	./srcs/docker-compose.yml	down

clean:	down
	@docker	compose	-f	./srcs/docker-compose.yml	down	--volumes	--rmi	local	--remove-orphans
	@sudo	rm	-rf	~/data

fclean:	down
	@docker	system	prune	-af
	@sudo	rm	-rf	~/data

rebuild:	clean	all

certs:
	@sh	$(CERT_SCRIPT)	$(USERNAME)

env:
	@sh	$(ENV_SCRIPT)

dummy-secrets:
	@sh	$(DUMMY_SECRETS_SCRIPT)

.PHONY	:	all	build	down	clean	fclean	rebuild	certs	env	dummy-secrets
