class MockTestModel {
  final bool success;
  final String? error; // nullable error field
  final List<Question> questions;

  MockTestModel({
    required this.success,
    this.error,
    required this.questions,
  });

  factory MockTestModel.fromJson(Map<String, dynamic> json) {
    // Handle error response
    if (json.containsKey('error')) {
      return MockTestModel(
        success: false,
        error: json['error'],
        questions: [],
      );
    }

    // Handle success response
    return MockTestModel(
      success: json['success'] ?? false,
      error: null,
      questions: (json['questions'] as List<dynamic>?)
          ?.map((e) => Question.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      if (error != null) 'error': error,
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
  final String option5;
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
    required this.option5,
    required this.detail,
    required this.capacity,
    required this.correctAnswer,
    required this.subjectName,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] ?? 0,
      question: json['question'] ?? '',
      option1: json['option1'] ?? '',
      option2: json['option2'] ?? '',
      option3: json['option3'] ?? '',
      option4: json['option4'] ?? '',
      option5: json['option5'] ?? '',
      detail: json['detail'] ?? '',
      capacity: json['capacity'] ?? '',
      correctAnswer: json['correct_answer'] ?? '',
      subjectName: json['subject_name'] ?? '',
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
      'option5': option5,
      'detail': detail,
      'capacity': capacity,
      'correct_answer': correctAnswer,
      'subject_name': subjectName,
    };
  }
}
