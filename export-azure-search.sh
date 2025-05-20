#!/usr/bin/env bash
#export-azure-search.sh

#–– CONFIGURE THESE ––
RG="AI-Sandbox02"               # Resource group name
SERVICE="aisandboxaisearch"     # Search service name
API_VER="2025-05-01-preview"    # API version to use
#–––––––––––––––––––––––––––––––

# Generate timestamp (format: YYYYMMDD-HHMM)
TIMESTAMP=$(date +"%Y%m%d-%H%M")
OUTPUT_ROOT="${SERVICE}-export/${TIMESTAMP}"
ELEMENTS=("indexes" "indexers" "datasources" "skillsets" "synonymmaps" "aliases")

# Create output subdirectories
for elem in "${ELEMENTS[@]}"; do
  mkdir -p "$OUTPUT_ROOT/$elem"
done

echo "Retrieving admin key…"
ADMIN_KEY=$(az search admin-key show \
  --service-name "$SERVICE" \
  --resource-group "$RG" \
  --query primaryKey -o tsv)

BASE_URL="https://${SERVICE}.search.windows.net"

# Function to export elements
export_elements() {
  local endpoint="$1"
  local elem="$2"
  local name_field="${3:-name}"  # Default field is 'name'

  echo "Exporting $elem…"
  # Get the list of all element objects
  ELEMENTS_JSON=$(curl -sS -X GET \
    "$BASE_URL/$endpoint?api-version=${API_VER}" \
    -H "api-key: ${ADMIN_KEY}" \
    -H "Content-Type: application/json")

  # For aliases, the name field is 'aliasName' instead of 'name'
  ELEMENT_NAMES=$(jq -r ".value[].${name_field}" <<< "$ELEMENTS_JSON")

  for name in $ELEMENT_NAMES; do
    FILE="$OUTPUT_ROOT/$elem/${name}.json"
    curl -sS -X GET \
      "$BASE_URL/$endpoint/${name}?api-version=${API_VER}" \
      -H "api-key: ${ADMIN_KEY}" \
      -H "Content-Type: application/json" \
      | jq '.' > "$FILE"
  done
}

# Export each element type
export_elements "indexes"      "indexes"
export_elements "indexers"     "indexers"
export_elements "datasources"  "datasources"
export_elements "skillsets"    "skillsets"
export_elements "synonymmaps"  "synonymmaps"
export_elements "aliases"      "aliases" "aliasName"  # Alias uses aliasName, not name

echo "Export complete. All config files saved under $OUTPUT_ROOT/"
