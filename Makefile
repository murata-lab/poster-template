# Repository root. Day-to-day work happens inside a poster folder:
#   cd posters/<name> && make watch
# The targets here create posters, install the PDF printer, and build everything.

POSTERS := $(patsubst %/,%,$(wildcard posters/*/))

help:                     ## show this help
	@echo "Repository root:"
	@grep -hE '^[a-z]+:.*## ' Makefile | sed 's/:.*## /\t/' | awk -F'\t' '{printf "  make %-28s %s\n", $$1, $$2}'
	@echo "Inside posters/<name>/:"
	@$(MAKE) --no-print-directory -s -C posters/_template help
	@echo "Posters: $(notdir $(POSTERS))"

new:                      ## make new NAME=jsai2027  -> copy posters/_template to posters/jsai2027
	@test -n "$(NAME)" || { echo "usage: make new NAME=<folder name, e.g. jsai2027>"; exit 1; }
	@test ! -e posters/$(NAME) || { echo "posters/$(NAME) already exists"; exit 1; }
	@cp -R posters/_template posters/$(NAME)
	@rm -f posters/$(NAME)/poster_*.pdf posters/$(NAME)/poster_*_preview.png
	@echo "created posters/$(NAME)/ — next:  cd posters/$(NAME) && make watch"

watch:                    ## make watch P=<name>     -> same as cd posters/<name> && make watch
	@test -n "$(P)" || { echo "usage: make watch P=<name>   (posters: $(notdir $(POSTERS)))"; exit 1; }
	@$(MAKE) --no-print-directory -C posters/$(P) watch

all:                      ## build every poster
	@for d in $(POSTERS); do echo "== $$d"; $(MAKE) --no-print-directory -C $$d || exit 1; done

setup:                    ## install a headless Chrome for printing (no sudo)
	@if command -v npx >/dev/null 2>&1; then npx -y playwright install chromium-headless-shell; \
	elif command -v uvx >/dev/null 2>&1; then uvx playwright install chromium-headless-shell; \
	elif python3 -c 'import playwright' 2>/dev/null; then python3 -m playwright install chromium-headless-shell; \
	else echo "Need one of: Node.js (npx), uv (uvx), or 'pip install playwright'. Or install Google Chrome."; exit 1; fi
	@$(MAKE) --no-print-directory doctor

doctor:                   ## check that the tools are installed
	@if c=$$(sh tools/find-chrome.sh); then echo "OK   Chrome: $$c"; else echo "MISSING Chrome  -> make setup (or install Google Chrome)"; fi
	@for t in pdfinfo pdftoppm pdftotext pdffonts; do \
	  if command -v $$t >/dev/null 2>&1; then echo "OK   $$t"; \
	  else echo "MISSING $$t (optional: preview PNG / overflow check)  -> sudo apt install poppler-utils / brew install poppler"; fi; done

.PHONY: help new watch all setup doctor
