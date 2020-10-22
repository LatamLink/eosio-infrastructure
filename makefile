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
		-f ./bios/Dockerfile \
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
		--from-file kubernetes/configs/writer/ \
		--dry-run=client \
		-o yaml | \
		yq w - metadata.labels.version $(VERSION) | \
		kubectl -n lacchain apply -f -
	@kubectl create secret tls \
		tls-secret \
		--key ./ssl/eosio.cr.priv.key \
		--cert ./ssl/eosio.cr.crt \
		-n lacchain || echo "SSL cert already configured.";
	@$(SHELL_EXPORT) envsubst <./kubernetes/configs/genesis/genesis.json > /tmp/$(VERSION)/genesis.json
	@kubectl create configmap \
		genesis-config \
		--from-file /tmp/$(VERSION)/genesis.json \
		--dry-run=client \
		-o yaml | \
		yq w - metadata.labels.version $(VERSION) | \
		kubectl -n lacchain apply -f -
	@kubectl create configmap \
		boot-config \
		--from-file kubernetes/configs/boot/ \
		--dry-run=client \
		-o yaml | \
		yq w - metadata.labels.version $(VERSION) | \
		kubectl -n lacchain apply -f -
	@kubectl create configmap \
		observer-config \
		--from-file kubernetes/configs/observer/ \
		--dry-run=client \
		-o yaml | \
		yq w - metadata.labels.version $(VERSION) | \
		kubectl -n lacchain apply -f -
	@kubectl create configmap \
		validator-config \
		--from-file kubernetes/configs/validator/ \
		--dry-run=client \
		-o yaml | \
		yq w - metadata.labels.version $(VERSION) | \
		kubectl -n lacchain apply -f -
	@kubectl create configmap \
		wallet-config \
		--from-file kubernetes/configs/wallet/ \
		--dry-run=client \
		-o yaml | \
		yq w - metadata.labels.version $(VERSION) | \
		kubectl -n lacchain apply -f -
	@echo "Applying lacchain configuartions for lacchain nodes..."
	@$(SHELL_EXPORT) envsubst <./kubernetes/boot/boot.service.yml | kubectl -n lacchain apply -f -;
	@$(SHELL_EXPORT) envsubst <./kubernetes/boot/boot.statefulset.yml | kubectl -n lacchain apply -f - || echo "Statefulset cannot be updated.";
	@$(SHELL_EXPORT) envsubst <./kubernetes/middleware/middleware.service.yml | kubectl -n lacchain apply -f -;
	@$(SHELL_EXPORT) envsubst <./kubernetes/middleware/middleware.deployment.yml | kubectl -n lacchain apply -f -;
	@$(SHELL_EXPORT) envsubst <./kubernetes/writer/writer.service.yml | kubectl -n lacchain apply -f -;
	@$(SHELL_EXPORT) envsubst <./kubernetes/writer/writer.statefulset.yml | kubectl -n lacchain apply -f - || echo "Statefulset cannot be updated.";
	@$(SHELL_EXPORT) envsubst <./kubernetes/observer/observer.service.yml | kubectl -n lacchain apply -f -;
	@$(SHELL_EXPORT) envsubst <./kubernetes/observer/observer.statefulset.yml | kubectl -n lacchain apply -f - || echo "Statefulset cannot be updated.";
	@$(SHELL_EXPORT) envsubst <./kubernetes/validator/validator.service.yml | kubectl -n lacchain apply -f -;
	@$(SHELL_EXPORT) envsubst <./kubernetes/validator/validator.statefulset.yml | kubectl -n lacchain apply -f - || echo "Statefulset cannot be updated.";
	@$(SHELL_EXPORT) envsubst <./kubernetes/wallet/wallet.service.yml | kubectl -n lacchain apply -f -;
	@$(SHELL_EXPORT) envsubst <./kubernetes/wallet/wallet.statefulset.yml | kubectl -n lacchain apply -f - || echo "Statefulset cannot be updated.";
	@$(SHELL_EXPORT) envsubst <./kubernetes/lacchain-secrets.configmap.yml | kubectl -n lacchain apply -f -;
	@$(SHELL_EXPORT) envsubst <./kubernetes/lacchain.storageclass.yml | kubectl -n lacchain apply -f - || echo "Storage Class cannot be updated.";
	@$(SHELL_EXPORT) envsubst <./kubernetes/api.ingress.yml | kubectl -n lacchain apply -f -;

delete-lacchain:
	@kubectl delete service,pv,pvc,statefulset,configmap -l version=$(VERSION)