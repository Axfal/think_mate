class CheckUserSubscriptionPlanModel {
  bool? success;
  String? userType;
  String? subscriptionName;
  String? subscriptionStartDate;
  String? subscriptionEndDate;
  int? testId;

  CheckUserSubscriptionPlanModel(
      {this.success,
        this.userType,
        this.subscriptionName,
        this.subscriptionStartDate,
        this.subscriptionEndDate,
        this.testId});

  CheckUserSubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    userType = json['user_type'];
    subscriptionName = json['subscription_name'];
    subscriptionStartDate = json['subscription_start_date'];
    subscriptionEndDate = json['subscription_end_date'];
    testId = json['test_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['user_type'] = this.userType;
    data['subscription_name'] = this.subscriptionName;
    data['subscription_start_date'] = this.subscriptionStartDate;
    data['subscription_end_date'] = this.subscriptionEndDate;
    data['test_id'] = this.testId;
    return data;
  }
}
