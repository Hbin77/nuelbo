import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:neulbo/status/User_Status_provider.dart';
import 'package:neulbo/Const/color.dart';



class CommunityScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Consumer<UserStatusProvider>(
        builder: (context, userStatusProvider, child) {
          if (user == null) {
            return Center(
              child: Text('로그인이 필요합니다.'),
            );
          }
          return Column(
            children: [
              _buildUserTile(context, userStatusProvider),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: userStatusProvider.sleepingUsers,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text('No users found'));
                    }

                    final users = snapshot.data!.docs;
                    return GridView.builder(
                      padding: EdgeInsets.all(10),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 2 / 3,
                      ),
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final userData = users[index].data() as Map<String, dynamic>? ?? {};
                        return _buildGridUserTile(userData);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildUserTile(BuildContext context, UserStatusProvider userStatusProvider) {
    final user = userStatusProvider.currentUser;
    if (user == null) return SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(user.photoURL ?? 'https://via.placeholder.com/150'),
          ),
          title: Text(user.displayName ?? 'Unknown'),
          subtitle: Text(userStatusProvider.isSleeping ? '수면 중...' : '활동 중'),
          trailing: Text('마지막 활동: 지금'),
        ),
      ),
    );
  }

  Widget _buildGridUserTile(Map<String, dynamic> userData) {
    final isSleeping = userData['isSleeping'] ?? false;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(userData['photoURL'] ?? 'https://via.placeholder.com/150'),
                ),
                if (isSleeping)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Icon(
                      Icons.nightlight_round,
                      color: Colors.blue,
                      size: 24,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 10),
            Text(userData['displayName'] ?? 'Unknown'),
            SizedBox(height: 5),
            Text(
              isSleeping ? '수면 중...' : '활동 중',
              style: TextStyle(color: isSleeping ? Colors.blue : Colors.green),
            ),
            SizedBox(height: 5),
            Text('마지막 활동: ${userData['lastActive']?.toDate() ?? '모름'}'),
          ],
        ),
      ),
    );
  }
}
