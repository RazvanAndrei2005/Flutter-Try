import 'package:flutter_application_2/models/library_item.dart';

class Magazine extends LibraryItem{
  int? issueNumber;
  String? publisher;
  Magazine({required super.title,super.author,super.borrower,super.publishDate,super.dueDate,this.publisher,this.issueNumber});
}