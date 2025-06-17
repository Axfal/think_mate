import 'package:education_app/resources/exports.dart';
import 'package:flutter_html/flutter_html.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
  }

  Future<void> getData() async {
    try {
      final provider = Provider.of<QuestionsProvider>(context, listen: false);

      await provider.fetchQuestions(context, 6, 29, 139);
    } catch (e, stackTrace) {
      debugPrint("Error fetching questions: $e");
      debugPrint("Stack trace: $stackTrace");

      if (mounted) {
        ToastHelper.showError("Error fetching questions: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<QuestionsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
      ),
      body: ListView(
        children: [Html(data: provider.questions!.questions[0].detail,  style: {
          "strong": Style(fontWeight: FontWeight.bold),
          "b": Style(fontWeight: FontWeight.bold),
          "i": Style(fontStyle: FontStyle.italic),
          "u": Style(textDecoration: TextDecoration.underline),
        },)],
      ),
    );
  }
}
