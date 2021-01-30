import 'package:flutter/material.dart';
import 'package:newheadline/models/models.dart';
import 'package:newheadline/provider/article.dart';
import 'package:newheadline/provider/category.dart';
import 'package:newheadline/screens/pages/article_screen.dart';
import 'package:newheadline/shared/app_drawer.dart';
import 'package:newheadline/utils/auth.dart';
import 'package:newheadline/widgets/category_item.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatefulWidget {
  static const routeName = '/category';

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with SingleTickerProviderStateMixin {
  var _isInit = true;
  var _isLoading = false;
  List<Category> categories = [];
  List<Article> articles = [];
  // List<Article> categorizedArticle = [];
  TabController _tabController;
  List<String> categoryNames = [];

  @override
  void initState() {
    super.initState();
    if (categories.length != 0)
      _tabController = TabController(vsync: this, length: categories.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      CategoryProvider cProvider = Provider.of<CategoryProvider>(context);
      ArticleProvider aProvider = Provider.of<ArticleProvider>(context);
      aProvider.fetchArticles().then((_) {
        setState(() {
          articles = aProvider.items;
        });
      });

      cProvider.fetchCategories().then((_) {
        setState(() {
          _isLoading = false;
          categories = cProvider.items;
          categoryNames = cProvider.categoryNames;
        });
      });
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  void filterCategory(String categoryName) {
    ArticleProvider aProvider =
        Provider.of<ArticleProvider>(context, listen: false);
    aProvider.filterByCategory(categoryName);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          centerTitle: true,
          bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: Colors.black,
              onTap: (int index) {
                filterCategory(categoryNames[index]);
                // print(categoryNames[index]);
                // return Consumer<ArticleProvider>(
                //   builder: (context, article, _) {
                //     print(categoryNames[index]);
                //     article.filterByCategory(categoryNames[index]);
                //     return;
                //   },
                // );
              },
              tabs: categories
                  .map((Category c) => Tab(
                      text:
                          ('${c.categoryName[0].toUpperCase()}${c.categoryName.substring(1)}')))
                  .toList()),
          title: Text('All news'),
        ),
        body: TabBarView(
            controller: _tabController,
            children: categories
                .map((Category c) => Tab(child: ArticleScreen()))
                .toList()),
      ),
    );
  }
}
// return Scaffold(

// appBar: AppBar(
//   title: Text("Select a category"),
// ),
// body: _isLoading
//     ? Center(
//         child: CircularProgressIndicator(),
//       )
//     : CategoryGrid(),
// drawer: AppDrawer()
// );
//   }
// }

class CategoryGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final categoriesData = Provider.of<CategoryProvider>(context);
    final categories = categoriesData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: categories.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          key: Key("item$i"), value: categories[i], child: CategoryItem()),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
    );
  }
}