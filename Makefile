NAME  = acrox
FILES = acro.style.adx.code.tex acro.style.possessive.code.tex
SHELL = bash
PWD   = $(shell pwd)
VERS  = $(shell ltxfileinfo -v $(NAME).dtx|sed -e 's/^v//')
LOCAL = $(shell kpsewhich --var-value TEXMFLOCAL)
UTREE = $(shell kpsewhich --var-value TEXMFHOME)

all:	$(NAME).pdf ${FILES}
	test -e README.txt && mv README.txt README || exit 0

$(NAME).pdf: $(NAME).dtx ${FILES} bibsp.sty crypto.bib
	latexmk -pdf -shell-escape -recorder $(NAME).dtx

${FILES}: ${NAME}.dtx
	latexmk -pdf -shell-escape -recorder $(NAME).dtx

clean:
	rm -f $(NAME).{aux,fls,glo,gls,hd,idx,ilg,ind,ins,log,out,blg}
	${RM} acrox.{pdf,sty}
	${RM} ${FILES}
	${RM} ex_cut.tex
	${RM} acrox.{bcf,fdb_latexmk,run.xml}
	${RM} README

distclean: clean
	${RM} bibsp.sty crypto.bib

inst: all
	mkdir -p $(UTREE)/{tex,source,doc}/latex/$(NAME)
	cp $(NAME).dtx $(UTREE)/source/latex/$(NAME)
	cp ${FILES} $(UTREE)/tex/latex/$(NAME)
	cp $(NAME).pdf $(UTREE)/doc/latex/$(NAME)

install: all
	sudo mkdir -p $(LOCAL)/{tex,source,doc}/latex/$(NAME)
	sudo cp $(NAME).dtx $(LOCAL)/source/latex/$(NAME)
	sudo cp ${FILES} $(LOCAL)/tex/latex/$(NAME)
	sudo cp $(NAME).pdf $(LOCAL)/doc/latex/$(NAME)

zip: all
	ln -sf . $(NAME)
	zip -Drq $(PWD)/$(NAME)-$(VERS).zip $(NAME)/{README,$(NAME).{pdf,dtx}}
	rm $(NAME)

INCLUDE_BIBSP=bibsp
include ${INCLUDE_BIBSP}/bibsp.mk
