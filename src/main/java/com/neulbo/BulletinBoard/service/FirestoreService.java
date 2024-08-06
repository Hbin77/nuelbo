package com.neulbo.BulletinBoard.service;

import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.DocumentReference;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.WriteResult;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.neulbo.BulletinBoard.entity.Post; // Post 임포트 추가

@Service
public class FirestoreService {

    @Autowired
    private Firestore firestore;

    public void savePost(Post post) {
        DocumentReference docRef = firestore.collection("posts").document();
        ApiFuture<WriteResult> result = docRef.set(post);
        // 결과 처리 코드 추가 가능
    }
}