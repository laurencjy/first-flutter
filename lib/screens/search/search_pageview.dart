import 'package:flutter/material.dart';
import 'package:newheadline/models/models.dart';
import 'package:newheadline/provider/search.dart';
import 'package:newheadline/screens/single_article/article_screen.dart';
import 'package:newheadline/widgets/share_button.dart';
import 'package:newheadline/widgets/theme_button.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SearchPageViewScreen extends StatefulWidget {
  static final routeName = '/Search-pageview';
  @override
  _SearchPageViewScreenState createState() => _SearchPageViewScreenState();
}

class _SearchPageViewScreenState extends State<SearchPageViewScreen> {
  List<Article> articles = [];
  PageController _controller;

  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    SearchProvider sProvider =
        Provider.of<SearchProvider>(context, listen: false);

    articles = sProvider.searchItems;

    _controller = PageController(
      initialPage: sProvider.initialPage,
    );
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
              width: 50,
              height: 50,
              child: PageView(
                controller: _controller,
                children: [
                  ...articles.map((Article a) => ShareBtn(link: a.link)),
                ],
              )),
          CustomizeThemeButton(),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 20),
            child: SmoothPageIndicator(
              controller: _controller,
              count: articles.length,
              effect: ScrollingDotsEffect(
                dotWidth: 5.0,
                dotHeight: 5.0,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: PageView(
              controller: _controller,
              children: <Widget>[
                ...articles
                    .map((Article a) => ArticleScreen(
                          id: a.articleId,
                          title: a.title,
                          description: a.description,
                          imageUrl: a.imageUrl,
                          pubDate: a.pubDate,
                          source: a.source,
                          category: a.category,
                        ))
                    .toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
