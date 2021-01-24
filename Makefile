# Useful Makefile scripts.
DEPLOY_PATH = .deploy
PREVIEW_PATH = .preview
PAGES = $(HOME)/Documents/Su/Writing\ pieces
POSTS = content/post
TEMP = temp

deploy: themes
	git push
	hugo-deploy -d $(DEPLOY_PATH)

preview: themes
	rm -rf $(PREVIEW_PATH)
	hugo server -d $(PREVIEW_PATH) --renderToDisk=true --watch=true

themes:
	[[ -d themes/hugo-strata-theme ]] || dep refresh

update-texts: $(POSTS)/cats.md

$(TEMP)/cats.txt: $(PAGES)/Cats.pages pages-export
	[[ -d $(TEMP) ]] || mkdir -p $(TEMP)
	./pages-export "$<" "$@"

$(POSTS)/cats.md: $(TEMP)/cats.txt txt-to-md
	./txt-to-md "$<" "$@"
