import 'package:flutter_application_2/models/library_item.dart';

class Book extends LibraryItem{
  int? pagecount;
  String? isbn;

  Book({required super.title,super.author,super.borrower,super.publishDate,super.dueDate,this.pagecount,this.isbn});
}