import 'package:hive/hive.dart';
part 'previous_test_report_model.g.dart';


@HiveType(typeId: 2)
class PreviousTestReportModel extends HiveObject {
  @HiveField(0)
  String date;

  @HiveField(1)
  String subject;

  @HiveField(2)
  int percentage;

  @HiveField(3)
  String status;

  PreviousTestReportModel({
    required this.date,
    required this.subject,
    required this.percentage,
    required this.status,
  });
}
