abstract class MemoType {
  final int id;
  final String name;
  final bool tag;

  MemoType({
    required this.id,
    required this.name,
    required this.tag,
  });
}

class MemoSummaryType extends MemoType {
  final int length;

  MemoSummaryType({
    required int id,
    required String name,
    required bool tag,
    required this.length,
  }) : super(id: id, name: name, tag: tag);
}

class MemoDetailType extends MemoType {
  final List<TaskType> tasks;

  MemoDetailType({
    required int id,
    required String name,
    required bool tag,
    required this.tasks,
  }) : super(id: id, name: name, tag: tag);
}

class TaskType {
  final int id;
  final String name;
  final int memoId;
  final bool complete;

  TaskType({
    required this.id,
    required this.name,
    required this.memoId,
    required this.complete,
  });
}
