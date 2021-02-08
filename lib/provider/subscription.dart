import 'package:flutter/material.dart';
import 'package:newheadline/models/models.dart';
import 'package:newheadline/utils/response.dart';
import 'package:newheadline/utils/urls.dart';

class SubscriptionProvider with ChangeNotifier {
  List<Subscription> _items = [];
  Map<String, bool> _checkBoxes = {};

  List<Subscription> get items {
    return [..._items];
  }

  Map<String, bool> get checkboxes {
    return {..._checkBoxes};
  }

  Subscription findById(int id) {
    return _items.firstWhere((cat) => cat.categoryId == id);
  }

  Future<void> fetchSubscriptions([String token]) async {
    const url = SUBSCRIPTION_URL;
    final subscriptions = await APIService().get(url);

    List<Subscription> items = [];
    Map<String, bool> checkBoxes = {};

    for (var s in subscriptions) {
      items.add(
        Subscription.fromJson(s),
      );

      if (s["checked"])
        checkBoxes[s['category_id'].toString()] = true;
      else
        checkBoxes[s['category_id'].toString()] = false;
    }

    _items = items;
    _checkBoxes = checkBoxes;
  }
}
