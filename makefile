include jungle/makefile mainnet/makefile lacchain/makefile lifebank/makefile
include mkutils/meta.mk mkutils/help.mk 

build-docker: ##@devops Builds a new  production docker image
build-docker:
	@docker build \
		--target prod-stage \
		-t $(DOCKER_REGISTRY)/$(IMAGE_NAME):$(EOSIO_VERSION) \
		.

publish-docker: ##@devops Publishes latest built docker image
publish-docker:
	@echo $(DOCKER_PASSWORD) | docker login \
		--username $(DOCKER_USERNAME) \
		--password-stdin
	@docker push $(DOCKER_REGISTRY)/$(IMAGE_NAME):$(EOSIO_VERSION)


build-eosio-cdt-docker: ##@devops Builds a new  production docker image
build-eosio-cdt-docker:
	@docker build \
		--target prod-stage \
		-t $(DOCKER_REGISTRY)/$(CDT_IMAGE_NAME):$(EOSIO_VERSION) \
		-f ./lifebank/Dockerfile \
		./lifebank  \
		--no-cache

publish-eosio-cdt-docker: ##@devops Publishes latest built docker image
publish-eosio-cdt-docker:
	@echo $(DOCKER_PASSWORD) | docker login \
		--username $(DOCKER_USERNAME) \
		--password-stdin
	@docker push $(DOCKER_REGISTRY)/$(CDT_IMAGE_NAME):$(EOSIO_VERSION)

apply-lacchain: ###devops Applies lacchain configurations based on source files
apply-lacchain:
	@echo "Creating the configmaps for config files of each role..."
	@mkdir -p /tmp/$(VERSION)/
	@kubectl create ns lacchain || echo "Namespace 'lacchain' already exists.";
	@kubectl create configmap \
		writer-config \
		--from-file lacchain/configs/writer/ \
		--dry-run=client \
		-o yaml | \
		yq w - metadata.labels.version $(VERSION) | \
		kubectl -n lacchain apply -f -
	@kubectl create secret tls \
		tls-secret \
		--key ./ssl/eosio.cr.priv.key \
		--cert ./ssl/eosio.cr.crt \
		-n lacchain || echo "SSL cert already configured.";
	@$(SHELL_EXPORT) envsubst <./lacchain/configs/genesis/genesis.json > /tmp/$(VERSION)/genesis.json
	@kubectl create configmap \
		genesis-config \
		--from-file /tmp/$(VERSION)/genesis.json \
		--dry-run=client \
		-o yaml | \
		yq w - metadata.labels.version $(VERSION) | \
		kubectl -n lacchain apply -f -
	@kubectl create configmap \
		boot-config \
		--from-file lacchain/configs/boot/ \
		--dry-run=client \
		-o yaml | \
		yq w - metadata.labels.version $(VERSION) | \
		kubectl -n lacchain apply -f -
	@kubectl create configmap \
		observer-config \
		--from-file lacchain/configs/observer/ \
		--dry-run=client \
		-o yaml | \
		yq w - metadata.labels.version $(VERSION) | \
		kubectl -n lacchain apply -f -
	@kubectl create configmap \
		validator-config \
		--from-file lacchain/configs/validator/ \
		--dry-run=client \
		-o yaml | \
		yq w - metadata.labels.version $(VERSION) | \
		kubectl -n lacchain apply -f -
	@kubectl create configmap \
		wallet-config \
		--from-file lacchain/configs/wallet/ \
		--dry-run=client \
		-o yaml | \
		yq w - metadata.labels.version $(VERSION) | \
		kubectl -n lacchain apply -f -
	@echo "Applying lacchain configuartions for lacchain nodes..."
	@$(SHELL_EXPORT) envsubst <./lacchain/boot/boot.service.yml | kubectl -n lacchain apply -f -;
	@$(SHELL_EXPORT) envsubst <./lacchain/boot/boot.statefulset.yml | kubectl -n lacchain apply -f - || echo "Statefulset cannot be updated.";
	@$(SHELL_EXPORT) envsubst <./lacchain/middleware/middleware.service.yml | kubectl -n lacchain apply -f -;
	@$(SHELL_EXPORT) envsubst <./lacchain/middleware/middleware.deployment.yml | kubectl -n lacchain apply -f -;
	@$(SHELL_EXPORT) envsubst <./lacchain/writer/writer.service.yml | kubectl -n lacchain apply -f -;
	@$(SHELL_EXPORT) envsubst <./lacchain/writer/writer.statefulset.yml | kubectl -n lacchain apply -f - || echo "Statefulset cannot be updated.";
	@$(SHELL_EXPORT) envsubst <./lacchain/observer/observer.service.yml | kubectl -n lacchain apply -f -;
	@$(SHELL_EXPORT) envsubst <./lacchain/observer/observer.statefulset.yml | kubectl -n lacchain apply -f - || echo "Statefulset cannot be updated.";
	@$(SHELL_EXPORT) envsubst <./lacchain/validator/validator.service.yml | kubectl -n lacchain apply -f -;
	@$(SHELL_EXPORT) envsubst <./lacchain/validator/validator.statefulset.yml | kubectl -n lacchain apply -f - || echo "Statefulset cannot be updated.";
	@$(SHELL_EXPORT) envsubst <./lacchain/wallet/wallet.service.yml | kubectl -n lacchain apply -f -;
	@$(SHELL_EXPORT) envsubst <./lacchain/wallet/wallet.statefulset.yml | kubectl -n lacchain apply -f - || echo "Statefulset cannot be updated.";
	@$(SHELL_EXPORT) envsubst <./lacchain/lacchain-secrets.configmap.yml | kubectl -n lacchain apply -f -;
	@$(SHELL_EXPORT) envsubst <./lacchain/lacchain.storageclass.yml | kubectl -n lacchain apply -f - || echo "Storage Class cannot be updated.";
	@$(SHELL_EXPORT) envsubst <./lacchain/api.ingress.yml | kubectl -n lacchain apply -f -;

delete-lacchain:
	@kubectl delete service,pv,pvc,statefulset,configmap -l version=$(VERSION)