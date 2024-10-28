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

  factory MemoSummaryType.fromJson(Map<String, dynamic> json) {
    return MemoSummaryType(
      id: json['id'],
      name: json['name'],
      tag: json['tag'],
      length: json['length'],
    );
  }
}

class MemoDetailType extends MemoType {
  final List<TaskType> tasks;

  MemoDetailType({
    required int id,
    required String name,
    required bool tag,
    required this.tasks,
  }) : super(id: id, name: name, tag: tag);

  factory MemoDetailType.fromJson(Map<String, dynamic> json) {
    var tasksFromJson = json['tasks'] != null ? json['tasks'] as List : [];
    // JSONの各要素からTaskTypeのインスタンスリストを生成
    List<TaskType> taskList =
        tasksFromJson.map((taskJson) => TaskType.fromJson(taskJson)).toList();
    return MemoDetailType(
      id: json['id'],
      name: json['name'],
      tag: json['tag'],
      tasks: taskList,
    );
  }
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

  factory TaskType.fromJson(Map<String, dynamic> json) {
    return TaskType(
      id: json['id'],
      name: json['name'],
      memoId: json['memo_id'],
      complete: json['complete'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'memo_id': memoId,
        'complete': complete,
      };
}

class TaskOrder {
  final int id;
  final List<int> order;
  TaskOrder({
    required this.id,
    required this.order,
  });
}

class ClientData {
  final int tab;
  ClientData({
    required this.tab,
  });
  factory ClientData.fromJson(Map<String, dynamic> json) {
    return ClientData(
      tab: json['tab'],
    );
  }
}
