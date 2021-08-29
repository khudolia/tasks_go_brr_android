import 'package:tasks_go_brr/data/models/tag/tag.dart';
import 'package:tasks_go_brr/data/repositories/tags_repository.dart';

class TagsDialogViewModel {
  TagsRepository _repo = TagsRepository();
  Tag tag = Tag();

  List<Tag> chosenTags = [];

  initRepo() async => await _repo.initTagsBox();

  addTag() async {
    await _repo.addTag(tag);
    tag = Tag();
  }

  removeTag(String id) async => await _repo.removeTag(id);

  List<Tag> getAllTags() => _repo.getAllTags();
}