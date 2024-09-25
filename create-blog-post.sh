#!/bin/bash

# Define the input files
file1="statics/before.html"
file2="content.html"
file3="statics/after.html"
recentblogs="statics/recentblogs.html"
output_dir="blog/posts/"  # The directory to save the final output

# Extract the first <h1> title from content.html
title=$(grep -oP '(?<=<h1>).*?(?=</h1>)' "$file2" | head -n 1)

# Convert the title to lowercase and create a valid file name
output=$(echo "$title" | tr '[:upper:]' '[:lower:]')
output=$(echo "$output" | sed -e 's/[^a-z0-9 ]//g' -e 's/[ _]/-/g' | sed 's/-\{2,\}/-/g' | sed 's/^-//' | sed 's/-$//')

# Define the final output file name with .html extension
output="${output_dir}${output}.html"

# Replace "BLOG TITLE" in before.html with the actual <h1> title
sed "s|<title>BLOG TITLE</title>|<title>$title</title>|" "$file1" > temp_before.html

# Create the final merged file
echo "Merging files into $output..."
cat temp_before.html > "$output"
cat "$file2" >> "$output"
cat "$file3" >> "$output"
echo "Done. Output saved as $output."

# Remove the temporary before.html file
rm temp_before.html

# Create the new link for recentblogs.html
new_link="<li><a href=\"/$output\">$title</a></li>"

# Check if the link already exists in recentblogs.html
if grep -q "/blog/posts/$output" "$recentblogs"; then
    echo "Link for $output already exists in $recentblogs. Skipping insertion."
else
    # Insert the new link above the first <li> line in recentblogs.html
    sed -i "s|<ul>|<ul>\n    $new_link|" "$recentblogs"
    echo "New blog link added to $recentblogs."
fi


# Now create or update the /blog/all-posts.html file

# Define the directory where the blog posts are located
# we re-use this from the top of this script: output_dir="blog/posts/"
full_blog="blog/all-posts.html"  # The file where all posts will be combined

# Create or overwrite the full_blog.html file with the HTML structure
echo "<html>" > "$full_blog"
echo "<head>" >> "$full_blog"
echo "    <meta charset=\"UTF-8\">" >> "$full_blog"
echo "    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">" >> "$full_blog"
echo "    <link rel=\"stylesheet\" href=\"/css/styles.css\">" >> "$full_blog"
echo "    <title>All Blog Posts</title>" >> "$full_blog"
echo "    <script src=\"/js/include.js\"></script>" >> "$full_blog"
echo "</head>" >> "$full_blog"
echo "<body>" >> "$full_blog"
echo "    <div data-include=\"/statics/navbar.html\"></div>" >> "$full_blog"
# echo "<h1>All Blog Posts</h1>" >> "$full_blog"

# Loop through each .html file in the blog/posts directory
for file in "$output_dir"*.html; do
    # Extract the <main> content from each file
    main_content=$(sed -n '/<main>/,/<\/main>/p' "$file")
    
    # Append the main content to the full_blog.html file
    if [[ -n "$main_content" ]]; then
        # echo "<article>" >> "$full_blog"
        echo "<div class="container">" >> "$full_blog"
        echo "$main_content" >> "$full_blog"
        # echo "</article>" >> "$full_blog"
        echo "</div>" >> "$full_blog"
    else
        echo "No main content found in $file, skipping..."
    fi
done

# Close the HTML structure
echo "</body>" >> "$full_blog"
echo "</html>" >> "$full_blog"

echo "All blog posts have been combined into $full_blog."
