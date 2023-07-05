import 'package:flutter/material.dart';
import 'package:inshorts_flutter/inshorts_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InShorts News',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _controller;

  List<NewsType> categories = [
    NewsType.allNews,
    NewsType.trending,
    NewsType.topStories,
    NewsType.business,
  ];

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: categories.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('InShorts News'),
        bottom: TabBar(
          controller: _controller,
          tabs: categories
              .map((e) => Tab(text: InShorts.getNewsTitle(e)))
              .toList(),
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: categories.map((e) {
          return FutureBuilder<Data>(
            future: InShorts.getNews(newsType: e, language: Language.en),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.newsList!.length,
                  itemBuilder: (context, index) {
                    News news = snapshot.data!.newsList![index];
                    return ListTile(
                      leading: news.newsObj?.imageUrl != null
                          ? Image.network(
                              //news.imageUrl!,
                              news.newsObj!.imageUrl!,
                              width: 80,
                              fit: BoxFit.fitWidth,
                            )
                          : Container(), // Placeholder widget when imageUrl is null
                      title: Text(news.newsObj!.title ?? ''),
                      subtitle: Text(
                        news.newsObj?.sourceName ?? '',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return const Center(child: Text('Error'));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          );
        }).toList(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
