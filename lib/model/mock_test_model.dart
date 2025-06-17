class MockTestModel {
  final bool success;
  final List<Question> questions;

  MockTestModel({required this.success, required this.questions});

  factory MockTestModel.fromJson(Map<String, dynamic> json) {
    return MockTestModel(
      success: json['success'] ?? false,
      questions: (json['questions'] as List<dynamic>?)
              ?.map((e) => Question.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'questions': questions.map((q) => q.toJson()).toList(),
    };
  }
}

class Question {
  final int id;
  final String question;
  final String option1;
  final String option2;
  final String option3;
  final String option4;
  final String detail;
  final String capacity;
  final String correctAnswer;
  final String subjectName;

  Question({
    required this.id,
    required this.question,
    required this.option1,
    required this.option2,
    required this.option3,
    required this.option4,
    required this.detail,
    required this.capacity,
    required this.correctAnswer,
    required this.subjectName
  });

  // Helper method to remove HTML tags and decode HTML entities
  static String _cleanHtml(String html) {
    return html
        .replaceAll(RegExp(r'<[^>]*>'), '') // Remove HTML tags
        .replaceAll('&nbsp;', ' ') // Replace &nbsp; with space
        .trim();
  }

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] ?? 0,
      question: _cleanHtml(json['question'] ?? ''),
      option1: _cleanHtml(json['option1'] ?? ''),
      option2: _cleanHtml(json['option2'] ?? ''),
      option3: _cleanHtml(json['option3'] ?? ''),
      option4: _cleanHtml(json['option4'] ?? ''),
      detail: _cleanHtml(json['detail'] ?? ''),
      capacity: json['capacity'] ?? '',
      correctAnswer: json['correct_answer'] ?? '',
      subjectName: json['subject_name'] ?? ''
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'option1': option1,
      'option2': option2,
      'option3': option3,
      'option4': option4,
      'detail': detail,
      'capacity': capacity,
      'correct_answer': correctAnswer,
      'subject_name': subjectName
    };
  }
}
