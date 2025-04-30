class ChapterModel {
  bool? success;
  List<Chapters>? chapters;

  ChapterModel({this.success, this.chapters});

  ChapterModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['chapters'] != null) {
      chapters = <Chapters>[];
      json['chapters'].forEach((v) {
        chapters!.add(new Chapters.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.chapters != null) {
      data['chapters'] = this.chapters!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Chapters {
  int? id;
  int? testId;
  int? subjectId;
  String? chapNo;
  String? chapName;

  Chapters({this.id, this.testId, this.subjectId, this.chapNo, this.chapName});

  Chapters.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    testId = json['test_id'];
    subjectId = json['subject_id'];
    chapNo = json['chap_no'];
    chapName = json['chap_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['test_id'] = this.testId;
    data['subject_id'] = this.subjectId;
    data['chap_no'] = this.chapNo;
    data['chap_name'] = this.chapName;
    return data;
  }
}
