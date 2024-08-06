import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:neulbo/status/App_Status.dart';

import '../homescreen.dart';



class AlarmScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AppStatus>(
        builder: (context, appStatus, child) {
          return ListView.builder(
            itemCount: appStatus.alarms.length,
            itemBuilder: (context, index) {
              final alarm = appStatus.alarms[index];
              return Container(
                color: Colors.white, // 배경색상 하얀색으로 설정
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      title: Text(
                        alarm.time.format(context),
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        '알람',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                      trailing: Switch(
                        value: alarm.isActive,
                        onChanged: (value) {
                          appStatus.toggleAlarm(index);
                        },
                      ),
                      onTap: () {
                        _showEditAlarmDialog(context, appStatus, index);
                      },
                    ),
                    Divider(), // 각 알람 항목 사이에 구분선 추가
                  ],
                ),
              );
            },
          );
        },
      ),
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
