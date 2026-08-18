PYTHON ?= python3
SOURCE_DATE_EPOCH ?= 1786691080

.PHONY: verify manuscript clean

verify:
	$(PYTHON) verify_release.py

manuscript:
	cd manuscript && SOURCE_DATE_EPOCH=$(SOURCE_DATE_EPOCH) FORCE_SOURCE_DATE=1 latexmk -pdf -interaction=nonstopmode -halt-on-error r008_far_pair_constraints.tex

clean:
	cd manuscript && latexmk -C r008_far_pair_constraints.tex
