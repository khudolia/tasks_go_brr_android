import 'package:simple_todo_flutter/data/models/statistics/statistics.dart';
import 'package:simple_todo_flutter/data/repositories/base/local_repository.dart';
import 'package:simple_todo_flutter/resources/constants.dart';
import 'package:simple_todo_flutter/utils/time.dart';

class StatisticsRepository extends LocalRepository {
  late Statistics stats;

  Future<Statistics> initStatsBox(DateTime dateTime) async {
    await initBox<Statistics>(Repo.STATISTICS);

    stats = await initStats();
    await initDayStats(stats, dateTime);
    return stats;
  }

  Future<Statistics> initStats() async {
    Statistics? statsDb = getStatsFromDB();

    if(statsDb != null) {
      return statsDb;
    } else {
      var stats = Statistics();
      await addStats(stats);
      return stats;
    }
  }
  
  Future<void> initDayStats(Statistics stats, DateTime dateTime) async {

    if (stats.days
        .where((element) =>
    element!.date == dateTime
        .onlyDate()
        .millisecondsSinceEpoch)
        .isEmpty) {
      stats.days.add(DayStats()..date = dateTime.millisecondsSinceEpoch.onlyDateInMilli());
      await updateStats(stats);
    }
  }

  Future<void> addStats(Statistics stats) async {
    await addItem(stats.id, stats);
  }

  Future<void> updateStats(Statistics stats) async {
    await updateItem(stats.id, stats);
  }

  Statistics? getStatsFromDB() {
    return getAllItems().isNotEmpty ? getAllItems().first : null;
  }

  changeCompletedTasks(DateTime dateTime, bool shouldAdd, [bool isTaskDefault = true]) async {
    var dayStat = stats.days
        .firstWhere((element) => element!.date == dateTime.millisecondsSinceEpoch.onlyDateInMilli())!;

    if(isTaskDefault) {
      if (shouldAdd)
        dayStat.completedDefaultTasks++;
      else
        dayStat.completedDefaultTasks--;
    } else {
      if (shouldAdd)
        dayStat.completedRegularTasks++;
      else
        dayStat.completedRegularTasks--;
    }

    await updateStats(stats);
  }
}