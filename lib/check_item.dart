class ItemToCheck {
  final int id;
  final String itemToCheck;
  final String tags;
  final bool toTest;
  final String createdAt;
  final String updatedAt;

  ItemToCheck({
    required this.id,
    required this.itemToCheck,
    required this.tags,
    required this.toTest,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ItemToCheck.fromJson(Map<String, dynamic> json) {
    return ItemToCheck(
      id: json['id'],
      itemToCheck: json['item_to_check'],
      tags: json['tags'],
      toTest: json['to_test'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
