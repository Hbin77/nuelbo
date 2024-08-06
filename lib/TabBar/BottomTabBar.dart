import 'package:flutter/material.dart';
import 'package:neulbo/Const/color.dart';
import 'package:neulbo/screen/homescreen.dart';
import 'package:neulbo/screen/module_screen/AlarmScreen.dart';
import '../screen/module_screen/CommunityScreen.dart';
import '../screen/module_screen/HomeContentScreen.dart';
import '../screen/module_screen/MyInfoScreen.dart';
import '../screen/module_screen/NoticeBoardScreen.dart';
import 'package:neulbo/status/App_Status.dart';
import 'package:provider/provider.dart';

class BottomTabBar extends StatelessWidget {
  static List<Widget> _widgetOptions = <Widget>[
    HomeContentScreen(),
    AlarmScreen(),
    CommunityScreen(),
    NoticeBoardScreen(),
    MyInfoScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStatus>(context);

    return Scaffold(
      body: _widgetOptions.elementAt(appState.selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: neulbo_color, // 하단 앱바 색상 설정
        selectedItemColor: Colors.blue, // 선택된 아이템 색상
        showUnselectedLabels: true, // 선택되지 않은 아이템의 레이블을 항상 보이도록 설정
        unselectedItemColor: Colors.black38, // 선택되지 않은 아이템 색상
        currentIndex: appState.selectedIndex,
        onTap: (index) {
          appState.updateIndex(index);
        },
        items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '홈',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.alarm),
          label: '알람',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.group),
          label: '커뮤니티',
        ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              label: '게시판',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info),
              label: '내 정보',
            ),
          ],
        ),
    );
  }
}
