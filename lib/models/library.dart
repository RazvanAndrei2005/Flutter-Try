import 'package:flutter_application_2/models/library_item.dart';
import 'user.dart';
class Library {
  List<LibraryItem>items=[];
  void addItem(LibraryItem item){
    items.add(item);
  }
  searchByTitle (String? query){
    if (query ==null || query.isEmpty){
      return [];
    }
    List<LibraryItem> foundItemsByTitle=[];
    for (var i=0;i<items.length;i++){
      if (items[i].title.toLowerCase().contains(query.toLowerCase()))
      {  foundItemsByTitle.add(items[i]); }
      
    }
    return foundItemsByTitle;
  }
  getItemsByAuthor(String? author){
    if (author==null || author.isEmpty){
      return [];
    }
    List<LibraryItem> foundItemsByAuthor=[];
    for(var i=0;i<items.length;i++){
      final itemAuthor = items[i].author;
    if (itemAuthor != null && itemAuthor.toLowerCase().contains(author.toLowerCase())) {
      foundItemsByAuthor.add(items[i]);
    }
  }
    return foundItemsByAuthor;
  }
  getRecentItems(){
    List<LibraryItem> recentItems = List.from(items);
   recentItems.sort((a, b) {
    if (a.publishDate == null) return 1;  // 'a' nu are dată, trece mai la spate
    if (b.publishDate == null) return -1; // 'b' nu are dată, 'a' rămâne în față
    return b.publishDate!.compareTo(a.publishDate!); // Sortare descrescătoare
  });

  return recentItems;
  }
  void borrowItem(LibraryItem item, User user, DateTime dueDate) {
  if (item.borrower != null) {
    return; 
  }
  item.borrower = user;
  item.dueDate = dueDate;
}
void returnItem(LibraryItem item) {
  item.borrower = null;
  item.dueDate = null;
}




}