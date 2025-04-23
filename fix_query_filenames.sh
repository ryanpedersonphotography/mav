#!/bin/bash

# Change to the mav directory
cd ../mav

# Find all files with '?' in their names and rename them
echo "Finding and renaming files with '?' in their names..."
find . -type f -name "*\?*" | while read file; do
    # Extract the base filename (without query parameters)
    newname=$(echo "$file" | sed 's/\([^?]*\)?[^\/]*/\1/')
    
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

echo "Query filename fix completed!"