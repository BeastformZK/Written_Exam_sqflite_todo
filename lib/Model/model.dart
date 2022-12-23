class TodoModel {
  final int? id;
  final String? title;
  final String? disc;
  final String? dateAndtime;

  TodoModel({
    this.id,
    this.title,
    this.disc,
    this.dateAndtime});

  TodoModel.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        title = res['title'],
        disc = res['disc'],
        dateAndtime = res['dateAndtime'];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'disc': disc,
      'dateAndtime': dateAndtime,
    };
  }
}
