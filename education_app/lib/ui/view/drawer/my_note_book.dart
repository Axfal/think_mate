import 'package:education_app/resources/exports.dart';

class MyNoteBook extends StatefulWidget {
  const MyNoteBook({super.key});

  @override
  State<MyNoteBook> createState() => _MyNoteBookState();
}

class _MyNoteBookState extends State<MyNoteBook> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Note Book',style: AppTextStyle.appBarText),
        automaticallyImplyLeading: true,
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
      ),
    );
  }
}
