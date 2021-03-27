import 'package:flutter/material.dart';
import 'package:newheadline/models/models.dart';
import 'package:newheadline/utils/response.dart';
import 'package:newheadline/utils/urls.dart';

class SearchProvider with ChangeNotifier {
  List<Article> _items = [];
  int _initialPage = 1;
  String _shareLink = "";

  List<Article> get searchItems {
    return [..._items];
  }

  int get initialPage {
    return _initialPage;
  }

  String get shareLink {
    return _shareLink;
  }

  void setShareLink(String link) {
    _shareLink = link;
    notifyListeners();
  }

  void addToSelectedList(List<Map<String, dynamic>> data, List<Article> list) {
    for (Map<String, dynamic> d in data) {
      list.add(
        Article.fromJson(d),
      );
    }
  }

  int getPos(int id, List<Article> list) {
    return list.indexWhere((a) => a.articleId == id);
  }

  void setPageViewArticle(int id) {
    int ind = getPos(id, _items);
    _initialPage = ind;
  }

  void getPageViewArticle(int id) {
    int ind = getPos(id, _items);

    _initialPage = ind;
  }

  void emptyItems() {
    _items.clear();
  }

  Future<void> fetchSearchResults(String searchResult) async {
    List<Map<String, dynamic>> data =
        await APIService().get("$SEARCH_RESULT_URL/?q=$searchResult");

    addToSelectedList(data, _items);

    notifyListeners();
  }
}
