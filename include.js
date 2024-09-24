// include.js

function includeHTML() {
    let elements = document.querySelectorAll('[data-include]');
    elements.forEach((element) => {
        let file = element.getAttribute('data-include');
        fetch(file)
            .then(response => {
                if (response.ok) return response.text();
                throw new Error('Page not found');
            })
            .then(data => {
                element.innerHTML = data;
            })
            .catch(err => console.log('Error:', err));
    });
}

// Call the function to load HTML components
window.onload = includeHTML;
