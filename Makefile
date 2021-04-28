VERSION := 0.0.1
DOCKERHUB_REPO := cakiki
PROJECT_NAME := mkdocs-documentation

docker-build:
	docker build -t ${DOCKERHUB_REPO}/${PROJECT_NAME}:${VERSION} -t ${DOCKERHUB_REPO}/${PROJECT_NAME}:latest .

docker-publish: docker-build
	docker push ${DOCKERHUB_REPO}/${PROJECT_NAME}:${VERSION} && \
	docker push ${DOCKERHUB_REPO}/${PROJECT_NAME}:latest

docs-init: docker-publish
	docker run --rm -it --mount type=bind,source=${PWD},target=/docs ${DOCKERHUB_REPO}/${PROJECT_NAME}:${VERSION} new .
	
docs-build: docker-publish
	docker run --rm -it --mount type=bind,source=${PWD},target=/docs ${DOCKERHUB_REPO}/${PROJECT_NAME}:${VERSION} build

docs-serve-local: docker-publish
	docker run --rm -it -p 8000:8000 --mount type=bind,source=${PWD},target=/docs ${DOCKERHUB_REPO}/${PROJECT_NAME}:${VERSION} serve --dev-addr=0.0.0.0:8000

github-commit: docs-build
	git add . && \
	git commit -m "Update documentation" && \
	git push origin main

github-deploy: github-commit
	git subtree push --prefix site origin gh-pages