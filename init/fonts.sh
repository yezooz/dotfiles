#!/usr/bin/env bash

################################################################################
# Font Installation Script
################################################################################
# Installs custom fonts from dotfiles/fonts directory
################################################################################

set -e

DOTFILES="${HOME}/.dotfiles"
FONTS_DIR="${DOTFILES}/fonts"

# Determine OS-specific font directory
if [[ "$OSTYPE" =~ ^darwin ]]; then
    # macOS
    SYSTEM_FONTS_DIR="${HOME}/Library/Fonts"
elif [[ "$OSTYPE" =~ ^linux ]]; then
    # Linux
    SYSTEM_FONTS_DIR="${HOME}/.local/share/fonts"
    mkdir -p "${SYSTEM_FONTS_DIR}"
else
    echo "Unsupported operating system"
    exit 1
fi

if [[ ! -d "$FONTS_DIR" ]]; then
    echo "Fonts directory not found at $FONTS_DIR"
    exit 1
fi

echo "Installing custom fonts..."

# Count total fonts
TOTAL_FONTS=$(find "$FONTS_DIR" -type f \( -name "*.ttf" -o -name "*.otf" \) | wc -l | tr -d ' ')

if [[ "$TOTAL_FONTS" -eq 0 ]]; then
    echo "No fonts found in $FONTS_DIR"
    exit 0
fi

echo "Found $TOTAL_FONTS font files"

# Copy fonts
COPIED=0
SKIPPED=0

while IFS= read -r font; do
    font_name=$(basename "$font")
    dest_path="${SYSTEM_FONTS_DIR}/${font_name}"

    if [[ -f "$dest_path" ]]; then
        # Check if files are identical
        if cmp -s "$font" "$dest_path"; then
            SKIPPED=$((SKIPPED + 1))
        else
            # File exists but is different, update it
            cp "$font" "$dest_path"
            COPIED=$((COPIED + 1))
            echo "  Updated: $font_name"
        fi
    else
        # New font, copy it
        cp "$font" "$dest_path"
        COPIED=$((COPIED + 1))
        echo "  Installed: $font_name"
    fi
done < <(find "$FONTS_DIR" -type f \( -name "*.ttf" -o -name "*.otf" \))

echo ""
echo "Font installation complete!"
echo "  Installed/Updated: $COPIED"
echo "  Already up-to-date: $SKIPPED"

# Refresh font cache on Linux
if [[ "$OSTYPE" =~ ^linux ]]; then
    if command -v fc-cache >/dev/null 2>&1; then
        echo ""
        echo "Refreshing font cache..."
        fc-cache -f "$SYSTEM_FONTS_DIR"
        echo "Font cache refreshed"
    fi
fi

echo ""
echo "You may need to restart applications to see the new fonts."
