import 'package:flutter/material.dart';


class Alarm {
  final TimeOfDay time;
  bool isActive;

  Alarm({required this.time, this.isActive = false});
}

class AppStatus with ChangeNotifier {
  int _selectedIndex = 0;
  List<Alarm> _alarms = [];

  int get selectedIndex => _selectedIndex;
  List<Alarm> get alarms => _alarms;

  void updateIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void addAlarm(TimeOfDay time) {
    _alarms.add(Alarm(time: time));
    notifyListeners();
  }

  void updateAlarm(int index, TimeOfDay newTime) {
    _alarms[index] = Alarm(time: newTime, isActive: _alarms[index].isActive);
    notifyListeners();
  }

  void toggleAlarm(int index) {
    _alarms[index].isActive = !_alarms[index].isActive;
    notifyListeners();
  }

  void removeAlarm(int index) {
    _alarms.removeAt(index);
    notifyListeners();
  }
}
