class PriorityItem {
  final String description;
  final List<String> tags;

  PriorityItem({required this.description, required this.tags});

  factory PriorityItem.fromJson(dynamic json) {
    final description = json['item_to_check'];
    final tags = json['tags'].cast<String>();
    return PriorityItem(description: description, tags: tags);
  }

  @override
  String toString() {
    return "PriorityItem <description: $description, tags: $tags>";
  }
}

class PriorityList {
  final List<PriorityItem> priorityItemList;

  PriorityList({required this.priorityItemList});

  factory PriorityList.fromJson(dynamic json) {
    var fromJson = json.map((item) => PriorityItem.fromJson(item)).toList();
    return PriorityList(priorityItemList: List<PriorityItem>.from(fromJson));
  }

  @override
  String toString() {
    var result = "";
    for (var element in priorityItemList) {
      result += ("$element\n");
    }

    return result;
  }
}
