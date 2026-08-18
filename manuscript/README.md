# Manuscript build

The manuscript source and bibliography are canonical public artifacts. Build a
PDF with:

```bash
SOURCE_DATE_EPOCH=1786691080 FORCE_SOURCE_DATE=1 \
  latexmk -pdf -interaction=nonstopmode -halt-on-error \
  r008_far_pair_constraints.tex
```

The repository root also provides:

```bash
make manuscript
```

`build-metadata.json` records source SHA-256 hashes, the reference build
toolchain, and the SHA-256 of a reference PDF produced from these sources.
Different TeX Live versions may produce byte-different but equivalent PDFs, so
CI treats successful compilation as the portability check rather than requiring
a cross-version byte-identical PDF. The manuscript workflow publishes the
compiled PDF as a GitHub Actions artifact.
