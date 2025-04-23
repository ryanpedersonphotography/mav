#!/bin/bash

# Change to the mav directory
cd ../mav

# Find all CSS files with query parameters in their filenames and rename them
echo "Finding and renaming CSS files with query parameters..."
find . -type f -name "*.css?*" | while read file; do
    # Extract the base CSS filename (without query parameters)
    newname=$(echo "$file" | sed 's/\(\.css\)?.*\.css/\1/')
    
    # Create directory if it doesn't exist
    mkdir -p "$(dirname "$newname")"
    
    # Rename the file
    mv "$file" "$newname"
    echo "Renamed: $file -> $newname"
done

# Update HTML files to reference the renamed CSS files
echo "Updating HTML files to reference the renamed CSS files..."
find . -type f -name "*.html" | while read file; do
    # Replace references like href='style.min.css?ver=3.3.0.css' with href='style.min.css'
    sed -i '' 's/\(href=["'"'"']\)\([^"'"'"']*\.css\)?[^"'"'"']*\(["'"'"']\)/\1\2\3/g' "$file"
    echo "Updated references in: $file"
done

echo "CSS fix completed!"