import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List searchList = [];
  List searchQueryBuilder(query, list) {
    return list
        .where((item) => item.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Widget overlaySearchListItemBuilder(item) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Text(
        item,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }

  void onItemSelected(item) {
    setState(() {
      print('$item');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recherche')),
      body: Column(
        children: [
          GFSearchBar(
              searchList: searchList,
              overlaySearchListItemBuilder: overlaySearchListItemBuilder,
              searchQueryBuilder: searchQueryBuilder),
          const Expanded(child: Text('Résultats')),
        ],
      ),
    );
  }
}
