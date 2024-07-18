function navigateToWritePage() {
    window.location.href = 'write.html';
}

function submitPost() {
    var title = document.getElementById('newPostTitle').value;
    var content = document.getElementById('newPostContent').value;

    if (title.trim() === '' || content.trim() === '') {
        alert('제목과 내용을 입력하세요!');
        return;
    }

    var posts = JSON.parse(localStorage.getItem('posts')) || [];
    posts.push({ title: title, content: content, likes: 0, liked: false });
    localStorage.setItem('posts', JSON.stringify(posts));

    window.location.href = 'index.html';
}

function createPostElement(post, index) {
    var newPost = document.createElement('div');
    newPost.className = 'post';

    var nickname = document.createElement('div');
    nickname.className = 'nickname';
    nickname.innerText = '닉네임 : ';

    var titleDiv = document.createElement('div');
    titleDiv.className = 'title';
    titleDiv.innerText = post.title;

    var contentDiv = document.createElement('div');
    contentDiv.className = 'content';
    contentDiv.innerText = post.content;

    var details = document.createElement('div');
    details.className = 'details';

    var likeButton = document.createElement('button');
    likeButton.className = 'like-button';
    likeButton.type = 'button';
    likeButton.setAttribute('aria-label', '좋아요');
    likeButton.setAttribute('data-index', index);
    likeButton.onclick = function() { incrementLike(this); };

    var likeImg = document.createElement('img');
    likeImg.src = 'images/good.jpg';
    likeImg.alt = '공감';
    likeButton.appendChild(likeImg);

    var likeCount = document.createElement('span');
    likeCount.className = 'like-count';
    likeCount.setAttribute('data-index', index);
    likeCount.innerText = post.likes + '개, ';
    details.appendChild(likeButton);
    details.appendChild(likeCount);

    var commentImg = document.createElement('img');
    commentImg.src = 'images/talk.jpg';
    commentImg.alt = '댓글';
    details.appendChild(commentImg);

    var commentCount = document.createElement('span');
    commentCount.innerText = ' 0개';
    details.appendChild(commentCount);

    var reportButton = document.createElement('button');
    reportButton.className = 'report-button';
    reportButton.type = 'button';
    reportButton.setAttribute('aria-label', '신고하기');
    reportButton.onclick = function() { reportPost(index); };
    var reportImg = document.createElement('img');
    reportImg.src = 'images/report.jpg';
    reportImg.alt = '신고';
    reportButton.appendChild(reportImg);
    details.appendChild(reportButton); 

    newPost.appendChild(nickname);
    newPost.appendChild(titleDiv);
    newPost.appendChild(contentDiv);
    newPost.appendChild(details);

    return newPost;
}


function loadPosts() {
    var posts = JSON.parse(localStorage.getItem('posts')) || [];
    var postsContainer = document.getElementById('posts');

    postsContainer.innerHTML = '';
    posts.forEach(function(post, index) {
        var newPost = createPostElement(post, index);
        postsContainer.appendChild(newPost);
    });
}

if (window.location.pathname.endsWith('index.html')) {
    loadPosts();
}

function incrementLike(button) {
    var index = button.getAttribute('data-index');
    var posts = JSON.parse(localStorage.getItem('posts')) || [];

    if (posts[index].liked) {
        posts[index].likes -= 1;
        posts[index].liked = false;
    } else {
        posts[index].likes += 1;
        posts[index].liked = true;
    }

    localStorage.setItem('posts', JSON.stringify(posts));

    var likeCount = document.querySelector(`.like-count[data-index="${index}"]`);
    likeCount.innerText = posts[index].likes + '개, ';
}

function reportPost(index) {
    alert('게시물 ' + index + '신고하시겠습니까?');
}

