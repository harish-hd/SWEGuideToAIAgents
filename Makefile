# Mermaid diagram files
MERMAID_SOURCES := $(wildcard diagrams/*.mmd)
MERMAID_OUTPUTS := $(MERMAID_SOURCES:.mmd=.png)

# LaTeX files
MAIN_TEX := main.tex
CHAPTERS := $(wildcard chapter*.tex)
OUTPUT_PDF := $(MAIN_TEX:.tex=.pdf)
OUTPUT_HTML := $(MAIN_TEX:.tex=.html)
OUTPUT_EPUB := $(MAIN_TEX:.tex=.epub)
OUTPUT_ZIP := $(MAIN_TEX:.tex=.zip)
BIB_FILE := references.bib
COVER_IMAGE := diagrams/cover.png

# Tools
MMDC := mmdc
PDFLATEX := pdflatex
BIBTEX := bibtex
PANDOC := pandoc

# Default target
all: diagrams book html epub

# Build all diagrams
diagrams: $(MERMAID_OUTPUTS)

# Pattern rule for converting .mmd to .png
diagrams/%.png: diagrams/%.mmd
	$(MMDC) -i $< -o $@

# Build the book
book: $(OUTPUT_PDF)

$(OUTPUT_PDF): $(MAIN_TEX) $(CHAPTERS) $(MERMAID_OUTPUTS) $(BIB_FILE)
	$(PDFLATEX) $(MAIN_TEX) --shell-escape

# Build the HTML page
html: $(OUTPUT_HTML)

$(OUTPUT_HTML): $(MAIN_TEX) $(CHAPTERS) $(MERMAID_OUTPUTS) $(BIB_FILE)
	$(PANDOC) $(MAIN_TEX) -o $(OUTPUT_HTML) --metadata title="Software Engineer's Guide to AI Agents" --standalone --toc --bibliography=$(BIB_FILE) --citeproc
	rm -f $(OUTPUT_ZIP)
	zip $(OUTPUT_ZIP) $(OUTPUT_HTML) $(MERMAID_OUTPUTS) $(COVER_IMAGE)

# Build the EPUB file
epub: $(OUTPUT_EPUB)

$(OUTPUT_EPUB): $(MAIN_TEX) $(CHAPTERS) $(MERMAID_OUTPUTS) $(BIB_FILE)
	$(PANDOC) $(MAIN_TEX) -o $(OUTPUT_EPUB) --metadata title="Software Engineer's Guide to AI Agents" --standalone --toc --bibliography=$(BIB_FILE) --citeproc

# Clean generated files
clean:
	rm -f *.aux *.log *.out *.toc *.fls *.fdb_latexmk *.synctex.gz $(OUTPUT_PDF) *.bbl *.blg $(OUTPUT_HTML) $(OUTPUT_EPUB) $(OUTPUT_ZIP)

# Clean everything including generated diagrams
cleanall: clean
	rm -f $(MERMAID_OUTPUTS)

.PHONY: all diagrams book clean cleanall html epub 