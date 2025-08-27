class NoteBookModel {
  final bool? success;
  final int? total;
  final List<Book>? books;

  NoteBookModel({
    this.success,
    this.total,
    this.books,
  });

  factory NoteBookModel.fromJson(Map<String, dynamic> json) {
    return NoteBookModel(
      success: json['success'] as bool?,
      total: json['total'] as int?,
      books: (json['books'] as List<dynamic>?)
          ?.map((e) => Book.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'total': total,
      'books': books?.map((e) => e.toJson()).toList(),
    };
  }
}

class Book {
  final int? id;
  final String? title;
  final String? filePath;
  final int? folderId;
  final int? testId;
  final String? testName;

  Book({
    this.id,
    this.title,
    this.filePath,
    this.folderId,
    this.testId,
    this.testName,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] as int?,
      title: json['title'] as String?,
      filePath: json['file_path'] as String?,
      folderId: json['folder_id'] as int?,
      testId: json['test_id'] as int?,
      testName: json['test_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'file_path': filePath,
      'folder_id': folderId,
      'test_id': testId,
      'test_name': testName,
    };
  }
}
