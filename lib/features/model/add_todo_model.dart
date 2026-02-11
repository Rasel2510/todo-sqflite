class ModelClass {
  int id;
  String name;
  String age;
  String createdAt;

  ModelClass({
    required this.id,
    required this.name,
    required this.age,
    required this.createdAt,
  });

  factory ModelClass.fromMap(Map<String, dynamic> map) {
    return ModelClass(
      id: map['id'],
      name: map['name'],
      age: map['age'],
      createdAt: map['createdAt'],
    );
  }

  Map<String, Object?> toMap() {
    return {"id": id, "name": name, "age": age, "createdAt": createdAt};
  }
}
