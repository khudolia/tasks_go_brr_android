import 'package:tasks_go_brr/data/models/tag/tag.dart';
import 'package:tasks_go_brr/data/repositories/base/local_repository.dart';
import 'package:tasks_go_brr/resources/constants.dart';

class TagsRepository extends LocalRepository {

  Future initTagsBox() async {
    await initBox<Tag>(Repo.TAG);
  }

  addTag(Tag tag) async {
    await addItem(tag.id, tag);
  }

  removeTag(String id) async {
    await deleteItem(id);
  }

  updateTag(Tag tag) async {
    await updateItem(tag.id, tag);
  }

  List<Tag> getAllTags() {
    return getAllItems() as List<Tag>;
  }
}