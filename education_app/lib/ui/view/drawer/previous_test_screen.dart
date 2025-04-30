// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:education_app/resources/exports.dart';
import 'package:flutter/cupertino.dart';

class PreviousTestScreen extends StatefulWidget {
  const PreviousTestScreen({super.key});

  @override
  State<PreviousTestScreen> createState() => _PreviousTestScreenState();
}

class _PreviousTestScreenState extends State<PreviousTestScreen> {
  List<List<String>> testData = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadPreviousTests();
    });
  }

  void loadPreviousTests() async {
    final provider = Provider.of<PreviousTestProvider>(context, listen: false);
    await provider.getTestData(context);

    if (provider.getTestModel != null &&
        provider.getTestModel!.success == true) {
      testData = provider.getTestModel!.examResults
              ?.where(
                  (exam) => exam.subjects != null && exam.subjects!.isNotEmpty)
              .expand((exam) {
            String examType = exam.examType?.toLowerCase() ?? "unknown";

            if (examType.contains("mock test")) {
              return [
                [
                  exam.date ?? "N/A",
                  "Mock Test",
                  exam.overall?.correct?.toString() ?? "0",
                  exam.overall?.incorrect?.toString() ?? "0",
                  exam.overall?.percentage ?? "0%",
                  exam.overall?.status ?? "N/A",
                ]
              ];
            }

            return exam.subjects!.map((subject) => [
                  exam.date ?? "N/A",
                  subject.subjectName ?? "N/A",
                  exam.overall?.correct?.toString() ?? "0",
                  exam.overall?.incorrect?.toString() ?? "0",
                  exam.overall?.percentage ?? "0%",
                  exam.overall?.status ?? "N/A",
                ]);
          }).toList() ??
          [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PreviousTestProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Previous Tests Report",
          style: AppTextStyle.appBarText,
        ),
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      body: provider.isLoading
          ? Center(
              child: CupertinoActivityIndicator(),
            )
          : testData.isEmpty
              ? Center(child: Text("No test data available"))
              : Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: DataTable(
                              headingRowColor:
                                  MaterialStateProperty.resolveWith(
                                      (states) => AppColors.primaryColor),
                              border: TableBorder.all(
                                  color: Colors.grey.shade300, width: 1),
                              columns: [
                                DataColumn(
                                    label: Text("Date",
                                        style: AppTextStyle.drawerText)),
                                DataColumn(
                                    label: Text("Subject",
                                        style: AppTextStyle.drawerText)),
                                DataColumn(
                                    label: Text("Correct",
                                        style: AppTextStyle.drawerText)),
                                DataColumn(
                                    label: Text("Incorrect",
                                        style: AppTextStyle.drawerText)),
                                DataColumn(
                                    label: Text("Percentage",
                                        style: AppTextStyle.drawerText)),
                                DataColumn(
                                    label: Text("Status",
                                        style: AppTextStyle.drawerText)),
                              ],
                              rows: testData
                                  .map((data) => _buildRow(data))
                                  .toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  DataRow _buildRow(List<String> data) {
    return DataRow(
      cells: [
        DataCell(Text(data[0])),
        DataCell(Text(data[1])),
        DataCell(Text(data[2])),
        DataCell(Text(data[3])),
        DataCell(Text(data[4])),
        DataCell(Text(
          data[5],
          style: TextStyle(
            color: data[5] == "Pass" ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        )),
      ],
    );
  }
}
