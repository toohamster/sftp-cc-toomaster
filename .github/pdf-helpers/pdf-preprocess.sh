#!/bin/bash
# pdf-preprocess.sh - Prepare markdown files for PDF generation
#
# This script processes markdown files to fix formatting issues
# that affect PDF output but should not modify the original source files.
#
# Usage: ./pdf-preprocess.sh <input-dir> <output-dir>
#
# Issues fixed:
# - Add blank lines between consecutive numbered list items (for pandoc)
# - Add blank lines between consecutive bullet list items

set -euo pipefail

INPUT_DIR="${1:-.}"
OUTPUT_DIR="${2:-/tmp/pdf-preprocess}"

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Process each markdown file
find "$INPUT_DIR" -name "*.md" -type f | while read -r file; do
    # Get relative path
    rel_path="${file#$INPUT_DIR/}"
    output_file="$OUTPUT_DIR/$rel_path"

    # Create output directory structure
    mkdir -p "$(dirname "$output_file")"

    # Process the file: add blank lines between consecutive list items
    awk '
    {
        # Check if current line is a numbered list item (1. 2. 3. etc)
        is_numbered = /^[0-9]+\. /

        # Check if current line is a bullet list item (- * +)
        is_bullet = /^[-*+] /

        # If previous line was also a list item of same type, add blank line before
        if ((is_numbered && prev_numbered) || (is_bullet && prev_bullet)) {
            print ""
        }

        print $0

        prev_numbered = is_numbered
        prev_bullet = is_bullet
    }
    ' "$file" > "$output_file"

    echo "Processed: $rel_path"
done

echo "Preprocessing complete. Output in: $OUTPUT_DIR"
