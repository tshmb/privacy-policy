#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="${SCRIPT_DIR}/sources"
OUTPUT_FILE="${SCRIPT_DIR}/catalog.json"
TEMP_FILE="${OUTPUT_FILE}.tmp"

if ! command -v jq >/dev/null 2>&1; then
  echo "jq is required to build catalog.json" >&2
  exit 1
fi

source_files=()
while IFS= read -r file; do
  source_files+=("${file}")
done < <(find "${SOURCE_DIR}" -maxdepth 1 -type f -name '*.json' | sort)

if [[ ${#source_files[@]} -eq 0 ]]; then
  echo "No source JSON files found under ${SOURCE_DIR}" >&2
  exit 1
fi

jq -s '
{
  schema_version: 1,
  published_at: (now | todateiso8601),
  templates: ([.[].templates[]] | sort_by(.manufacturer_name, .display_name, .id))
}
' "${source_files[@]}" > "${TEMP_FILE}"

duplicate_ids="$(jq -r '.templates[].id' "${TEMP_FILE}" | sort | uniq -d)"
if [[ -n "${duplicate_ids}" ]]; then
  echo "Duplicate template ids found:" >&2
  echo "${duplicate_ids}" >&2
  rm -f "${TEMP_FILE}"
  exit 1
fi

mv "${TEMP_FILE}" "${OUTPUT_FILE}"
echo "Wrote ${OUTPUT_FILE}" >&2
