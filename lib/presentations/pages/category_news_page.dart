import 'package:acf_news/data/api/api_service.dart';
import 'package:acf_news/data/model/article_model.dart';
import 'package:acf_news/presentations/widgets/card_category_news.dart';
import 'package:acf_news/presentations/widgets/category_card.dart';
import 'package:acf_news/utils/styles.dart';
import 'package:flutter/material.dart';

class CategoryNews extends StatefulWidget {
  const CategoryNews({
    Key? key,
    required this.tabs,
  }) : super(key: key);

  final List<String> tabs;

  @override
  State<CategoryNews> createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {
  late Future<ArticlesResult> _article;

  @override
  void initState() {
    super.initState();
    _article = ApiServices().topHeadlines();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          isScrollable: true,
          labelColor: kColorMaroon,
          unselectedLabelColor: Colors.black26,
          indicatorColor: kColorMaroon,
          tabs: widget.tabs
              .map((tab) => Tab(
                    icon: Text(
                      tab,
                      style: textTheme.headline6
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ))
              .toList(),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height,
          child: TabBarView(
            children: widget.tabs
                .map(
                  (tab) => FutureBuilder(
                    future: _article,
                    builder: (context, AsyncSnapshot<ArticlesResult> snapshot) {
                      var state = snapshot.connectionState;
                      if (state != ConnectionState.done) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        );
                      } else {
                        if (snapshot.hasData) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.55,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data?.articles.length,
                                itemBuilder: (context, index) {
                                  var article = snapshot.data?.articles[index];
                                  return CategoryNewsCard(
                                    article: article!,
                                  );
                                },
                              ),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Material(
                              child: Text(
                                snapshot.error.toString(),
                              ),
                            ),
                          );
                        } else {
                          return const Material(
                            child: Text(''),
                          );
                        }
                      }
                    },
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
