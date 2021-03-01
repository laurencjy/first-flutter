import 'package:flutter/material.dart';
import 'package:newheadline/models/models.dart';
import 'package:newheadline/provider/article.dart';
import 'package:newheadline/provider/category.dart';
import 'package:newheadline/provider/theme.dart';
import 'package:newheadline/screens/pages/articles_screen.dart';
import 'package:newheadline/shared/textstyle.dart';
import 'package:provider/provider.dart';

class ArticlesTab extends StatefulWidget {
  static const routeName = '/category';

  @override
  _ArticlesTabState createState() => _ArticlesTabState();
}

class _ArticlesTabState extends State<ArticlesTab>
    with SingleTickerProviderStateMixin {
  var _isInit = true;
  var _isLoading = false;
  List<Category> categories = [];
  List<Article> articles = [];
  TabController _tabController;
  List<String> categoryNames = [];
  Map<String, int> _categoriesPage = {};

  @override
  void initState() {
    super.initState();
    if (categories.length != 0)
      _tabController = TabController(vsync: this, length: categories.length);
  }

  @override
  void dispose() {
    if (_tabController != null) _tabController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      CategoryProvider cProvider =
          Provider.of<CategoryProvider>(context, listen: false);

      cProvider.fetchCategories().then((_) {
        setState(() {
          _isLoading = false;
          categories = cProvider.items;
          categoryNames = cProvider.categoryNames;
        });
        _setPages(cProvider.categoryNames);
      });
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  void _setPages(List<String> categoryNames) {
    categoryNames.forEach((String name) => _categoriesPage[name] = 1);
    ArticleProvider aProvider =
        Provider.of<ArticleProvider>(context, listen: false);
    aProvider.setCategoriesPage(_categoriesPage);
  }

  @override
  Widget build(BuildContext context) {
    ArticleProvider aProvider =
        Provider.of<ArticleProvider>(context, listen: false);
    ThemeProvider tProvider = Provider.of<ThemeProvider>(context, listen: true);
    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          bottom: !_isLoading
              ? TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  onTap: (int index) {
                    aProvider.filterByCategory(
                      categoryNames[index],
                    );
                  },
                  tabs: categories
                      .map(
                        (Category c) => Tab(
                            child: Text(
                          '${c.categoryName[0].toUpperCase()}${c.categoryName.substring(1)}',
                          style: CustomTextStyle.normalBold(
                              context, tProvider.fontSize),
                        )),
                      )
                      .toList(),
                )
              : null,
          title: Text('All news'),
        ),
        body: !_isLoading
            ? TabBarView(
                controller: _tabController,
                children: categories
                    .map(
                      (Category c) => Tab(
                        child: ArticlesScreen(),
                      ),
                    )
                    .toList(),
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}