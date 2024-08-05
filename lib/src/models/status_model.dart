class StatusModel {
  int id;
  String description;

  StatusModel({
    required this.id,
    required this.description,
  });

  factory StatusModel.fromJson(Map<String, dynamic> json) {
    return StatusModel(
      id: json["id"],
      description: json["description"],
    );
  }
}
