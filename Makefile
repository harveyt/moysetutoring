# Useful Makefile scripts.
DEPLOY_PATH = publish

deploy:
	hugo-deploy -d $(DEPLOY_PATH)
