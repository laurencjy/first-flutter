import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:newheadline/models/models.dart';
import 'package:newheadline/provider/article.dart';
import 'package:newheadline/screens/pages/article_screen.dart';
import 'package:newheadline/utils/models.dart';
import 'package:provider/provider.dart';

class ArticlesScreen extends StatelessWidget {
  static final routeName = "/articles";

  @override
  Widget build(BuildContext context) {
    return Consumer<ArticleProvider>(builder: (context, article, child) {
      return ListView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: article.filteredItems.length,
        itemBuilder: (ctx, i) => OneArticleGrid(
          article.filteredItems[i].id,
          article.filteredItems[i].title,
          article.filteredItems[i].imageUrl,
          article.filteredItems[i].summary,
          article.filteredItems[i].link,
          article.filteredItems[i].description,
          article.filteredItems[i].pubDate,
          article.filteredItems[i].source,
          article.filteredItems[i].category,
        ),
      );
    });
  }
}

class OneArticleGrid extends StatefulWidget {
  final int id;
  final String title;
  final String imageUrl;
  final String summary;
  final String link;
  final String description;
  final String pubDate;
  final String source;
  final String category;

  OneArticleGrid(this.id, this.title, this.imageUrl, this.summary, this.link,
      this.description, this.pubDate, this.source, this.category);

  @override
  _OneArticleGridState createState() => _OneArticleGridState();
}

class _OneArticleGridState extends State<OneArticleGrid> {
  bool showFullSummary = false;

  String truncateWithEllipsis(int cutoff, String myString) {
    return (myString.length <= cutoff)
        ? myString
        : '${myString.substring(0, cutoff)}...';
  }

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    TextStyle defaultStyle = TextStyle(color: Colors.grey, fontSize: 15.0);
    TextStyle linkStyle = TextStyle(color: Colors.blue);

    return Container(
      // height: _screenSize.height * 0.4,
      child: Card(
          child: Wrap(
        children: [
          InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                ArticleScreen.routeName,
                arguments: ScreenArguments(
                  widget.id,
                  widget.title,
                  widget.description,
                  widget.imageUrl,
                  widget.pubDate,
                  widget.source,
                  widget.category,
                ),
              );
              // print(widget.link);
            },
            child: Column(
              children: [
                Image.network(
                  'https://via.placeholder.com/800x300',
                ),
                Column(
                  children: [
                    ListTile(
                      title: Text(widget.title),
                    ),
                  ],
                )
              ],
            ),
          ),
          Row(
            children: [
              Flexible(
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: RichText(
                    text: TextSpan(
                      style: defaultStyle,
                      children: <TextSpan>[
                        TextSpan(
                          text: !showFullSummary
                              ? truncateWithEllipsis(200, widget.summary)
                              : truncateWithEllipsis(1000, widget.summary),
                        ),
                        TextSpan(
                            text: !showFullSummary ? 'Show More' : 'Show Less',
                            style: linkStyle,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                setState(() {
                                  showFullSummary = !showFullSummary;
                                });
                              }),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      )),
    );
  }
}