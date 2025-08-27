import 'package:education_app/resources/exports.dart';
import 'package:flutter/cupertino.dart';

class FolderScreen extends StatefulWidget {
  const FolderScreen({super.key});

  @override
  State<FolderScreen> createState() => _FolderScreenState();
}

class _FolderScreenState extends State<FolderScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<NoteBookProvider>(context, listen: false).getFolders());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          "Select Folder",
          style: AppTextStyle.heading3.copyWith(
            color: AppColors.whiteColor,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.whiteColor),
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
      body: Consumer<NoteBookProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CupertinoActivityIndicator(color: Colors.black54),
            );
          }

          final folders = provider.folderModel?.folders ?? [];

          if (folders.isEmpty) {
            return Center(
              child: Text(
                "No folders found",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.greyText,
                ),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              itemCount: folders.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.95,
              ),
              itemBuilder: (context, index) {
                final folder = folders[index];
                return GestureDetector(
                  onTap: () {
                    final int folderId = folder.id ?? 0;
                    Navigator.pushNamed(
                      context,
                      RoutesName.myNoteBookScreen,
                      arguments: {"folder_id": folderId},
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [
                          AppColors.deepPurple,
                          AppColors.lightPurple.withValues(alpha: 0.85),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.folder_rounded,
                            size: 48, color: AppColors.whiteColor),
                        const SizedBox(height: 12),
                        Text(
                          folder.folderName ?? "Unnamed",
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.whiteColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
