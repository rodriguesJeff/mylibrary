import 'package:my_library/src/models/base_model.dart';

class UserModel extends BaseModel {
  final String id;
  final String name;
  final String photo;

  UserModel({
    required this.id,
    required this.name,
    required this.photo,
  });

  @override
  Map<String, dynamic> toJson() {
    return {"id": id, "name": name, "photo": photo};
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      name: json["name"],
      photo: json["photo"],
    );
  }

  @override
  String toString() {
    return 'UserModel{id: $id, name: $name, photo: $photo}';
  }
}
