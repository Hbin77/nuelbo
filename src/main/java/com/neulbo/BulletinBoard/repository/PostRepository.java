package com.neulbo.BulletinBoard.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.neulbo.BulletinBoard.model.Post;

public interface PostRepository extends JpaRepository<Post, Long> {
}