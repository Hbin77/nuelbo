import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';



import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserStatusProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isSleeping = false;
  User? _currentUser;

  bool get isSleeping => _isSleeping;

  UserStatusProvider() {
    _initUserStatus();
  }

  User? get currentUser => _currentUser;

  Future<void> _initUserStatus() async {
    _currentUser = _auth.currentUser;
    if (_currentUser != null) {
      try {
        DocumentSnapshot snapshot = await _firestore.collection('users').doc(_currentUser!.uid).get();
        if (snapshot.exists) {
          final data = snapshot.data() as Map<String, dynamic>? ?? {};
          _isSleeping = data['isSleeping'] ?? false;
        }
        print('Initialized user status: $_isSleeping');
      } catch (e) {
        print("Error initializing user status: $e");
      }
      notifyListeners();
    }
  }

  Future<void> toggleSleepStatus() async {
    if (_currentUser != null) {
      _isSleeping = !_isSleeping;
      await _firestore.collection('users').doc(_currentUser!.uid).set({
        'isSleeping': _isSleeping,
        'lastActive': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      print('Toggled sleep status to: $_isSleeping');
      notifyListeners();
    }
  }

  Stream<QuerySnapshot> get sleepingUsers {
    return _firestore.collection('users').snapshots();
  }
}
