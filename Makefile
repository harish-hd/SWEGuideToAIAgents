# Mermaid diagram files
MERMAID_SOURCES := $(wildcard diagrams/*.mmd)
MERMAID_OUTPUTS := $(MERMAID_SOURCES:.mmd=.png)

# LaTeX files
MAIN_TEX := main.tex
CHAPTERS := $(wildcard chapter*.tex)
OUTPUT_PDF := $(MAIN_TEX:.tex=.pdf)
BIB_FILE := references.bib

# Tools
MMDC := mmdc
PDFLATEX := pdflatex
BIBTEX := bibtex

# Default target
all: diagrams book

# Build all diagrams
diagrams: $(MERMAID_OUTPUTS)

# Pattern rule for converting .mmd to .png
diagrams/%.png: diagrams/%.mmd
	$(MMDC) -i $< -o $@

# Build the book
book: $(OUTPUT_PDF)

$(OUTPUT_PDF): $(MAIN_TEX) $(CHAPTERS) $(MERMAID_OUTPUTS) $(BIB_FILE)
	$(PDFLATEX) $(MAIN_TEX) --shell-escape

# Clean generated files
clean:
	rm -f *.aux *.log *.out *.toc *.fls *.fdb_latexmk *.synctex.gz $(OUTPUT_PDF) *.bbl *.blg

# Clean everything including generated diagrams
cleanall: clean
	rm -f $(MERMAID_OUTPUTS)

.PHONY: all diagrams book clean cleanall 