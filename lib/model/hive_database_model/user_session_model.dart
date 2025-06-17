import 'package:hive/hive.dart';

part 'user_session_model.g.dart';

@HiveType(typeId: 1)
class UserSessionModel extends HiveObject {
  @HiveField(0)
  int userId;

  @HiveField(1)
  String userType;

  @HiveField(2)
  int testId;

  @HiveField(3)
  String subscriptionName;

  UserSessionModel({
    required this.userId,
    required this.userType,
    required this.testId,
    required this.subscriptionName,
  });
}
