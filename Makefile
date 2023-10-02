# Useful Makefile scripts.
DEPLOY_PATH = .deploy
PREVIEW_PATH = .preview
PAGES_ROOT = $(HOME)/Dropbox/Documents/Su/Writing\ pieces
POSTS_ROOT = content/post
TEMP = temp

.NOTPARALLEL:

ARTICLES = \
	alex \
	aquarius \
	arithmetic \
	arthur \
	baggage \
	ben \
	borders \
	brenda \
	brownie \
	cathy \
	cats \
	daphne \
	duncan \
	elizabeth \
	gill \
	ginny \
	hastings \
	joe \
	john \
	kames \
	kay \
	kindness \
	lassie \
	lizzy \
	mazed \
	pat \
	peter \
	princes \
	ronald \
	shelter \
	syn \
	tom \
	Naja82 \
	Jack \
	WellingtonRoad \
	David \
	Andrew \
	Alison \
	Laura \
	Selfridges

# fur-coat

MARKDOWNS = $(ARTICLES:%=$(POSTS_ROOT)/%.md)
PAGES	= $(ARTICLES:%=$(PAGES_ROOT)/%.pages)
DOCS	= $(ARTICLES:%=$(TEMP)/%.docx)

deploy: themes markdowns
	git push
	hugo-deploy -d $(DEPLOY_PATH)

preview: themes markdowns
	rm -rf $(PREVIEW_PATH)
	hugo server -d $(PREVIEW_PATH) --renderToDisk=true --watch=true

themes:
	[[ -d themes/hugo-strata-theme ]] || dep refresh

markdowns: $(MARKDOWNS)

docs: $(DOCS)

check:
	@ls -l $(PAGES)

$(DOCS): $(TEMP)/%.docx: $(PAGES_ROOT)/%.pages pages-export pages-export.as
	@[[ -d $(TEMP) ]] || mkdir -p $(TEMP)
	./pages-export "$<" "$@"

$(MARKDOWNS): $(POSTS_ROOT)/%.md: $(TEMP)/%.docx doc-to-md doc-to-md.py Makefile
	./doc-to-md "$<" "$@"

check-files:
	@ls -l $(PAGES)
