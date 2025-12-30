class ModelClass {
  final int id;
  final String name;
  final String age;

  ModelClass({required this.id, required this.name, required this.age});

  factory ModelClass.fromMap(Map<String, dynamic> map) {
    return ModelClass(id: map['id'], name: map['name'], age: map['age']);
  }

  Map<String, Object?> toMap() {
    return {"id": id, "name": name, "age": age};
  }
}
