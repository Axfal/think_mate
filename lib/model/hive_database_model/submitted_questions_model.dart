import 'package:hive/hive.dart';

part 'submitted_questions_model.g.dart';

@HiveType(typeId: 3)
class SubmittedQuestionsModel extends HiveObject {
  @HiveField(0)
  int questionId;

  @HiveField(1)
  String questionResult;

  @HiveField(2)
  int selectedOption;

  @HiveField(3)
  int chapterId;

  SubmittedQuestionsModel(
      {required this.questionId,
      required this.chapterId,
      required this.questionResult,
      required this.selectedOption});
}
