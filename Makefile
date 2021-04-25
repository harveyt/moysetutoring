# Useful Makefile scripts.
DEPLOY_PATH = .deploy
PREVIEW_PATH = .preview
PAGES_ROOT = $(HOME)/Dropbox/Documents/Su/Writing\ pieces
POSTS_ROOT = content/post
TEMP = temp

.NOTPARALLEL:

# ARTICLES = \
# 	alex \
# 	aquarius \
# 	arithmetic \
# 	arthur \
# 	baggage \
# 	ben \
# 	borders \
# 	brenda \
# 	brownie \
# 	cathy \
# 	cats \
# 	daphne \
# 	duncan \
# 	elizabeth \
# 	fur-coat \
# 	gill \
# 	ginny \
# 	hastings \
# 	joe \
# 	john \
# 	kames \
# 	kay \
# 	kindness \
# 	lassie \
# 	lizzy \
# 	mazed \
# 	pat \
# 	peter \
# 	princes \
# 	ronald \
# 	shelter \
# 	syn \
# 	tom

ARTICLES = \
	alex \
	aquarius \
	arithmetic \
	arthur \
	baggage \
	fur-coat \
	syn

MARKDOWNS = $(ARTICLES:%=$(POSTS_ROOT)/%.md)
PAGES	= $(ARTICLES:%=$(PAGES_ROOT)/%.pages)
DOCS	= $(ARTICLES:%=$(TEMP)/%.docx)

deploy: themes
	git push
	hugo-deploy -d $(DEPLOY_PATH)

preview: themes
	rm -rf $(PREVIEW_PATH)
	hugo server -d $(PREVIEW_PATH) --renderToDisk=true --watch=true

themes:
	[[ -d themes/hugo-strata-theme ]] || dep refresh

update-posts: $(MARKDOWNS)


$(DOCS): $(TEMP)/%.docx: $(PAGES_ROOT)/%.pages pages-export pages-export.as
	@[[ -d $(TEMP) ]] || mkdir -p $(TEMP)
	./pages-export "$<" "$@"

docs: $(DOCS)

$(MARKDOWNS): $(POSTS_ROOT)/%.md: $(TEMP)/%.docx doc-to-md doc-to-md.py
	./doc-to-md "$<" "$@"

markdowns: $(MARKDOWNS)

check-files:
	@ls -l $(PAGES)
