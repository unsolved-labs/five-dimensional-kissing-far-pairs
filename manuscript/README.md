# Manuscript build

The manuscript source is public and reproducible.

```bash
SOURCE_DATE_EPOCH=1786691080 FORCE_SOURCE_DATE=1 \
  latexmk -pdf -interaction=nonstopmode -halt-on-error \
  r008_far_pair_constraints.tex
```

The repository root also provides:

```bash
make manuscript
```

`build-metadata.json` records the SHA-256 hashes of the committed source files
and PDF. The release CI compiles the manuscript source to catch LaTeX errors
and verifies the deterministic PDF hash.
