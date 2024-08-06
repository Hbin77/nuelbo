package com.neulbo.BulletinBoard.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import com.neulbo.BulletinBoard.service.FirestoreService; // FirestoreService 임포트
import com.neulbo.BulletinBoard.entity.Post; // Post 임포트

@Controller
@RequestMapping("/posts")
public class PostController {

    @GetMapping("/write")
    public String showWritePage() {
        return "write"; // src/main/resources/templates/write.html 반환
    }

    @PostMapping("/write")
    public String submitPost(String title, String content, Model model) {
        // post 저장 로직 수행
        return "redirect:/posts/index"; // /posts/index로 리다이렉트
    }

    @GetMapping("/index")
    public String showIndexPage() {
        return "index"; // src/main/resources/templates/index.html 반환
    }

    @Autowired
    private FirestoreService firestoreService;

    @PostMapping("/savePost")
    public String savePost(@RequestParam String title, @RequestParam String content) {
        Post post = new Post(title, content);
        firestoreService.savePost(post);
        return "redirect:/";
    }


}