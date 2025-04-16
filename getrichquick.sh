#!/bin/bash

# Ask the user for a search term
echo "Enter the topic you want to research on Wikipedia:"
read topic

# Replace spaces with underscores for Wikipedia URL compatibility
formatted_topic=$(echo "$topic" | sed 's/ /_/g')

# Construct the Wikipedia URL
wiki_url="https://en.wikipedia.org/wiki/$formatted_topic"

# Fetch the Wikipedia page content
echo "Fetching information from Wikipedia for '$topic'..."
curl -s "$wiki_url" -o temp_wiki.html

# Check if the page exists
if grep -q "Wikipedia does not have an article with this exact name" temp_wiki.html; then
    echo "No Wikipedia page found for '$topic'."
    rm temp_wiki.html
    exit 1
fi

# Extract the first paragraph of the article
echo "Extracting the first paragraph..."
content=$(grep -oP '(?<=<p>).*?(?=</p>)' temp_wiki.html | sed -n '1p' | sed 's/<[^>]*>//g')

# Save the content to a text file
output_file="${formatted_topic}_wiki.txt"
echo "$content" > "$output_file"

# Inform the user
echo "The information has been saved to '$output_file'."

# Clean up temporary files
rm temp_wiki.html

# Optional: Open the Wikipedia page in Firefox
echo "Opening the Wikipedia page in Firefox..."
xdg-open "$wiki_url"