import 'dart:io';
import 'package:education_app/resources/exports.dart';
import '../../model/upload_image_model.dart';
import '../../repository/upload_image_repo.dart';

class UploadImageProvider with ChangeNotifier {
  final _uploadImageRepo = UploadImageRepository();
  UploadImageModel? _uploadImageModel;

  UploadImageModel? get uploadImageModel => _uploadImageModel;

  Future<void> uploadingImage(BuildContext context, File image) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      if (authProvider.userSession == null) {
        debugPrint("User session is null. Cannot upload image.");
        return;
      }

      final userId = authProvider.userSession!.userId.toString();

      if (!image.existsSync()) {
        debugPrint("Image file does not exist.");
        return;
      }

      final response = await _uploadImageRepo.uploadImage(userId, image);

      if (response.message != null) {
        _uploadImageModel = response;
        notifyListeners();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Image uploaded successfully!"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      debugPrint("Error uploading image: $e");

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Image upload failed. Please try again."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
