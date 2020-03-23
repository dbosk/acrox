NAME  = acrox
SHELL = bash
PWD   = $(shell pwd)
VERS  = $(shell ltxfileinfo -v $(NAME).dtx|sed -e 's/^v//')
LOCAL = $(shell kpsewhich --var-value TEXMFLOCAL)
UTREE = $(shell kpsewhich --var-value TEXMFHOME)

all:	$(NAME).pdf
	test -e README.txt && mv README.txt README || exit 0

$(NAME).pdf $(NAME).sty: $(NAME).dtx bibsp.sty crypto.bib
	latexmk -pdf -shell-escape -recorder $(NAME).dtx

clean:
	rm -f $(NAME).{aux,fls,glo,gls,hd,idx,ilg,ind,ins,log,out,blg}
	${RM} acrox.{pdf,sty}
	${RM} ex_cut.tex
	${RM} acrox.{bcf,fdb_latexmk,run.xml}
	${RM} README

distclean: clean
	rm -f $(NAME).{pdf,sty}
	${RM} bibsp.sty crypto.bib

inst: all
	mkdir -p $(UTREE)/{tex,source,doc}/latex/$(NAME)
	cp $(NAME).dtx $(UTREE)/source/latex/$(NAME)
	cp $(NAME).sty $(UTREE)/tex/latex/$(NAME)
	cp $(NAME).pdf $(UTREE)/doc/latex/$(NAME)

install: all
	sudo mkdir -p $(LOCAL)/{tex,source,doc}/latex/$(NAME)
	sudo cp $(NAME).dtx $(LOCAL)/source/latex/$(NAME)
	sudo cp $(NAME).sty $(LOCAL)/tex/latex/$(NAME)
	sudo cp $(NAME).pdf $(LOCAL)/doc/latex/$(NAME)

zip: all
	ln -sf . $(NAME)
	zip -Drq $(PWD)/$(NAME)-$(VERS).zip $(NAME)/{README,$(NAME).{pdf,dtx}}
	rm $(NAME)

INCLUDE_BIBSP=bibsp
include ${INCLUDE_BIBSP}/bibsp.mk
