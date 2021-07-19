import 'package:simple_todo_flutter/data/models/statistics/statistics.dart';
import 'package:simple_todo_flutter/data/repositories/base/local_repository.dart';
import 'package:simple_todo_flutter/resources/constants.dart';

class StatisticsRepository extends LocalRepository {
  late Statistics stats;

  Future<Statistics> initStatsBox(DateTime dateTime) async {
    await initBox<Statistics>(Repo.STATISTICS);

    stats = await initStats();
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

  Future<void> addStats(Statistics stats) async {
    await addItem(stats.id, stats);
  }

  Future<void> updateStats(Statistics stats) async {
    await updateItem(stats.id, stats);
  }

  Statistics? getStatsFromDB() {
    return getAllItems().isNotEmpty ? getAllItems().first : null;
  }
}