default: docker-build
include .env

# Note:
#	Latest version of kubectl may be found at: https://github.com/kubernetes/kubernetes/releases
# 	Latest version of helm may be found at: https://github.com/kubernetes/helm/releases
# 	Latest version of yq may be found at: https://github.com/mikefarah/yq/releases
VARS:=$(shell sed -ne 's/ *\#.*$$//; /./ s/=.*$$// p' .env )
$(foreach v,$(VARS),$(eval $(shell echo export $(v)="$($(v))")))
DOCKER_IMAGE ?= public.ecr.aws/x4w1v6p8/aws-helm-kubectl
DOCKER_TAG ?= latest #`git rev-parse --abbrev-ref HEAD`

docker-build:
	@docker buildx build \
	  --build-arg KUBE_VERSION=$(KUBE_VERSION) \
	  --build-arg HELM_VERSION=$(HELM_VERSION) \
	  --build-arg YQ_VERSION=$(YQ_VERSION) \
	  -t $(DOCKER_IMAGE):$(DOCKER_TAG) .

docker-push:
	# Push to DockerHub
	docker push $(DOCKER_IMAGE):$(DOCKER_TAG)
