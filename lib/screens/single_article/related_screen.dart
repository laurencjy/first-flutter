import 'package:flutter/material.dart';
import 'package:newheadline/models/models.dart';
import 'package:newheadline/provider/article.dart';
import 'package:newheadline/provider/theme.dart';
import 'package:newheadline/screens/single_article/webview_screen.dart';
import 'package:newheadline/shared/textstyle.dart';
import 'package:newheadline/utils/common.dart';
import 'package:newheadline/utils/response.dart';
import 'package:newheadline/utils/urls.dart';
import 'package:newheadline/widgets/bookmark_button.dart';
import 'package:newheadline/widgets/like_button.dart';
import 'package:newheadline/widgets/share_button.dart';
import 'package:newheadline/widgets/theme_button.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ScreenArguments {
  final int id;
  final String title;
  final String description;
  final String imageUrl;
  final String pubDate;
  final String source;
  final String category;
  final String link;

  ScreenArguments(
    this.id,
    this.title,
    this.description,
    this.imageUrl,
    this.pubDate,
    this.source,
    this.category,
    this.link,
  );
}

class RelatedScreen extends StatefulWidget {
  final ScreenArguments settings;
  RelatedScreen(this.settings);

  static final routeName = "related-screen";

  @override
  _RelatedScreenState createState() => _RelatedScreenState();
}

Future<void> saveReadingHistory(int articleId) async {
  String url = "$HISTORY_URL/?article=$articleId";
  var result = await APIService().post(url);
}

class _RelatedScreenState extends State<RelatedScreen> {
  List<Article> relatedArticles = [];

  @override
  void didChangeDependencies() {}

  @override
  Widget build(BuildContext context) {
    print(widget.settings.id);
    ThemeProvider tProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    ArticleProvider aProvider =
        Provider.of<ArticleProvider>(context, listen: false);
    String timeAgo = formatDate(widget.settings.pubDate);
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollEndNotification &&
            scrollNotification.metrics.pixels ==
                scrollNotification.metrics.maxScrollExtent &&
            aProvider.tab != "Setting") {
          saveReadingHistory(aProvider.articleId);
        }
      },
      child: Scaffold(
          appBar: AppBar(actions: [
            Container(
              child: Row(
                children: [
                  LikeBtn(widget.settings.id),
                  BookmarkBtn(widget.settings.id),
                  ShareBtn(link: widget.settings.link),
                  CustomizeThemeButton(),
                ],
              ),
            )
          ]),
          body: SingleChildScrollView(
            child: Container(
              child: Wrap(
                children: [
                  Container(
                      height: 300,
                      width: 500,
                      child: Align(
                        alignment: Alignment.center,
                        child: CachedNetworkImage(
                          imageUrl: widget.settings.imageUrl,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => SizedBox(
                            child: CircularProgressIndicator(
                                value: downloadProgress.progress),
                            height: 30,
                            width: 30,
                          ),
                          errorWidget: (context, ud, error) =>
                              Icon(Icons.error),
                        ),
                      )),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 5),
                    padding: EdgeInsets.all(5),
                    child: Column(
                      children: [
                        Text(
                          widget.settings.title,
                          style: CustomTextStyle.title1(
                              context, tProvider.fontSize),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.timelapse),
                                    Text(
                                      timeAgo,
                                      style: CustomTextStyle.small(
                                          context, tProvider.fontSize),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.source),
                                    Text(
                                      widget.settings.source,
                                      style: CustomTextStyle.small(
                                          context, tProvider.fontSize),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                )
                              ],
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            widget.settings.description,
                            style: CustomTextStyle.normal(
                                context, tProvider.fontSize),
                          ),
                        ),
                        Container(
                          child: OutlineButton(
                            padding: EdgeInsets.all(20),
                            child: Text("Visit Website",
                                style: CustomTextStyle.normal(
                                    context, tProvider.fontSize)),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => WebViewScreen(
                                          this.widget.settings.link)));
                            },
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
