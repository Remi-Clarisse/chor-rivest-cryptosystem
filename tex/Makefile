# Variables
LOGBOOK=brouillon
RAPPORT=rapport-stage

# Special rules and targets
.PHONY: all clean help open beamer

# Rules and targets
all: clean $(RAPPORT)

$(LOGBOOK):
	pdflatex $(LOGBOOK).tex
	bibtex $(LOGBOOK).aux
	pdflatex $(LOGBOOK).tex
	pdflatex $(LOGBOOK).tex

$(RAPPORT):
	pdflatex $(RAPPORT).tex
	bibtex $(RAPPORT).aux
	pdflatex $(RAPPORT).tex
	pdflatex $(RAPPORT).tex

beamer: 
	pdflatex beamer.tex
	pdflatex beamer.tex

open: $(RAPPORT)
	@evince $(RAPPORT).pdf&

clean:
	@echo "./tex/ : Cleaning..."
	@rm -f *~ *.aux *.bbl *.blg *.toc *.log *.gz *.out *.pdf *.gz\(busy\) *.nav *.snm

help:
	@echo "all:\tRun the whole build to make the PDF file '$(RAPPORT).pdf'."
	@echo "open:\tBuild the PDF file '$(RAPPORT).pdf' and open it."
	@echo "clean:\tRemove all files produced by the compilation."
	@echo "help:\tDisplay the main targets of this Makefile with a short despriction."
