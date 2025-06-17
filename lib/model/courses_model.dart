// import 'package:education_app/resources/exports.dart';

class CoursesModel {
  final String title;
  final String description;
  final String image;

  CoursesModel(
      {required this.image, required this.title, required this.description});
}

List<CoursesModel> courses = <CoursesModel>[
  CoursesModel(
      image: 'assets/images/mdcat.png',
      title: 'title',
      description: 'description')
];
