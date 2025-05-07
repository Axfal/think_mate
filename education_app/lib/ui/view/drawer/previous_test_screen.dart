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
              AppColors.deepPurple.withValues(alpha: 0.1),
              AppColors.lightPurple.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: provider.isLoading
            ? Center(child: CupertinoActivityIndicator())
            : testData.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history_edu,
                          size: 64,
                          color: AppColors.deepPurple.withValues(alpha: 0.5),
                        ),
                        SizedBox(height: 16),
                        Text(
                      "No previous test data available",
                      style: AppTextStyle.bodyText1.copyWith(
                        color: AppColors.darkText,
                            fontSize: 18,
                          ),
                      ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Your Test History",
                          style: AppTextStyle.heading3.copyWith(
                            color: AppColors.darkText,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "View your past test performances and track your progress",
                          style: AppTextStyle.bodyText2.copyWith(
                            color: AppColors.darkText.withValues(alpha: 0.7),
                          ),
                        ),
                        SizedBox(height: 24),
                        Card(
                          elevation: 4,
                          shadowColor: AppColors.deepPurple.withValues(alpha: 0.2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.deepPurple.withValues(alpha: 0.1),
                                width: 1,
                              ),
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              headingRowColor: MaterialStateProperty.all(
                                  AppColors.deepPurple.withValues(alpha: 0.05),
                                ),
                                headingTextStyle:
                                    AppTextStyle.bodyText1.copyWith(
                                        color: AppColors.darkText,
                                        fontWeight: FontWeight.w600,
                                ),
                                dataRowColor:
                                    MaterialStateProperty.resolveWith<Color?>(
                                  (Set<MaterialState> states) {
                                    if (states
                                        .contains(MaterialState.selected)) {
                                      return AppColors.deepPurple
                                          .withValues(alpha: 0.1);
                                    }
                                    return null;
                                  },
                                ),
                                columns: [
                                  DataColumn(
                                    label: _buildHeaderCell("Date"),
                                  ),
                                  DataColumn(
                                    label: _buildHeaderCell("Subject"),
                                  ),
                                  DataColumn(
                                    label: _buildHeaderCell("Correct"),
                                ),
                                DataColumn(
                                    label: _buildHeaderCell("Incorrect"),
                                ),
                                DataColumn(
                                    label: _buildHeaderCell("Percentage"),
                                ),
                                DataColumn(
                                    label: _buildHeaderCell("Status"),
                                ),
                              ],
                              rows: testData
                                  .map((data) => _buildRow(data))
                                  .toList(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Text(
        text,
        style: AppTextStyle.bodyText1.copyWith(
          color: AppColors.darkText,
          fontWeight: FontWeight.w600,
                  ),
      ),
    );
  }

  DataRow _buildRow(List<String> data) {
    return DataRow(
      cells: [
        DataCell(_buildCell(data[0])),
        DataCell(_buildCell(data[1])),
        DataCell(_buildCell(data[2], isNumber: true)),
        DataCell(_buildCell(data[3], isNumber: true)),
        DataCell(_buildPercentageCell(data[4])),
        DataCell(_buildStatusCell(data[5])),
      ],
    );
  }

  Widget _buildCell(String text, {bool isNumber = false}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Text(
        text,
            style: AppTextStyle.bodyText2.copyWith(
              color: AppColors.darkText,
          fontWeight: isNumber ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildPercentageCell(String percentage) {
    final value = double.tryParse(percentage.replaceAll('%', '')) ?? 0;
    Color color;
    if (value >= 80) {
      color = AppColors.successColor;
    } else if (value >= 60) {
      color = AppColors.warningColor;
    } else {
      color = AppColors.errorColor;
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Text(
        percentage,
            style: AppTextStyle.bodyText2.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildStatusCell(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'pass':
        color = AppColors.successColor;
        break;
      case 'fail':
        color = AppColors.errorColor;
        break;
      default:
        color = AppColors.warningColor;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        alignment: Alignment.center,
        child: Text(
          status,
          textAlign: TextAlign.center,
          style: AppTextStyle.bodyText2.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    )
    ;
  }
}
