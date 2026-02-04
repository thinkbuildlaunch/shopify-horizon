#!/bin/bash
# validate-doc-paths.sh
# Validates that file paths referenced in documentation actually exist
#
# Usage: ./scripts/validate-doc-paths.sh
# Exit codes: 0 = all paths valid, 1 = invalid paths found

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
DOCS_DIR="$PROJECT_ROOT/docs"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Temp files for tracking counts across subshells
INVALID_FILE=$(mktemp)
VALID_FILE=$(mktemp)
CHECKED_FILE=$(mktemp)

# Initialize counters
echo "0" > "$INVALID_FILE"
echo "0" > "$VALID_FILE"
echo "0" > "$CHECKED_FILE"

# Cleanup on exit
trap "rm -f '$INVALID_FILE' '$VALID_FILE' '$CHECKED_FILE'" EXIT

echo "Validating documentation file references..."
echo "Project root: $PROJECT_ROOT"
echo ""

# Function to increment a counter file
increment_counter() {
    local file="$1"
    local count
    count=$(cat "$file")
    echo $((count + 1)) > "$file"
}

# Function to check if a path exists
check_path() {
    local doc_file="$1"
    local ref_path="$2"
    local line_num="$3"

    # Skip external URLs
    if [[ "$ref_path" =~ ^https?:// ]]; then
        return 0
    fi

    # Skip anchor-only references
    if [[ "$ref_path" =~ ^# ]]; then
        return 0
    fi

    # Skip translation keys and Liquid patterns
    if [[ "$ref_path" =~ ^t: ]] || [[ "$ref_path" =~ \{\{ ]] || [[ "$ref_path" =~ \{% ]]; then
        return 0
    fi

    # Skip mailto links
    if [[ "$ref_path" =~ ^mailto: ]]; then
        return 0
    fi

    # Remove anchor from path
    local clean_path="${ref_path%%#*}"

    # Skip if empty after cleaning
    if [[ -z "$clean_path" ]]; then
        return 0
    fi

    # Determine base directory for relative paths
    local base_dir
    base_dir="$(dirname "$doc_file")"
    local full_path=""

    if [[ "$clean_path" =~ ^/ ]]; then
        # Absolute path (rare in docs)
        full_path="$PROJECT_ROOT$clean_path"
    elif [[ "$clean_path" =~ ^\.\. ]]; then
        # Relative path with ..
        # Resolve the path safely
        if cd "$base_dir" 2>/dev/null; then
            local target_dir
            target_dir="$(dirname "$clean_path")"
            if cd "$target_dir" 2>/dev/null; then
                full_path="$(pwd)/$(basename "$clean_path")"
            fi
            cd "$PROJECT_ROOT" 2>/dev/null || true
        fi
    else
        # Simple relative path
        full_path="$base_dir/$clean_path"
    fi

    increment_counter "$CHECKED_FILE"

    if [[ -n "$full_path" ]] && [[ -e "$full_path" ]]; then
        increment_counter "$VALID_FILE"
        return 0
    else
        echo -e "${RED}INVALID${NC}: $doc_file:$line_num"
        echo "  Referenced: $ref_path"
        echo "  Resolved to: ${full_path:-<could not resolve>}"
        echo ""
        increment_counter "$INVALID_FILE"
        return 1
    fi
}

# Process a single markdown file
process_markdown_file() {
    local doc_file="$1"

    # Extract markdown links: [text](path)
    while IFS= read -r line; do
        line_num=$(echo "$line" | cut -d: -f1)

        # Extract paths from markdown links
        echo "$line" | grep -oE '\]\([^)]+\)' | sed 's/\](\(.*\))/\1/' | while IFS= read -r ref_path; do
            # Skip empty paths
            [[ -z "$ref_path" ]] && continue
            check_path "$doc_file" "$ref_path" "$line_num" || true
        done
    done < <(grep -n '\[.*\](.*)' "$doc_file" 2>/dev/null || true)
}

# Find and process all markdown files in docs
while IFS= read -r -d '' doc_file; do
    process_markdown_file "$doc_file"
done < <(find "$DOCS_DIR" -name "*.md" -type f -print0 2>/dev/null)

# Also check PRODUCT_OVERVIEW.md in root
if [[ -f "$PROJECT_ROOT/PRODUCT_OVERVIEW.md" ]]; then
    process_markdown_file "$PROJECT_ROOT/PRODUCT_OVERVIEW.md"
fi

# Also check README.md in root
if [[ -f "$PROJECT_ROOT/README.md" ]]; then
    process_markdown_file "$PROJECT_ROOT/README.md"
fi

# Read final counts
invalid_count=$(cat "$INVALID_FILE")
valid_count=$(cat "$VALID_FILE")
checked_count=$(cat "$CHECKED_FILE")

echo "----------------------------------------"
echo "Validation complete"
echo "Paths checked: $checked_count"
echo -e "Valid: ${GREEN}$valid_count${NC}"
echo -e "Invalid: ${RED}$invalid_count${NC}"

if [[ $invalid_count -gt 0 ]]; then
    echo ""
    echo -e "${RED}Documentation contains invalid file references!${NC}"
    exit 1
else
    echo ""
    echo -e "${GREEN}All documentation file references are valid.${NC}"
    exit 0
fi
