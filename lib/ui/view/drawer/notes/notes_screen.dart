import 'package:education_app/utils/screenshot_protector.dart';
import 'package:education_app/utils/toast_helper.dart';
import 'package:education_app/view_model/provider/book_mark_provider.dart';
import 'package:education_app/view_model/provider/notes_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../model/get_notes_model.dart';

class NotesScreen extends StatefulWidget {
  final int subjectId;
  const NotesScreen({super.key, required this.subjectId});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final questionController = TextEditingController();
  final answerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ScreenshotProtector.enableProtection();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NotesProvider>(context, listen: false)
          .getNotes(context, widget.subjectId);
    });
  }

  @override
  void dispose() {
    ScreenshotProtector.disableProtection();
    super.dispose();
  }


  void deleteNotes(int noteId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note'),
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      if (!mounted) return;

      final provider = Provider.of<NotesProvider>(context, listen: false);
      await provider.deleteNotes(noteId);
      await provider.getNotes(context, widget.subjectId);
    }
  }

  void deleteBookMarks(int questionId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete BookMarks'),
        content: const Text('Are you sure you want to delete this BookMarks?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      if (!mounted) return;

      final bookMarkProvider =
          Provider.of<BookMarkProvider>(context, listen: false);
      final provider = Provider.of<NotesProvider>(context, listen: false);

      await bookMarkProvider.deleteBookMarking(context, questionId);

      if (!mounted) return;

      await provider.getNotes(context, widget.subjectId);
    }
  }

  Future<void> showAddQuestionDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final provider = Provider.of<NotesProvider>(context);
        final screenHeight = MediaQuery.of(context).size.height;

        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          insetPadding: const EdgeInsets.all(16),
          child: Container(
            height: screenHeight * 0.71,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Colors.white,
            ),
            child: SingleChildScrollView(
              // Wrap the content in SingleChildScrollView
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add New Question',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: questionController,
                    decoration: InputDecoration(
                      labelText: 'Question',
                      labelStyle:
                          GoogleFonts.poppins(fontWeight: FontWeight.w500),
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: answerController,
                    decoration: InputDecoration(
                      labelText: 'Answer',
                      alignLabelWithHint: true,
                      labelStyle:
                          GoogleFonts.poppins(fontWeight: FontWeight.w500),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    maxLines: 12,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          questionController.clear();
                          answerController.clear();
                          Navigator.pop(context);
                        },
                        child: Text('Cancel',
                            style: GoogleFonts.poppins(fontSize: 16)),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: provider.isLoading
                            ? null
                            : () async {
                                if (questionController.text != "" &&
                                    answerController.text != "") {
                                  final provider = Provider.of<NotesProvider>(
                                      context,
                                      listen: false);
                                  await provider.addNotesData(
                                      context,
                                      widget.subjectId,
                                      questionController.text,
                                      answerController.text);
                                  Navigator.pop(context);

                                  await provider.getNotes(
                                      context, widget.subjectId);

                                  questionController.clear();
                                  answerController.clear();
                                } else {
                                  questionController.clear();
                                  answerController.clear();
                                  ToastHelper.showError("Fill the Fields");
                                  Navigator.pop(context);
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        child: provider.isLoading
                            ? Center(child: CupertinoActivityIndicator())
                            : Text('Add',
                                style: GoogleFonts.poppins(
                                    fontSize: 16, color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> showEditQuestionDialog(BuildContext context, Notes note) async {
    questionController.text = note.title ?? '';
    answerController.text = note.description ?? '';

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final provider = Provider.of<NotesProvider>(context);
        final screenHeight = MediaQuery.of(context).size.height;

        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          insetPadding: const EdgeInsets.all(16),
          child: Container(
            height: screenHeight * 0.71,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Colors.white,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Edit Note',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: questionController,
                    decoration: InputDecoration(
                      labelText: 'Question',
                      labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: answerController,
                    decoration: InputDecoration(
                      labelText: 'Answer',
                      labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    maxLines: 12,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          questionController.clear();
                          answerController.clear();
                          Navigator.pop(context);
                        },
                        child: Text('Cancel', style: GoogleFonts.poppins(fontSize: 16)),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: provider.isLoading
                            ? null
                            : () async {
                          if (questionController.text.isNotEmpty &&
                              answerController.text.isNotEmpty) {
                            await provider.updateNotes(note.id!, questionController.text, answerController.text);
                            Navigator.pop(context);
                            await provider.getNotes(context, widget.subjectId);
                            questionController.clear();
                            answerController.clear();
                          } else {
                            ToastHelper.showError("Fill the Fields");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: provider.isLoading
                            ? const CupertinoActivityIndicator()
                            : Text('Update', style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NotesProvider>(context);
    final notes = provider.getNotesModel?.notes ?? [];
    final bookmarks = provider.getNotesModel?.bookmarks ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Notes',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.white)),
      ),
      body: provider.isLoading
          ? const Center(child: CupertinoActivityIndicator())
          : SafeArea(
              child: RefreshIndicator(
                onRefresh: () async {
                  await Provider.of<NotesProvider>(context, listen: false)
                      .getNotes(context, widget.subjectId);

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {}
                  });
                },
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Notes",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (notes.isEmpty)
                        Text(
                          "No notes available.",
                          style: GoogleFonts.poppins(
                              fontSize: 14, color: Colors.grey),
                        )
                      else
                        ...notes.map((note) => NoteCard(
                            note: note,
                            onLongPress: () {
                              deleteNotes(note.id!);
                            }, onEdit: () => showEditQuestionDialog(context, note),)),
                      const SizedBox(height: 24),
                      Text(
                        "Bookmarks",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (bookmarks.isEmpty)
                        Text(
                          "No bookmarks available.",
                          style: GoogleFonts.poppins(
                              fontSize: 14, color: Colors.grey),
                        )
                      else
                        ...bookmarks.map((bookmark) => BookmarkCard(
                            bookmark: bookmark,
                            onLongPress: () {
                              deleteBookMarks(bookmark.questionId!);
                            })),
                    ],
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurpleAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () => showAddQuestionDialog(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class NoteCard extends StatelessWidget {
  final Notes note;
  final VoidCallback onLongPress;
  final VoidCallback onEdit; // New edit callback

  const NoteCard({
    super.key,
    required this.note,
    required this.onLongPress,
    required this.onEdit, // Required edit callback
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        margin: const EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Stack(
            children: [
              // Main note content
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8), // To avoid overlap with edit button
                  Text(
                    note.title ?? 'No Title',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    note.description ?? '',
                    style: GoogleFonts.poppins(
                        fontSize: 14, color: Colors.grey[800]),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${note.testName ?? ''} • ${note.subjectName ?? ''}",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.deepPurple,
                        ),
                      ),
                      Text(
                        note.createdAt?.split(' ').first ?? '',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Edit icon at top right
              Positioned(
                top: 0,
                right: 0,
                child: InkWell(
                  onTap: onEdit,
                  borderRadius: BorderRadius.circular(20),
                  child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.edit,
                      size: 20,
                      color: Colors.grey,
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
}

class BookmarkCard extends StatelessWidget {
  final Bookmarks bookmark;
  final VoidCallback onLongPress;

  const BookmarkCard(
      {super.key, required this.bookmark, required this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.teal.shade50,
        elevation: 2,
        margin: const EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Html(data: bookmark.question ?? ''),
              const SizedBox(height: 6),
              Html(data: bookmark.detail ?? ''),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.bookmark, color: Colors.teal, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    bookmark.testName ?? '',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.teal.shade700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
