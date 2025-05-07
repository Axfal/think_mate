import 'dart:io';
import 'package:education_app/resources/exports.dart';
import 'package:image_picker/image_picker.dart';
import '../../model/upload_image_model.dart';
import '../../repository/upload_image_repo.dart';
import 'package:education_app/utils/toast_helper.dart';

class UploadImageProvider with ChangeNotifier {
  final _uploadImageRepo = UploadImageRepository();
  UploadImageModel? _uploadImageModel;
  File? _selectedImage;

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
        ToastHelper.showSuccess("Image uploaded successfully!");
      }
    } catch (e) {
      debugPrint("Error uploading image: $e");

      // Show error message
      ToastHelper.showError("Image upload failed. Please try again.");
    }
  }

  Future<void> pickImage(BuildContext context) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemp = File(image.path);
      _selectedImage = imageTemp;
      _uploadImageModel = null;
      notifyListeners();
    } catch (e) {
      ToastHelper.showError('Failed to pick image: $e');
    }
  }

  Future<void> uploadImage(BuildContext context) async {
    if (_selectedImage == null) {
      ToastHelper.showError('Please select an image first');
      return;
    }
    await uploadingImage(context, _selectedImage!);
  }
}
