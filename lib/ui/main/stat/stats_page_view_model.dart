import 'package:simple_todo_flutter/data/models/statistics/statistics.dart';
import 'package:simple_todo_flutter/data/repositories/statistics_repository.dart';
import 'package:simple_todo_flutter/utils/time.dart';

class StatsPageViewModel {
  StatisticsRepository _repo = StatisticsRepository();

  Statistics stats = Statistics();

  Future<int> initRepo(DateTime dateTime) async {
    stats = await _repo.initStatsBox(dateTime);
    return 0;
  }

  updateStats() async {
    await _repo.updateStats(stats);
  }

  int getCompletedTasks(DateTime dateTime) {
    return stats.days
        .firstWhere((element) =>
            element.date == dateTime.onlyDate().millisecondsSinceEpoch)
        .completedDefaultTasks;
  }

}