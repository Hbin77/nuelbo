import { initializeApp } from "https://www.gstatic.com/firebasejs/10.12.4/firebase-app.js";
import { getFirestore, collection, addDoc, getDocs } from "https://www.gstatic.com/firebasejs/10.12.4/firebase-firestore.js";

// Firebase 설정
const firebaseConfig = {
  apiKey: "AIzaSyCoLFHO6brGuD2jLCD3-IZb1yWcTm5OWPs",
  authDomain: "neulbo-915ae.firebaseapp.com",
  databaseURL: "https://neulbo-915ae-default-rtdb.firebaseio.com",
  projectId: "neulbo-915ae",
  storageBucket: "neulbo-915ae.appspot.com",
  messagingSenderId: "889846027815",
  appId: "1:889846027815:web:184cf98b5ca3051ead6002",
  measurementId: "G-PKXGSVBCLT"
};

// Firebase 초기화
const app = initializeApp(firebaseConfig);
const db = getFirestore(app);

// navigateToWritePage 함수 정의
export function navigateToWritePage() {
    window.location.href = '/posts/write';
}

// submitPost 함수 정의 (Firebase 및 로컬 저장소 사용)
export async function submitPost(event) {
    event.preventDefault();

    const title = document.getElementById('newPostTitle').value;
    const content = document.getElementById('newPostContent').value;

    if (title.trim() === '' || content.trim() === '') {
        alert('제목과 내용을 입력하세요!');
        return;
    }

    try {
        // Firebase에 저장
        const docRef = await addDoc(collection(db, "posts"), {
            title: title,
            content: content,
            timestamp: new Date()
        });
        console.log("Document written with ID: ", docRef.id);

        // 로컬 저장소에 저장
        const posts = JSON.parse(localStorage.getItem('posts')) || [];
        posts.push({ title: title, content: content, likes: 0, liked: false });
        localStorage.setItem('posts', JSON.stringify(posts));

        alert("글이 성공적으로 저장되었습니다.");
        window.location.href = "/"; // 홈 페이지로 리다이렉션
    } catch (e) {
        console.error("Error adding document: ", e);
        alert("글 저장에 실패했습니다.");
    }
}

// createPostElement 함수 정의
function createPostElement(post, index) {
    const newPost = document.createElement('div');
    newPost.className = 'post';

    const nickname = document.createElement('div');
    nickname.className = 'nickname';
    nickname.innerText = '닉네임 : ';

    const titleDiv = document.createElement('div');
    titleDiv.className = 'title';
    titleDiv.innerText = post.title;

    const contentDiv = document.createElement('div');
    contentDiv.className = 'content';
    contentDiv.innerText = post.content;

    const details = document.createElement('div');
    details.className = 'details';

    const likeButton = document.createElement('button');
    likeButton.className = 'like-button';
    likeButton.type = 'button';
    likeButton.setAttribute('aria-label', '좋아요');
    likeButton.setAttribute('data-index', index);
    likeButton.onclick = function() { incrementLike(this); };

    const likeImg = document.createElement('img');
    likeImg.src = 'images/good.jpg';
    likeImg.alt = '공감';
    likeButton.appendChild(likeImg);

    const likeCount = document.createElement('span');
    likeCount.className = 'like-count';
    likeCount.setAttribute('data-index', index);
    likeCount.innerText = post.likes + '개, ';
    details.appendChild(likeButton);
    details.appendChild(likeCount);

    const commentImg = document.createElement('img');
    commentImg.src = 'images/talk.jpg';
    commentImg.alt = '댓글';
    details.appendChild(commentImg);

    const commentCount = document.createElement('span');
    commentCount.innerText = ' 0개';
    details.appendChild(commentCount);

    const reportButton = document.createElement('button');
    reportButton.className = 'report-button';
    reportButton.type = 'button';
    reportButton.setAttribute('aria-label', '신고하기');
    reportButton.onclick = function() { reportPost(index); };
    const reportImg = document.createElement('img');
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

// loadPosts 함수 정의 (Firebase 및 로컬 저장소에서 불러오기)
export async function loadPosts() {
    const postsContainer = document.getElementById('posts');
    postsContainer.innerHTML = '';

    const posts = JSON.parse(localStorage.getItem('posts')) || [];

    // Sort local storage posts by timestamp
    posts.sort((a, b) => new Date(b.timestamp) - new Date(a.timestamp));

    posts.forEach(function(post, index) {
        const newPost = createPostElement(post, index);
        postsContainer.appendChild(newPost);
    });

    const querySnapshot = await getDocs(collection(db, "posts"));
    const firebasePosts = [];
    querySnapshot.forEach((doc) => {
        const post = doc.data();
        const timestamp = post.timestamp;
        let date;

        if (timestamp && timestamp.seconds) {
            date = new Date(timestamp.seconds * 1000);
        } else {
            date = new Date();
        }

        firebasePosts.push({ ...post, date: date.toLocaleString() });
    });

    // Sort Firebase posts by date
    firebasePosts.sort((a, b) => new Date(b.date) - new Date(a.date));

    firebasePosts.forEach((post) => {
        const postElement = document.createElement('div');
        postElement.classList.add('post');
        postElement.innerHTML = `
            <h2>${post.title}</h2>
            <p>${post.content}</p>
            <small>${post.date}</small>
        `;

        // Append Firebase posts with a special class to differentiate
        postElement.classList.add('firebase-post');
        postsContainer.appendChild(postElement);
    });

    // Remove Firebase duplicated posts
    const postElements = postsContainer.getElementsByClassName('firebase-post');
    for (let i = postElements.length - 1; i >= 0; i--) {
        postsContainer.removeChild(postElements[i]);
    }
}

// incrementLike 함수 정의
function incrementLike(button) {
    const index = button.getAttribute('data-index');
    const posts = JSON.parse(localStorage.getItem('posts')) || [];

    if (posts[index].liked) {
        posts[index].likes -= 1;
        posts[index].liked = false;
    } else {
        posts[index].likes += 1;
        posts[index].liked = true;
    }

    localStorage.setItem('posts', JSON.stringify(posts));

    const likeCount = document.querySelector(`.like-count[data-index="${index}"]`);
    likeCount.innerText = posts[index].likes + '개, ';
}

// reportPost 함수 정의
function reportPost(index) {
    alert('게시물 ' + index + '신고하시겠습니까?');
}

// 초기화 시점에 loadPosts 함수 호출
if (document.getElementById('posts')) {
    loadPosts();
}

// 이벤트 리스너 설정
if (document.getElementById('newPostForm')) {
    document.getElementById('newPostForm').addEventListener('submit', submitPost);
}

// 브라우저 로드 시 loadPosts 함수 호출
if (window.location.pathname.endsWith('index.html')) {
    loadPosts();
}