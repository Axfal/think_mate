class NoteBookModel {
  bool? success;
  int? total;
  List<Books>? books;

  NoteBookModel({this.success, this.total, this.books});

  NoteBookModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    total = json['total'];
    if (json['books'] != null) {
      books = <Books>[];
      json['books'].forEach((v) {
        books!.add(new Books.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['total'] = this.total;
    if (this.books != null) {
      data['books'] = this.books!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Books {
  int? id;
  String? title;
  String? filePath;
  int? testId;
  String? testName;

  Books({this.id, this.title, this.filePath, this.testId, this.testName});

  Books.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    filePath = json['file_path'];
    testId = json['test_id'];
    testName = json['test_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['file_path'] = this.filePath;
    data['test_id'] = this.testId;
    data['test_name'] = this.testName;
    return data;
  }
}
