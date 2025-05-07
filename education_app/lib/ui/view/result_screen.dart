// ignore_for_file: avoid_print

import 'package:education_app/resources/exports.dart';
import 'package:education_app/view_model/provider/post_test_result_provider.dart';

class ResultScreen extends StatefulWidget {
  final String subject;
  final int correctAns;
  final int incorrectAns;
  final int totalQues;
  final List<Map<String, dynamic>> questions;

  const ResultScreen(
      {super.key,
      required this.subject,
      required this.correctAns,
      required this.incorrectAns,
      required this.totalQues,
      required this.questions});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _hasPostedResult = false;
  bool isPass = false;
  int percentage = 0;
  late Map<String, double> dataMap;

  @override
  void initState() {
    super.initState();
    setMapData();
    isPassed();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      postTestResult();
    });
  }

  void postTestResult() async {
    if (_hasPostedResult) return;
    _hasPostedResult = true;

    final provider =
        Provider.of<PostTestResultProvider>(context, listen: false);
    print(widget.questions);
    if (widget.questions.isNotEmpty) {
      await provider.postTestResult(context, widget.questions);
    } else {
      print('Questions list is empty');
    }
  }

  void setMapData() {
    dataMap = {
      'Correct': widget.correctAns.toDouble(),
      'Incorrect': widget.incorrectAns.toDouble(),
      'Unattempted': widget.totalQues > 0
          ? widget.totalQues.toDouble() -
              (widget.correctAns + widget.incorrectAns)
          : 0.0,
    };
  }

  void isPassed() {
    final percent = widget.totalQues > 0
        ? (widget.correctAns / widget.totalQues) * 100
        : 0.0;

    percentage = percent.toInt();
    isPass = percentage > 37;
  }

  void _showMessage(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyle.heading3.copyWith(
                    color: AppColors.darkText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  message,
                  style: AppTextStyle.profileTitleText.copyWith(
                    color: AppColors.darkText.withValues(alpha: 0.85),
                  ),
                ),
                SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.indigo,
                        foregroundColor: AppColors.whiteColor,
                        padding: EdgeInsets.symmetric(horizontal: 28),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Close',
                        style: AppTextStyle.bodyText1.copyWith(
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Result',
          style: AppTextStyle.appBarText,
        ),
        centerTitle: true,
        backgroundColor: AppColors.deepPurple,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 80 : 16,
              vertical: isTablet ? 32 : 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.purpleShadow.withValues(alpha: 0.10),
                        blurRadius: 16,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 48 : 20,
                    vertical: isTablet ? 40 : 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Text(
                      //   widget.subject,
                      //   style: AppTextStyle.heading2.copyWith(
                      //     color: AppColors.deepPurple,
                      //     fontWeight: FontWeight.bold,
                      //     fontSize: isTablet ? 32 : 24,
                      //   ),
                      //   textAlign: TextAlign.center,
                      // ),
                      // SizedBox(height: 8),
                      Text(
                        isPass
                            ? 'Congratulations on completing your test!'
                            : 'Keep practicing to improve your score!',
                        style: AppTextStyle.bodyText1.copyWith(
                          color: isPass
                              ? AppColors.successColor
                              : AppColors.errorColor,
                          fontWeight: FontWeight.w600,
                          fontSize: isTablet ? 20 : 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Here is your performance breakdown:',
                        style: AppTextStyle.bodyText2.copyWith(
                          color: AppColors.greyText,
                          fontSize: isTablet ? 18 : 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: isTablet ? 32 : 20),
          
                      /// pi chart card
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.backgroundColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.lightIndigo.withOpacity(0.40),
                              blurRadius: 16,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: PieChart(
                            dataMap: dataMap,
                            colorList: [
                              AppColors.successColor,
                              AppColors.errorColor,
                              AppColors.warningColor,
                            ],
                            ringStrokeWidth: isTablet ? 40 : 30,
                            chartType: ChartType.disc,
                            animationDuration: const Duration(seconds: 3),
                            chartLegendSpacing: 20,
                            legendOptions: LegendOptions(
                              showLegends: true,
                              legendPosition: isTablet
                                  ? LegendPosition.right
                                  : LegendPosition.bottom,
                              legendTextStyle: AppTextStyle.bodyText1.copyWith(
                                color: AppColors.darkText,
                                fontWeight: FontWeight.w500,
                                fontSize: isTablet ? 20 : 16,
                              ),
                            ),
                            chartValuesOptions: ChartValuesOptions(
                              showChartValues: true,
                              showChartValuesInPercentage: true,
                              showChartValuesOutside: false,
                              chartValueStyle: AppTextStyle.bodyText1.copyWith(
                                color: AppColors.headingColor,
                                fontWeight: FontWeight.w500,
                                fontSize: isTablet ? 20 : 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: isTablet ? 40 : 30),
          
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _resultStat(
                            label: 'Correct',
                            value: dataMap['Correct']?.toInt() ?? 0,
                            color: AppColors.successColor,
                            isTablet: isTablet,
                          ),
                          _resultStat(
                            label: 'Incorrect',
                            value: dataMap['Incorrect']?.toInt() ?? 0,
                            color: AppColors.errorColor,
                            isTablet: isTablet,
                          ),
                          _resultStat(
                            label: 'Unattempted',
                            value: dataMap['Unattempted']?.toInt() ?? 0,
                            color: AppColors.warningColor,
                            isTablet: isTablet,
                          ),
                        ],
                      ),
                      SizedBox(height: isTablet ? 48 : 32),
                      reusableButton(
                        isPass ? 'Congratulate Me!' : 'Better Luck Next Time!',
                        () => _showMessage(
                          isPass ? 'Congratulations!' : 'Try Again!',
                          isPass
                              ? 'You did a great job! Keep up the good work.'
                              : 'Keep practicing and you will improve!',
                        ),
                      ),
                      SizedBox(height: isTablet ? 32 : 24),
          
                      /// floating action button inside card
                      Column(
                        children: [
                          Tooltip(
                            message: 'Retake Test',
                            child: InkWell(
                              onTap: () {
                                Provider.of<MockTestProvider>(context,
                                        listen: false)
                                    .resetProvider();
                                Provider.of<CreateMockTestProvider>(context,
                                        listen: false)
                                    .resetProvider();
                                Navigator.pop(context);
                              },
                              borderRadius: BorderRadius.circular(30),
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: AppColors.indigo,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.purpleShadow
                                          .withValues(alpha: 0.18),
                                      blurRadius: 12,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Icon(Icons.restart_alt,
                                    color: AppColors.whiteColor, size: 32),
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Retake Test',
                            style: AppTextStyle.bodyText2.copyWith(
                              color: AppColors.indigo,
                              fontWeight: FontWeight.w600,
                              fontSize: isTablet ? 18 : 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _resultStat({
    required String label,
    required int value,
    required Color color,
    required bool isTablet,
  }) {
    return Column(
      children: [
        Container(
          width: isTablet ? 60 : 44,
          height: isTablet ? 60 : 44,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              value.toString(),
              style: AppTextStyle.heading2.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: isTablet ? 28 : 20,
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: AppTextStyle.bodyText1.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: isTablet ? 18 : 14,
          ),
        ),
      ],
    );
  }
}
