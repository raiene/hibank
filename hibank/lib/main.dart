import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:provider/provider.dart';
import 'theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'HIbank Demo',
        theme: hibankTheme,
        home: MyHomePage(),
      ),
    );
  }

}
class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];
  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    }
    else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

    var selectedIndex = 0;

    @override
    Widget build(BuildContext context) {
      Widget page;
      switch (selectedIndex) {
        case 0:
          page = GeneratorPage();
          break;
        case 1:
          page = FavoritesPage();
          break;
        default:
          throw UnimplementedError('no widget for $selectedIndex');
      }
      return LayoutBuilder(
        builder: (context, constraints) {
          return Scaffold(
            body: Row(
              children: [
                SafeArea(
                  child: NavigationRail(
                    extended: constraints.maxWidth >= 600,
                    destinations: [
                      NavigationRailDestination(icon: Icon(Icons.home), label: Text('Home')),
                      NavigationRailDestination(icon: Icon(Icons.favorite), label: Text('Favorites')),
                    ],
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (value) {
                      print('selected: $value');
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                )),
                Expanded(child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ))
              ],
            )
          );
        }
      );
    }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    }
    else {
      icon = Icons.favorite_border;
    }
    return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('View my bank, beach '),
        SizedBox(height: 15),
        BigCard(pair: pair),
        SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              onPressed: () { 
                appState.toggleFavorite();
              }, 
              icon: Icon(icon),
              label: Text('asmei')
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: () { 
                appState.getNext();
              }, 
              child: Text('otro')),
          ],
        )
      ],
    ),
  );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(context) {
    var faves = context.watch<MyAppState>().favorites;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(28.0),
          child: Text('Os mais asmados'),
        ),
        for (var fav in faves)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(fav.asLowerCase),
          ),
          // Text('${fav.first} ${fav.second}'),
      ],
      );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text('${pair.first} ${pair.second}', style: style),
      ),
    );
  }
}