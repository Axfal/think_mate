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
    if (_hasPostedResult) return;  // Prevent duplicate posting
    _hasPostedResult = true;       // Mark as posted

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
          ? widget.totalQues.toDouble() - (widget.correctAns + widget.incorrectAns)
          : 0.0,  // Handle zero division safely
    };
  }


  void isPassed() {
    // Avoid division by zero by checking if totalQues is greater than 0
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
        return AlertDialog(
          title: Text(title),
          content: Text(
            message,
            style: AppTextStyle.profileTitleText,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Result',
          style: AppTextStyle.appBarText,
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            PieChart(
              dataMap: dataMap,
              colorList: [
                Colors.green.shade600,
                Colors.red.shade600,
                Colors.yellow.shade600,
              ],
              ringStrokeWidth: 30,
              chartType: ChartType.disc,
              animationDuration: const Duration(seconds: 2),
            ),
            const SizedBox(height: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Correct Answers: ${dataMap['Correct']?.toInt()}',
                  style: AppTextStyle.profileTitleText,
                ),
                Text(
                  'Incorrect Answers: ${dataMap['Incorrect']?.toInt()}',
                  style: AppTextStyle.profileTitleText,
                ),
                Text(
                  'Unattempted: ${dataMap['Unattempted']?.toInt() ?? 0}',
                  style: AppTextStyle.profileTitleText,
                ),
              ],
            ),
            const SizedBox(height: 40),
            reusableButton(
              isPass ? 'Congratulate Me!' : 'Better Luck Next Time!',
              () => _showMessage(
                isPass ? 'Congratulations!' : 'Try Again!',
                isPass
                    ? 'You did a great job! Keep up the good work.'
                    : 'Keep practicing and you’ll improve!',
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<MockTestProvider>(context, listen: false).resetProvider();
          Provider.of<CreateMockTestProvider>(context, listen: false)
              .resetProvider();
          Navigator.pop(context);
        },
        backgroundColor: AppColors.primaryColor,
        child: const Icon(Icons.restart_alt, color: Colors.white),
      ),
    );
  }
}
