import 'package:tasks_go_brr/data/models/tag/tag.dart';
import 'package:tasks_go_brr/data/repositories/base/local_repository.dart';
import 'package:tasks_go_brr/data/repositories/day_repository.dart';
import 'package:tasks_go_brr/data/repositories/task_regulalry_repository.dart';
import 'package:tasks_go_brr/resources/constants.dart';

class TagsRepository extends LocalRepository {
  var _repoDay = DayRepository();
  var _repoTaskRegular = TaskRegularRepository();

  Future initTagsBox() async {
    await initBox<Tag>(Repo.TAG);
    await _repoDay.initAll();
    await _repoTaskRegular.initTaskBox();
  }

  addTag(Tag tag) async {
    await addItem(tag.id, tag);
  }

  removeTag(String id) async {
    _repoDay.getAllDays().forEach((day) {
      day.tasks.forEach((task) async {
        if (task.tags.contains(id)) {
          task.tags.removeWhere((element) => element == id);
          _repoDay.day = day;
          await _repoDay.updateTask(task);
        }
      });
    });
    _repoTaskRegular.getAllTasks().forEach((task) async {
      if (task.tags.contains(id)) {
        task.tags.removeWhere((tagId) => tagId == id);
        await _repoTaskRegular.updateTask(task);
      }
    });
    await deleteItem(id);
  }

  updateTag(Tag tag) async {
    await updateItem(tag.id, tag);
  }

  List<Tag> getAllTags() {
    return getAllItems() as List<Tag>;
  }
}