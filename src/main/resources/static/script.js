document.addEventListener('DOMContentLoaded', () => {
    loadPosts();
});

function loadPosts() {
    fetch('/api/posts')
        .then(response => response.json())
        .then(posts => {
            const postsContainer = document.getElementById('posts');
            postsContainer.innerHTML = '';
            posts.forEach(post => {
                const postElement = document.createElement('div');
                postElement.className = 'post';
                postElement.innerHTML = `<div class="username">${post.username}</div><div class="content">${post.content}</div>`;
                postsContainer.appendChild(postElement);
            });
        });
}

function submitPost() {
    const username = document.getElementById('username').value;
    const content = document.getElementById('content').value;

    if (username && content) {
        fetch('/api/posts', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ username, content }),
        })
        .then(response => response.json())
        .then(post => {
            document.getElementById('username').value = '';
            document.getElementById('content').value = '';
            loadPosts();
        });
    } else {
        alert('Please fill in both fields');
    }
}