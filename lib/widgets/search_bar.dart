import 'package:flutter/material.dart';
import 'package:newheadline/provider/auth.dart';
import 'package:newheadline/provider/search.dart';
import 'package:newheadline/shared/constants.dart';
import 'package:provider/provider.dart';

class SearchBar extends StatefulWidget {
  Function searchInput;

  SearchBar({this.searchInput});
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SearchProvider sProvider =
        Provider.of<SearchProvider>(context, listen: true);
    Auth auProvider = Provider.of<Auth>(context, listen: false);
    return Container(
      child: Form(
        key: _formKey,
        child: TextFormField(
          textInputAction: TextInputAction.search,
          decoration: searchInputDecoration.copyWith(
            hintText: 'Enter Your Search',
          ),
          onChanged: (val) {
            // widget.searchInput(val);
          },
          onFieldSubmitted: (val) async {
            sProvider.emptyItems();
            await sProvider.fetchSearchResults(val, auProvider.token);
            // widget.searchSubmit(val);
          },
        ),
      ),
    );
  }
}
