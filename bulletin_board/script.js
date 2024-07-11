function navigateToWritePage() {
    window.location.href = 'write.html';
}

function submitPost() {
    var content = document.getElementById('newPostContent').value;
    if (content.trim() === '') {
        alert('내용을 입력하세요!');
        return;
    }

    var posts = JSON.parse(localStorage.getItem('posts')) || [];

    posts.push(content);

    localStorage.setItem('posts', JSON.stringify(posts));

    window.location.href = 'index.html';
}

function loadPosts() {
    var posts = JSON.parse(localStorage.getItem('posts')) || [];
    var postsContainer = document.getElementById('posts');
    
    posts.forEach(function(content, index) {
        var newPost = document.createElement('div');
        newPost.className = 'post';

        var nickname = document.createElement('div');
        nickname.className = 'nickname';
        nickname.innerText = '닉네임 : ';

        var details = document.createElement('div');
        details.className = 'details';

        var likeImg = document.createElement('img');
        likeImg.src = 'images/good.jpg'; 
        likeImg.alt = '공감';
        details.appendChild(likeImg);

        var likeCount = document.createElement('span');
        likeCount.innerText = ' 0개, ';
        details.appendChild(likeCount);


        var commentImg = document.createElement('img');
        commentImg.src = 'images/talk.jpg';
        commentImg.alt = '댓글';
        details.appendChild(commentImg);

        var commentCount = document.createElement('span');
        commentCount.innerText = ' 0개';
        details.appendChild(commentCount);

        var contentDiv = document.createElement('div');
        contentDiv.innerText = content;

        newPost.appendChild(nickname);
        newPost.appendChild(contentDiv);
        newPost.appendChild(details);
        postsContainer.appendChild(newPost);
    });
}

if (window.location.pathname.endsWith('index.html')) {
    loadPosts();
}

