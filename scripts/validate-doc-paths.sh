#!/bin/bash
# validate-doc-paths.sh
# Validates that file paths referenced in documentation actually exist
#
# Usage: ./scripts/validate-doc-paths.sh
# Exit codes: 0 = all paths valid, 1 = invalid paths found

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
DOCS_DIR="$PROJECT_ROOT/docs"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "Validating documentation file references..."
echo "Project root: $PROJECT_ROOT"
echo ""

invalid_count=0
valid_count=0
checked_count=0

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

    # Remove anchor from path
    local clean_path="${ref_path%%#*}"

    # Skip if empty after cleaning
    if [[ -z "$clean_path" ]]; then
        return 0
    fi

    # Determine base directory for relative paths
    local base_dir="$(dirname "$doc_file")"
    local full_path=""

    if [[ "$clean_path" =~ ^/ ]]; then
        # Absolute path (rare in docs)
        full_path="$PROJECT_ROOT$clean_path"
    elif [[ "$clean_path" =~ ^\.\. ]]; then
        # Relative path with ..
        full_path="$(cd "$base_dir" && cd "$(dirname "$clean_path")" 2>/dev/null && pwd)/$(basename "$clean_path")" 2>/dev/null || full_path=""
    else
        # Simple relative path
        full_path="$base_dir/$clean_path"
    fi

    ((checked_count++))

    if [[ -n "$full_path" ]] && [[ -e "$full_path" ]]; then
        ((valid_count++))
        return 0
    else
        echo -e "${RED}INVALID${NC}: $doc_file:$line_num"
        echo "  Referenced: $ref_path"
        echo "  Resolved to: $full_path"
        echo ""
        ((invalid_count++))
        return 1
    fi
}

# Find all markdown files in docs
find "$DOCS_DIR" -name "*.md" -type f | while read -r doc_file; do
    # Extract markdown links: [text](path)
    grep -n '\[.*\](.*' "$doc_file" 2>/dev/null | while read -r line; do
        line_num=$(echo "$line" | cut -d: -f1)

        # Extract paths from markdown links
        echo "$line" | grep -oE '\]\([^)]+\)' | sed 's/\](\(.*\))/\1/' | while read -r ref_path; do
            check_path "$doc_file" "$ref_path" "$line_num" || true
        done
    done

    # Extract backtick file paths that look like file references
    grep -n '`[a-zA-Z][a-zA-Z0-9_/-]*\.[a-z]*`' "$doc_file" 2>/dev/null | while read -r line; do
        line_num=$(echo "$line" | cut -d: -f1)

        echo "$line" | grep -oE '`[a-zA-Z][a-zA-Z0-9_/-]*\.[a-z]+`' | tr -d '`' | while read -r ref_path; do
            # Only check if it looks like a real file path (has extension and directory structure)
            if [[ "$ref_path" =~ / ]] && [[ -n "${ref_path##*.}" ]]; then
                # Try to find the file from project root
                if [[ -e "$PROJECT_ROOT/$ref_path" ]]; then
                    ((valid_count++))
                fi
            fi
        done
    done
done

# Also check PRODUCT_OVERVIEW.md in root
if [[ -f "$PROJECT_ROOT/PRODUCT_OVERVIEW.md" ]]; then
    doc_file="$PROJECT_ROOT/PRODUCT_OVERVIEW.md"
    grep -n '\[.*\](.*' "$doc_file" 2>/dev/null | while read -r line; do
        line_num=$(echo "$line" | cut -d: -f1)
        echo "$line" | grep -oE '\]\([^)]+\)' | sed 's/\](\(.*\))/\1/' | while read -r ref_path; do
            check_path "$doc_file" "$ref_path" "$line_num" || true
        done
    done
fi

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
