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
          style: AppTextStyle.heading3.copyWith(
            color: AppColors.whiteColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.deepPurple,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: AppColors.whiteColor),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.deepPurple,
                AppColors.lightPurple,
              ],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.deepPurple.withOpacity(0.1),
              AppColors.lightPurple.withOpacity(0.05),
            ],
          ),
        ),
        child: provider.isLoading
            ? Center(child: CupertinoActivityIndicator())
            : testData.isEmpty
                ? Center(
                    child: Text(
                      "No previous test data available",
                      style: AppTextStyle.bodyText1.copyWith(
                        color: AppColors.darkText,
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              headingRowColor: MaterialStateProperty.all(
                                AppColors.deepPurple.withOpacity(0.1),
                              ),
                              columns: [
                                DataColumn(
                                  label: Text("Date",
                                      style: AppTextStyle.bodyText1.copyWith(
                                        color: AppColors.darkText,
                                        fontWeight: FontWeight.w600,
                                      )),
                                ),
                                DataColumn(
                                  label: Text("Subject",
                                      style: AppTextStyle.bodyText1.copyWith(
                                        color: AppColors.darkText,
                                        fontWeight: FontWeight.w600,
                                      )),
                                ),
                                DataColumn(
                                  label: Text("Correct",
                                      style: AppTextStyle.bodyText1.copyWith(
                                        color: AppColors.darkText,
                                        fontWeight: FontWeight.w600,
                                      )),
                                ),
                                DataColumn(
                                  label: Text("Incorrect",
                                      style: AppTextStyle.bodyText1.copyWith(
                                        color: AppColors.darkText,
                                        fontWeight: FontWeight.w600,
                                      )),
                                ),
                                DataColumn(
                                  label: Text("Percentage",
                                      style: AppTextStyle.bodyText1.copyWith(
                                        color: AppColors.darkText,
                                        fontWeight: FontWeight.w600,
                                      )),
                                ),
                                DataColumn(
                                  label: Text("Status",
                                      style: AppTextStyle.bodyText1.copyWith(
                                        color: AppColors.darkText,
                                        fontWeight: FontWeight.w600,
                                      )),
                                ),
                              ],
                              rows: testData
                                  .map((data) => _buildRow(data))
                                  .toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }

  DataRow _buildRow(List<String> data) {
    return DataRow(
      cells: [
        DataCell(Text(data[0],
            style: AppTextStyle.bodyText2.copyWith(
              color: AppColors.darkText,
            ))),
        DataCell(Text(data[1],
            style: AppTextStyle.bodyText2.copyWith(
              color: AppColors.darkText,
            ))),
        DataCell(Text(data[2],
            style: AppTextStyle.bodyText2.copyWith(
              color: AppColors.darkText,
            ))),
        DataCell(Text(data[3],
            style: AppTextStyle.bodyText2.copyWith(
              color: AppColors.darkText,
            ))),
        DataCell(Text(data[4],
            style: AppTextStyle.bodyText2.copyWith(
              color: AppColors.darkText,
            ))),
        DataCell(Text(
          data[5],
          style: AppTextStyle.bodyText2.copyWith(
            color:
                data[5] == "Pass" ? AppColors.successColor : AppColors.redColor,
            fontWeight: FontWeight.w600,
          ),
        )),
      ],
    );
  }
}
