import 'package:simple_todo_flutter/data/models/tag/tag.dart';
import 'package:simple_todo_flutter/data/repositories/tags_repository.dart';

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