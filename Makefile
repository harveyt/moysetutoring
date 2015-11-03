# Useful Makefile scripts.
DEPLOY_PATH = publish

deploy:
	cd $(DEPLOY_PATH) && rm -rf *
	hugo -d $(DEPLOY_PATH)
	cd $(DEPLOY_PATH) && git add --all && git commit -m 'Deployed website.' && git push
