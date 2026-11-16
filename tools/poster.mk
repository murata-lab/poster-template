# Build rules shared by every poster. A poster folder's Makefile is one line:
#   include ../../tools/poster.mk
# Every poster_*.html in the folder becomes poster_*.pdf (+ poster_*_preview.png).

TOOLS := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
HTML  := $(wildcard poster_*.html)
PDFS  := $(HTML:.html=.pdf)
# Rebuild when the shared design or a figure changes (keep spaces out of file names)
DEPS  := $(wildcard *.css *.js fig/*)

all: $(PDFS)                              ## build every poster_*.pdf in this folder

en: poster_en.pdf                         ## build the English PDF only
ja: poster_ja.pdf                         ## build the Japanese PDF only

%.pdf: %.html $(DEPS)
	@sh "$(TOOLS)/build.sh" "$<" "$@"

# Polls once a second (no inotify/entr needed); make itself skips unchanged sources.
watch:                                    ## rebuild on every save (Ctrl-C to stop)
	@echo "watching $(HTML), *.css, *.js and fig/ (Ctrl-C to stop)"
	@while true; do $(MAKE) -q $(PDFS) || $(MAKE) -s --no-print-directory $(PDFS); sleep 1; done

# Print shops reject Type 3 fonts; Chrome falls back to them for variable or CFF fonts.
check: $(PDFS)                            ## check fonts for print (no Type 3)
	@for f in $(PDFS); do \
	  if pdffonts "$$f" | grep -q 'Type 3'; then echo "WARNING: $$f embeds Type 3 fonts:"; pdffonts "$$f" | grep 'Type 3'; \
	  else echo "$$f: fonts OK (no Type 3)"; fi; done

clean:                                    ## delete the built PDFs and previews
	rm -f poster_*.pdf poster_*_preview.png

help:
	@grep -hE '^[a-z]+:.*## ' $(MAKEFILE_LIST) | sed 's/:.*## /\t/' | awk -F'\t' '{printf "  make %-7s %s\n", $$1, $$2}'

.PHONY: all en ja watch check clean help
