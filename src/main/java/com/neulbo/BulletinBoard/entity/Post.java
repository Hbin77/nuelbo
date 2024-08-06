package com.neulbo.BulletinBoard.entity;

public class Post {

    private String title;
    private String content;
    private long timestamp;

    public Post() {
        // 파이어스토어에서 객체 생성을 위해 기본 생성자가 필요합니다.
    }

    public Post(String title, String content) {
        this.title = title;
        this.content = content;
        this.timestamp = System.currentTimeMillis();
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public long getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(long timestamp) {
        this.timestamp = timestamp;
    }
}