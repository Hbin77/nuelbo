import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:neulbo/status/Google_Signin_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../login_screen.dart';


class MyInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GoogleSignInProvider>(context);
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            user == null ? LoginButton() : UserProfile(user: user),
            if (user != null)
              IconButton(
                icon: Icon(Icons.logout),
                onPressed: () async {
                  await provider.logout();
                },
              ),
          ],
        ),
      ),
    );
  }
}


class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GoogleSignInProvider>(context);

    return ElevatedButton(
      onPressed: () {
        provider.googleLogin();
      },
      child: Text('Google로 로그인'),
    );
  }
}

class UserProfile extends StatelessWidget {
  final User user;

  UserProfile({required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('로그인 성공!'),
        Text('사용자 ID: ${user.uid}'),
        Text('이메일: ${user.email}'),
        Text('이름: ${user.displayName ?? "알 수 없음"}'),
        ElevatedButton(
          onPressed: () async {
            String? token = await user.getIdToken();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WebViewScreen(token: token!), // WebViewScreen 사용
              ),
            );
          },
          child: Text('게시판으로 이동'),
        ),
      ],
    );
  }
}

