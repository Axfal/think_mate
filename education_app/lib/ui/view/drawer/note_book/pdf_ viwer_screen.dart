import 'package:education_app/resources/exports.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:http/http.dart' as http;

class PDFViewerScreen extends StatefulWidget {
  final String title;
  final String url;

  const PDFViewerScreen({super.key, required this.title, required this.url});

  @override
  State<PDFViewerScreen> createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  final PdfViewerController _controller = PdfViewerController();
  final TextEditingController _pageController = TextEditingController();
  int _currentPage = 0;
  int _totalPages = 0;
  bool _isDownloading = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _jumpToPage() {
    final page = int.tryParse(_pageController.text);
    if (page != null) {
      _controller.jumpToPage(page);
    }
  }

  void _zoomIn() {
    setState(() {
      _controller.zoomLevel += 0.25;
    });
  }

  void _zoomOut() {
    if (_controller.zoomLevel > 1.0) {
      setState(() {
        _controller.zoomLevel -= 0.25;
      });
    }
  }

  // void _bookmark() {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text('Bookmark feature coming soon!')),
  //   );
  // }

  // Future<void> _downloadPDF() async {
  //   setState(() => _isDownloading = true);
  //   try {
  //     final response = await http.get(Uri.parse(widget.url));
  //     if (response.statusCode == 200) {
  //       final dir = await getApplicationDocumentsDirectory();
  //       final file = File('${dir.path}/${widget.title}.pdf');
  //       await file.writeAsBytes(response.bodyBytes);
  //       ToastHelper.showSuccess('Downloaded to ${file.path}');
  //     } else {
  //       throw Exception('Failed to download PDF');
  //     }
  //   } catch (e) {
  //     ToastHelper.showError('Download failed: $e');
  //   } finally {
  //     setState(() => _isDownloading = false);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios, color: AppColors.whiteColor),
        ),
        // actions: [
        //   IconButton(
        //     onPressed: _bookmark,
        //     icon: Icon(Icons.bookmark_border, color: Colors.white),
        //     tooltip: 'Bookmark',
        //   ),
        // ],
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
      body: SafeArea(
        child: Stack(
          children: [
            SfPdfViewer.network(
              widget.url,
              controller: _controller,
              onDocumentLoaded: (details) {
                setState(() {
                  _totalPages = details.document.pages.count;
                });
              },
              onPageChanged: (details) {
                setState(() {
                  _currentPage = details.newPageNumber;
                });
              },
            ),
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade100.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$_currentPage / $_totalPages',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple[900],
                  ),
                ),
              ),
            ),
            Positioned(
              right: 16,
              bottom: 120,
              child: Column(
                children: [
                  FloatingActionButton(
                    heroTag: "zoomIn",
                    onPressed: _zoomIn,
                    mini: true,
                    backgroundColor: Colors.deepPurple,
                    child: Icon(Icons.zoom_in),
                  ),
                  SizedBox(height: 8),
                  FloatingActionButton(
                    heroTag: "zoomOut",
                    onPressed: _zoomOut,
                    mini: true,
                    backgroundColor: Colors.deepPurple,
                    child: Icon(Icons.zoom_out),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   // onPressed: _isDownloading ? null : _downloadPDF,
      //   icon: _isDownloading
      //       ? CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
      //       : Icon(Icons.download),
      //   label: Text(_isDownloading ? 'Downloading...' : 'Download'),
      //   backgroundColor: Colors.deepPurple,
      // ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _pageController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Go to page',
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              ElevatedButton(
                onPressed: _jumpToPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Go'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
