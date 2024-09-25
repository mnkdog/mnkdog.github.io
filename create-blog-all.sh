#!/bin/bash

# Define the directory where the blog posts are located
output_dir="blog/posts/"
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
