# Useful Makefile scripts.
DEPLOY_PATH = .deploy
PREVIEW_PATH = .preview
PAGES_ROOT = $(HOME)/Dropbox/Documents/Su/Writing\ pieces
POSTS_ROOT = content/post
TEMP = temp

.NOTPARALLEL:

# ARTICLES = \
# 	Alison \
# 	Andrew \
# 	David \
# 	Jack \
# 	Laura \
# 	Naja82 \
# 	Selfridges \
# 	WellingtonRoad \
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
# 	tom \

ARTICLES = \
	Awareness \
	Conversation

# Coversation
# Coronation
# Evie
# Finish - there is a child
# Give Me
# Harvey's poem
# I will not
# Jan
# Joan
# Mimi
# Petunia
# There was a man
# There was a man too
# Why do you

# fur-coat

## Christmas - work on

##
## Alice
## Alone
## Bus notes
## Cash
## Corona
## First house
## Giddy Aunt
## Hairdresser
## If you really knew me
## In-Laws
## Infant school notes
## Jack creative writing
## Joyce
## Kames first person version
## Lassy copy
## Mum/Dad sayings
## my little town pain
## Never Again
## Petunia and friends
## proficiency
## reponse writing
## Robert B
## Roy
## Sally
## Sandra
## Scotland notes
## security
## Speaking up
## Stan
## Sylvia
## The Power
## Wearing the wrong thing
## What a girl wants what a girl needs


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
