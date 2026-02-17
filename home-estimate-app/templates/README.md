# HomeEstimateApp Template Catalog

This directory publishes the remote template catalog consumed by HomeEstimateApp.

## URLs

- Catalog JSON: `https://documents.meganedev.com/home-estimate-app/templates/catalog.json`
- Directory index: `https://documents.meganedev.com/home-estimate-app/templates/`

## Source files

Place per-template source JSON files in `sources/`.
Each source file should follow `TemplateCatalogPayload` format:

- `schema_version`
- `published_at`
- `templates[]`

## Rebuild catalog

```bash
cd home-estimate-app/templates
./build_catalog.sh
```

The script merges all `sources/*.json`, validates duplicate template IDs, and writes `catalog.json`.
