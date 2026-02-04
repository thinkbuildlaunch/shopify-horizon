#!/bin/bash
# check-doc-limits.sh
# Checks documentation against size and count limits
#
# Usage: ./scripts/check-doc-limits.sh
# Exit codes: 0 = within limits, 1 = limits exceeded

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
DOCS_DIR="$PROJECT_ROOT/docs"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Limits from Adaptive Documentation Protocol
MAX_DOCS=40
MAX_ADRS=30
MAX_DIRECTIVES=20
MAX_GLOSSARY_TERMS=50
MAX_DOC_LINES=800
MAX_OVERVIEW_LINES=500
MAX_TOTAL_LINES=10000

echo "Checking documentation limits..."
echo ""

violations=0
warnings=0

# Count documents
doc_count=$(find "$DOCS_DIR" -name "*.md" -type f 2>/dev/null | wc -l)
if [[ -f "$PROJECT_ROOT/PRODUCT_OVERVIEW.md" ]]; then
    ((doc_count++))
fi

echo "Document Counts"
echo "---------------"

if [[ $doc_count -gt $MAX_DOCS ]]; then
    echo -e "${RED}✗${NC} Total docs: $doc_count (max: $MAX_DOCS)"
    ((violations++))
elif [[ $doc_count -gt $((MAX_DOCS * 80 / 100)) ]]; then
    echo -e "${YELLOW}!${NC} Total docs: $doc_count (max: $MAX_DOCS) - approaching limit"
    ((warnings++))
else
    echo -e "${GREEN}✓${NC} Total docs: $doc_count (max: $MAX_DOCS)"
fi

# Count ADRs
adr_count=$(find "$DOCS_DIR/adr" -name "ADR_*.md" -type f 2>/dev/null | wc -l)
if [[ $adr_count -gt $MAX_ADRS ]]; then
    echo -e "${RED}✗${NC} ADRs: $adr_count (max: $MAX_ADRS)"
    ((violations++))
else
    echo -e "${GREEN}✓${NC} ADRs: $adr_count (max: $MAX_ADRS)"
fi

# Count directives
directive_count=$(find "$DOCS_DIR/directives" -name "DIRECTIVE_*.md" -type f 2>/dev/null | wc -l)
if [[ $directive_count -gt $MAX_DIRECTIVES ]]; then
    echo -e "${RED}✗${NC} Directives: $directive_count (max: $MAX_DIRECTIVES)"
    ((violations++))
else
    echo -e "${GREEN}✓${NC} Directives: $directive_count (max: $MAX_DIRECTIVES)"
fi

# Count glossary terms
glossary_file="$DOCS_DIR/DOMAIN_GLOSSARY.md"
if [[ -f "$glossary_file" ]]; then
    term_count=$(grep -c "^### " "$glossary_file" 2>/dev/null || echo 0)
    if [[ $term_count -gt $MAX_GLOSSARY_TERMS ]]; then
        echo -e "${RED}✗${NC} Glossary terms: $term_count (max: $MAX_GLOSSARY_TERMS)"
        ((violations++))
    else
        echo -e "${GREEN}✓${NC} Glossary terms: $term_count (max: $MAX_GLOSSARY_TERMS)"
    fi
fi

echo ""
echo "Line Counts"
echo "-----------"

# Check individual document sizes
oversized_docs=()

# Check PRODUCT_OVERVIEW.md
if [[ -f "$PROJECT_ROOT/PRODUCT_OVERVIEW.md" ]]; then
    lines=$(wc -l < "$PROJECT_ROOT/PRODUCT_OVERVIEW.md")
    if [[ $lines -gt $MAX_OVERVIEW_LINES ]]; then
        oversized_docs+=("PRODUCT_OVERVIEW.md: $lines lines (max: $MAX_OVERVIEW_LINES)")
    fi
fi

# Check other docs
while IFS= read -r doc; do
    lines=$(wc -l < "$doc")
    filename=$(basename "$doc")

    # PRODUCT_OVERVIEW has lower limit
    if [[ "$filename" == "PRODUCT_OVERVIEW.md" ]]; then
        max=$MAX_OVERVIEW_LINES
    else
        max=$MAX_DOC_LINES
    fi

    if [[ $lines -gt $max ]]; then
        rel_path=${doc#$PROJECT_ROOT/}
        oversized_docs+=("$rel_path: $lines lines (max: $max)")
    fi
done < <(find "$DOCS_DIR" -name "*.md" -type f 2>/dev/null)

if [[ ${#oversized_docs[@]} -gt 0 ]]; then
    echo -e "${RED}✗${NC} Oversized documents:"
    for doc in "${oversized_docs[@]}"; do
        echo "    - $doc"
    done
    ((violations++))
else
    echo -e "${GREEN}✓${NC} All documents within line limits"
fi

# Calculate total lines
total_lines=0
while IFS= read -r doc; do
    lines=$(wc -l < "$doc")
    ((total_lines += lines))
done < <(find "$DOCS_DIR" -name "*.md" -type f 2>/dev/null)

if [[ -f "$PROJECT_ROOT/PRODUCT_OVERVIEW.md" ]]; then
    lines=$(wc -l < "$PROJECT_ROOT/PRODUCT_OVERVIEW.md")
    ((total_lines += lines))
fi

if [[ $total_lines -gt $MAX_TOTAL_LINES ]]; then
    echo -e "${RED}✗${NC} Total lines: $total_lines (max: $MAX_TOTAL_LINES)"
    ((violations++))
elif [[ $total_lines -gt $((MAX_TOTAL_LINES * 80 / 100)) ]]; then
    echo -e "${YELLOW}!${NC} Total lines: $total_lines (max: $MAX_TOTAL_LINES) - approaching limit"
    ((warnings++))
else
    echo -e "${GREEN}✓${NC} Total lines: $total_lines (max: $MAX_TOTAL_LINES)"
fi

echo ""
echo "----------------------------------------"
echo "Limit check complete"
echo -e "Violations: ${RED}$violations${NC}"
echo -e "Warnings: ${YELLOW}$warnings${NC}"

if [[ $violations -gt 0 ]]; then
    echo ""
    echo -e "${RED}Documentation limits exceeded!${NC}"
    echo "Consider archiving unused documents or consolidating content."
    exit 1
else
    echo ""
    echo -e "${GREEN}Documentation is within all limits.${NC}"
    exit 0
fi
