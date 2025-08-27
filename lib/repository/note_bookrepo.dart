// ignore_for_file: avoid_print

import 'package:education_app/resources/exports.dart';

class NoteBookRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<Map<String, dynamic>?> getNoteBooks(int userId, int folderId) async {
    try {
      final response =
          await _apiServices.getGetApiResponse("${AppUrl.getNoteBook}$userId&folder_id=$folderId");
      return response;
    } catch (error) {
      debugPrint('Error while fetching note books: $error');
      throw Exception('Failed to load note books');
    }
  }

  Future<dynamic> getFolders() async {
    try{
      final response = await _apiServices.getGetApiResponse(AppUrl.getFolders);
      return response;
    }catch(e){
      print('error: $e');
    }
  }
}
