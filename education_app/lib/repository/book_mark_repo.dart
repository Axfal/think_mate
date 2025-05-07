import 'package:education_app/resources/exports.dart';

class BookMarkRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<BookMarkModel> bookMarking(Map<String, dynamic> data) async {
    try {
      final response =
          await _apiServices.getPostApiResponse(AppUrl.bookMark, data);

      return BookMarkModel.fromJson(response);
    } catch (error) {
      debugPrint('Error bookmarking question: $error');
      throw Exception('Failed to bookmarking question');
    }
  }

  Future<GetBookMarkModel> getBookMarking() async {
    try {
      final response = await _apiServices.getGetApiResponse(AppUrl.getBookMark);

      return GetBookMarkModel.fromJson(response);
    } catch (error) {
      debugPrint('Error fetching bookmarked questions: $error');
      throw Exception('Failed to load bookmarked questions');
    }
  }

  Future<DeleteBookMarkModel> deleteBookMarking(Map<String, dynamic> data) async {
    try {
      final response =
          await _apiServices.getPostApiResponse(AppUrl.deleteBookMark, data);

      return DeleteBookMarkModel.fromJson(response);
    } catch (error) {
      debugPrint('Error deleting bookmark question: $error');
      throw Exception('Failed to deleting bookmark question');
    }
  }
}
