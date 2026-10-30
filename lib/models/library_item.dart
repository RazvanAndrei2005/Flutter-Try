import 'user.dart';
abstract class LibraryItem {
  final String title;
  String? author;
  DateTime? publishDate;
  User? borrower;
  DateTime? dueDate;
  LibraryItem({required this.title,this.author,this.publishDate,this.borrower,this.dueDate});


}