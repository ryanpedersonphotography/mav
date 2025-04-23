#!/bin/bash

# Find all files with '?' in their names and rename them
echo "Finding and renaming all files with '?' in their names..."
find . -type f -name "*\?*" | while read file; do
    # Extract the base filename (without query parameters)
    # For files with extensions, keep the extension
    if [[ "$file" == *.* ]]; then
        extension="${file##*.}"
        basename="${file%.*}"
        basename="${basename%\?*}"
        newname="${basename}.${extension}"
    else
        # For files without extensions
        newname="${file%\?*}"
    fi
    
    # Special case for wp-json/oembed files
    if [[ "$file" == *"/wp-json/oembed/1.0/embed?"* ]]; then
        dir=$(dirname "$file")
        newname="${dir}/embed-$(date +%s%N | md5sum | head -c 8).json"
    fi
    
    # Create directory if it doesn't exist
    mkdir -p "$(dirname "$newname")"
    
    # Rename the file
    mv "$file" "$newname"
    echo "Renamed: $file -> $newname"
done

# Update HTML files to reference the renamed files
echo "Updating HTML files to reference the renamed files..."
find . -type f -name "*.html" | while read file; do
    # Replace references like href='page.html?p=123.html' with href='page.html'
    sed -i '' 's/\(href=["'"'"']\)\([^"'"'"']*\)?[^"'"'"']*/\1\2/g' "$file"
    echo "Updated references in: $file"
done

# Update CSS references in HTML files
echo "Updating CSS references in HTML files..."
find . -type f -name "*.html" | while read file; do
    # Replace references like href='style.css?ver=1.0.css' with href='style.css'
    sed -i '' 's/\(href=["'"'"']\)\([^"'"'"']*\.css\)?[^"'"'"']*/\1\2/g' "$file"
    echo "Updated CSS references in: $file"
done

# Update JS references in HTML files
echo "Updating JS references in HTML files..."
find . -type f -name "*.html" | while read file; do
    # Replace references like src='script.js?ver=1.0' with src='script.js'
    sed -i '' 's/\(src=["'"'"']\)\([^"'"'"']*\.js\)?[^"'"'"']*/\1\2/g' "$file"
    echo "Updated JS references in: $file"
done

echo "All query parameter fixes completed!"