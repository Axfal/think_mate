// ignore_for_file: avoid_print

import 'package:education_app/resources/exports.dart';
import 'package:education_app/ui/view/drawer/note_book/pdf_%20viwer_screen.dart';
import 'package:flutter/cupertino.dart';
import '../../../../view_model/provider/note_book_provider.dart';

class MyNoteBook extends StatefulWidget {
  const MyNoteBook({super.key});

  @override
  State<MyNoteBook> createState() => _MyNoteBookState();
}

class _MyNoteBookState extends State<MyNoteBook> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<NoteBookProvider>().getNoteBooks(context));
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NoteBookProvider>();
    final books = provider.noteBookModel?.books ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('My Library',
            style: AppTextStyle.heading3.copyWith(
              color: AppColors.whiteColor,
            )),
        centerTitle: true,
        backgroundColor: AppColors.deepPurple,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios, color: AppColors.whiteColor),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.deepPurple, AppColors.lightPurple],
            ),
          ),
        ),
      ),
      body: provider.isLoading
          ? Center(child: CupertinoActivityIndicator())
          : books.isEmpty
              ? Center(
                  child: Text("No books available.",
                      style: AppTextStyle.appBarText
                          .copyWith(color: AppColors.darkText)))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    itemCount: books.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.75,
                    ),
                    itemBuilder: (context, index) {
                      final book = books[index];
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PDFViewerScreen(
                              title: book.title ?? 'Book',
                              url: book.filePath ?? '',
                            ),
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              colors: [
                                AppColors.deepPurple,
                                AppColors.lightPurple.withValues(alpha: 0.8)
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.menu_book_rounded,
                                  size: 40, color: Colors.white),
                              SizedBox(height: 12),
                              Text(
                                book.title ?? 'Untitled',
                                textAlign: TextAlign.center,
                                style: AppTextStyle.questionText.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
