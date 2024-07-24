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
    posts.unshift({ title: title, content: content, likes: 0, liked: false });
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
    likeButton.innerHTML = '<i class="fa-regular fa-thumbs-up"></i>'; // Font Awesome 아이콘 사용

    var likeCount = document.createElement('span');
    likeCount.className = 'like-count';
    likeCount.setAttribute('data-index', index);
    likeCount.innerText = post.likes + '개, ';
    details.appendChild(likeButton);
    details.appendChild(likeCount);

    var commentImg = document.createElement('span');
    commentImg.className = 'comment-icon';
    commentImg.innerHTML = '<i class="fa-regular fa-comment"></i>'; // 댓글 아이콘 사용
    details.appendChild(commentImg);

    var commentCount = document.createElement('span');
    commentCount.innerText = ' 0개';
    details.appendChild(commentCount);

    var reportButton = document.createElement('button');
    reportButton.className = 'report-button';
    reportButton.type = 'button';
    reportButton.setAttribute('aria-label', '신고하기');
    reportButton.onclick = function() { reportPost(index); };
    reportButton.innerHTML = '<i class="fa-regular fa-flag"></i>'; // 신고 아이콘 사용
    details.appendChild(reportButton); // 신고 버튼 추가

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
        postsContainer.appendChild(newPost); // 새로운 게시물을 위로 추가
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
    alert('게시물 ' + index + '을(를) 신고했습니다.');
}
