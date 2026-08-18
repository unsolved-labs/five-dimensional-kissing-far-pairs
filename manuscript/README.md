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

`build-metadata.json` records the content-addressed Git blob object ID for each
manuscript source file. `verify_release.py` recomputes those object IDs from the
checked-out bytes. CI compiles the public source on its reference environment,
validates that a PDF is produced, and publishes the PDF as a GitHub Actions
artifact.

PDF bytes are not required to be identical across TeX distributions; the
source identity and successful clean-run compilation are the reproducibility
boundary.
