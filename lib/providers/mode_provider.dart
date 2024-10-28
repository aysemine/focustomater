import 'package:flutter/material.dart';

enum Mode { Easy, Hard }

class ModeProvider with ChangeNotifier {
  Mode _currentMode = Mode.Easy;
  int _exp = 0; // Global EXP variable
  Duration _dailyTime = Duration.zero; // Variable to store daily time
  DateTime? _lastResetDate; // Variable to track the last reset date

  Mode get currentMode => _currentMode;
  int get exp => _exp;

  String get formattedDailyTime =>
      "${_dailyTime.inHours}h ${(_dailyTime.inMinutes.remainder(60))}m ${(_dailyTime.inSeconds.remainder(60))}s";

  void setMode(Mode mode) {
    _currentMode = mode;
    notifyListeners();
  }

  void addExp(int points) {
    _exp += points;
    notifyListeners();
  }

  void deductExp(int points) {
    _exp = (_exp - points).clamp(0, double.infinity).toInt();
    notifyListeners();
  }

  void updateDailyTime(Duration duration) {
    // Check if it's a new day
    if (_lastResetDate == null ||
        DateTime.now().difference(_lastResetDate!).inDays > 0) {
      _dailyTime = duration; // Reset daily time to the current elapsed time
      _lastResetDate = DateTime.now(); // Update last reset date
    } else {
      _dailyTime += duration; // Accumulate daily time
    }
    notifyListeners();
  }

  void completeTask(Duration elapsed) {
    // Award EXP based on the elapsed time and current mode
    int points = 0;
    if (_currentMode == Mode.Easy) {
      points = elapsed.inMinutes; // 1 EXP for each minute in Easy Mode
      addExp(points + 1); // Additional 1 EXP bonus for successful completion
    } else if (_currentMode == Mode.Hard) {
      points = elapsed.inMinutes * 2; // 2 EXP for each minute in Hard Mode
      addExp(points + 10); // Additional 10 EXP bonus for successful completion
    }
    updateDailyTime(elapsed); // Update daily time with completed duration
  }


  void finishEarly(Duration remaining) {
    // Deduct EXP based on remaining time
    int deduction = _currentMode == Mode.Easy ? remaining.inMinutes : remaining.inMinutes * 2;
    deductExp(deduction);
  }

  void resetTimer(Duration remaining) {
    // Deduct EXP based on remaining time for reset
    finishEarly(remaining);
  }

  void resetDailyTime() {
    _dailyTime = Duration.zero; // Reset daily time to zero
    notifyListeners();
  }
}
