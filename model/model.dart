class Todo {
  late int id;
  late String title;

  Todo(this.id, this.title);

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      json['id'] as int,
      json['title'] as String,
    );
  }
}