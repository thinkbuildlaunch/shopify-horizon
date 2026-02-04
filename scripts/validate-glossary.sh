#!/bin/bash
# validate-glossary.sh
# Validates that glossary terms are used in the codebase
#
# Usage: ./scripts/validate-glossary.sh
# Exit codes: 0 = all terms used, 1 = unused terms found (warning only)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
GLOSSARY_FILE="$PROJECT_ROOT/docs/DOMAIN_GLOSSARY.md"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "Validating glossary term usage..."
echo ""

if [[ ! -f "$GLOSSARY_FILE" ]]; then
    echo -e "${YELLOW}Warning: Glossary file not found at $GLOSSARY_FILE${NC}"
    exit 0
fi

used_count=0
unused_count=0
terms=()

# Extract term names from glossary (### Term Name pattern)
while IFS= read -r line; do
    if [[ "$line" =~ ^###[[:space:]](.+)$ ]]; then
        term="${BASH_REMATCH[1]}"
        terms+=("$term")
    fi
done < "$GLOSSARY_FILE"

echo "Found ${#terms[@]} glossary terms"
echo ""

# Check each term for usage in codebase (excluding docs)
for term in "${terms[@]}"; do
    # Create search patterns
    # For compound terms, search for parts
    search_term=$(echo "$term" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
    alt_term=$(echo "$term" | tr '[:upper:]' '[:lower:]' | tr ' ' '_')

    # Search in relevant code directories
    found=false

    # Search in Liquid files
    if grep -riq "$term\|$search_term\|$alt_term" \
        "$PROJECT_ROOT/sections" \
        "$PROJECT_ROOT/blocks" \
        "$PROJECT_ROOT/snippets" \
        "$PROJECT_ROOT/layout" \
        "$PROJECT_ROOT/templates" \
        2>/dev/null; then
        found=true
    fi

    # Search in JS files
    if ! $found && grep -riq "$term\|$search_term\|$alt_term" \
        "$PROJECT_ROOT/assets"/*.js \
        2>/dev/null; then
        found=true
    fi

    # Search in CSS
    if ! $found && grep -riq "$search_term\|$alt_term" \
        "$PROJECT_ROOT/assets"/*.css \
        2>/dev/null; then
        found=true
    fi

    # Search in config
    if ! $found && grep -riq "$term\|$search_term\|$alt_term" \
        "$PROJECT_ROOT/config" \
        2>/dev/null; then
        found=true
    fi

    if $found; then
        echo -e "${GREEN}✓${NC} $term"
        ((used_count++))
    else
        echo -e "${YELLOW}?${NC} $term (not found in code - may be platform term)"
        ((unused_count++))
    fi
done

echo ""
echo "----------------------------------------"
echo "Validation complete"
echo -e "Terms used in code: ${GREEN}$used_count${NC}"
echo -e "Terms not found: ${YELLOW}$unused_count${NC}"
echo ""

if [[ $unused_count -gt 0 ]]; then
    echo -e "${YELLOW}Note: Some terms may be platform concepts not directly in code.${NC}"
    echo "Review unused terms periodically to ensure they're still relevant."
fi

# Always exit 0 - unused terms are warnings, not errors
exit 0
