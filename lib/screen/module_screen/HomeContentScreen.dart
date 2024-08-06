import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';



class HomeContentScreen extends StatefulWidget {
  const HomeContentScreen({super.key});

  @override
  _HomeContentScreenState createState() => _HomeContentScreenState();
}

class _HomeContentScreenState extends State<HomeContentScreen> {
  DateTime? sleepTime;
  DateTime? wakeUpTime;

  String recommendWakeUpTime(DateTime sleepTime) {
    final recommendedWakeUpTime = sleepTime.add(Duration(hours: 7, minutes: 30));
    return DateFormat('hh:mm a').format(recommendedWakeUpTime);
  }

  List<String> recommendSleepTimes(DateTime wakeUpTime) {
    final times = <DateTime>[
      wakeUpTime.subtract(Duration(hours: 7, minutes: 30)),
      wakeUpTime.subtract(Duration(hours: 6)),
      wakeUpTime.subtract(Duration(hours: 4, minutes: 30)),
      wakeUpTime.subtract(Duration(hours: 3)),
    ];
    return times.map((time) => DateFormat('hh:mm a').format(time)).toList();
  }

  void _selectWakeUpTime(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 250,
        color: Color.fromARGB(255, 255, 255, 255),
        child: Column(
          children: [
            Container(
              height: 200,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                initialDateTime: DateTime.now(),
                onDateTimeChanged: (DateTime newTime) {
                  setState(() {
                    wakeUpTime = newTime;
                  });
                },
              ),
            ),
            CupertinoButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            SizedBox(height: 20),
            Text(
              "몇 시에 자야 꿀잠 ?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  sleepTime = DateTime.now();
                });
              },
              child: Text("현재 시간에 자는 시간 설정"),
            ),
            if (sleepTime != null) ...[
              SizedBox(height: 10),
              Text("추천 알람 시간: ${recommendWakeUpTime(sleepTime!)}"),
            ],
            SizedBox(height: 20),
            Divider(),
            SizedBox(height: 20),
            Text(
              "이 때 일어나려면 몇시에 자야 꿀잠 ?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            CupertinoButton(
              child: Text("일어나는 시간 선택"),
              onPressed: () => _selectWakeUpTime(context),
            ),
            if (wakeUpTime != null) ...[
              SizedBox(height: 10),
              Text("추천 수면 시간:"),
              for (var time in recommendSleepTimes(wakeUpTime!)) Text(time),
            ],
          ],
        ),

      ),
    );
  }
}

