import 'package:flutter/cupertino.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:education_app/resources/exports.dart';

class HintScreen extends StatefulWidget {
  final int testId;

  const HintScreen({super.key, required this.testId});

  @override
  State<HintScreen> createState() => _HintScreenState();
}

class _HintScreenState extends State<HintScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      if (!mounted) return;

      final provider = Provider.of<HintProvider>(context, listen: false);

      if (provider.hintModel == null ||
          provider.hintModel!.data == null ||
          provider.hintModel!.data!.isEmpty ||
          widget.testId != provider.hintModel!.data!.first.testId) {
        await provider.loadAllHints(widget.testId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HintProvider>(context);
    final subjectProvider =
        Provider.of<SubjectProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Reference Values"),
        centerTitle: true,
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back_ios, color: Colors.white)),
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.deepPurple, AppColors.lightPurple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: provider.isLoading
          ? const Center(child: CupertinoActivityIndicator())
          : provider.hintModel?.data == null ||
                  provider.hintModel!.data!.isEmpty
              ? const Center(
                  child: Text(
                    "No hints available.",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    await Provider.of<HintProvider>(context, listen: false)
                        .loadAllHints(widget.testId);
                  },
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: provider.hintModel!.data!.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final hint = provider.hintModel!.data![index];
                      final subjectName =
                          subjectProvider.getSubjectName(hint.subjectId!);
                      return _buildHintCard(subjectName, hint.hintText);
                    },
                  ),
                ),
    );
  }

  Widget _buildHintCard(String subjectName, String? hintText) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackOverlay30.withValues(alpha: 0.12),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb_outline, color: AppColors.indigo),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    subjectName,
                    style: AppTextStyle.heading3.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: AppColors.darkText,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Html(
              data: hintText ?? "",
              style: {
                "p": Style(fontSize: FontSize.medium),
                "li": Style(
                    fontSize: FontSize.medium,
                    padding: HtmlPaddings.only(bottom: 8)),
                "em": Style(fontStyle: FontStyle.italic),
                "ol": Style(margin: Margins.only(left: 16)),
              },
            ),
          ],
        ),
      ),
    );
  }
}
