import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:neulbo/TabBar/BottomTabBar.dart';
import 'package:neulbo/status/App_Status.dart';
import 'package:neulbo/screen/module_screen/HomeContentScreen.dart';
import 'package:neulbo/screen/module_screen/AlarmScreen.dart';
import 'package:neulbo/screen/module_screen/CommunityScreen.dart';
import 'package:neulbo/screen/module_screen/NoticeBoardScreen.dart';
import 'package:neulbo/screen/module_screen/MyInfoScreen.dart';
import 'package:neulbo/Const/color.dart';
import 'package:neulbo/status/User_Status_provider.dart';



class HomeScreen extends StatelessWidget {
  final List<String> _appBarTitles = [
    '홈',
    '알람&수면모드',
    '커뮤니티',
    '게시판',
    '내 정보',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: neulbo_color,
        title: Consumer<AppStatus>(
          builder: (context, appState, child) {
            return Text(_appBarTitles[appState.selectedIndex]);
          },
        ),
        actions: [
          Consumer<AppStatus>(
            builder: (context, appState, child) {
              List<Widget> actionWidgets = [];
              if (appState.selectedIndex == 1) {
                actionWidgets.add(
                  IconButton(
                    icon: Icon(Icons.add_alarm),
                    onPressed: () {
                      _showEditAlarmDialog(context, appState, null);
                    },
                  ),
                );
              }
              if (appState.selectedIndex == 2) {
                actionWidgets.add(
                  IconButton(
                    icon: Icon(Icons.person_add_alt_1),
                    onPressed: () {
                      // 친구 추가 버튼 눌렀을 때 반응 넣을 곳.
                    },
                  ),
                );
                actionWidgets.add(
                  Consumer<UserStatusProvider>(
                    builder: (context, userStatusProvider, child) {
                      return IconButton(
                        icon: Icon(Icons.nights_stay_outlined),
                        onPressed: () async {
                          await userStatusProvider.toggleSleepStatus();
                          print('Button pressed, new status: ${userStatusProvider.isSleeping}');
                        },
                      );
                    },
                  ),
                );
              }
              actionWidgets.add(
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {
                    // 설정 기능 구현
                  },
                ),
              );
              return Row(
                children: actionWidgets,
              );
            },
          ),
        ],
      ),
      body: BottomTabBar(),
    );
  }

  void _showEditAlarmDialog(BuildContext context, AppStatus appStatus, int? index) {
    final isNewAlarm = index == null;
    final initialTime = isNewAlarm ? TimeOfDay.now() : appStatus.alarms[index!].time;
    TimeOfDay selectedTime = initialTime;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('취소', style: TextStyle(color: Colors.orange)),
                  ),
                  Text(isNewAlarm ? '알람 추가' : '알람 편집'),
                  TextButton(
                    onPressed: () {
                      if (isNewAlarm) {
                        appStatus.addAlarm(selectedTime);
                      } else {
                        appStatus.updateAlarm(index!, selectedTime);
                      }
                      Navigator.of(context).pop();
                    },
                    child: Text('저장', style: TextStyle(color: Colors.orange)),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TimePickerSpinner(
                    time: initialTime,
                    onTimeChange: (time) {
                      setState(() {
                        selectedTime = time;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                ],
              ),
              actions: [
                if (!isNewAlarm)
                  Center(
                    child: TextButton(
                      onPressed: () {
                        appStatus.removeAlarm(index!);
                        Navigator.of(context).pop();
                      },
                      child: Text('알람 삭제', style: TextStyle(color: Colors.red)),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}

class TimePickerSpinner extends StatefulWidget {
  final TimeOfDay time;
  final Function(TimeOfDay) onTimeChange;

  TimePickerSpinner({required this.time, required this.onTimeChange});

  @override
  _TimePickerSpinnerState createState() => _TimePickerSpinnerState();
}

class _TimePickerSpinnerState extends State<TimePickerSpinner> {
  late TimeOfDay selectedTime;

  @override
  void initState() {
    super.initState();
    selectedTime = widget.time;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: CupertinoDatePicker(
        mode: CupertinoDatePickerMode.time,
        initialDateTime: DateTime(2021, 1, 1, selectedTime.hour, selectedTime.minute),
        onDateTimeChanged: (dateTime) {
          final newTime = TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
          setState(() {
            selectedTime = newTime;
          });
          widget.onTimeChange(newTime);
        },
      ),
    );
  }
}

