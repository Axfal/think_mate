// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:education_app/resources/exports.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import '../model/upload_image_model.dart';

class UploadImageRepository {
  Future<UploadImageModel> uploadImage(String userId, File image) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(AppUrl.uploadImage),
      );

      request.fields['user_id'] = userId;
      request.files.add(await http.MultipartFile.fromPath(
        'profile_image',
        image.path,
        filename: basename(image.path),
      ));

      print("Uploading Image...");
      print("User ID: $userId");
      print("File Path: ${image.path}");

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: $responseBody");

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(responseBody);
        return UploadImageModel.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to upload image');
      }
    } catch (e) {
      print("Error: $e");
      throw Exception("Image upload failed: $e");
    }
  }
}
