import 'package:flutter/material.dart';
import 'package:uni_map/services/search_history_service.dart';
import 'package:uni_map/widgets/search_history/search_history_card.dart';
import 'package:uni_map/widgets/search_history/search_history_skeleton.dart';

class SearchHistory extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SearchHistoryState();
  }
}

class _SearchHistoryState extends State<SearchHistory> {
  final SearchHistoryService _searchHistoryService = SearchHistoryService();

  Future<void> _deleteSearchItem(String searchId) async {
    await _searchHistoryService.deleteSearchHistoryEntry(searchId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Row(
          children: [
            SizedBox(
              width: 57,
            ),
            Image(
              image: AssetImage('assets/images/logo.png'),
              height: 33,
              width: 33,
              color: Colors.white,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              'UniMap',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 16,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _searchHistoryService.getSearchHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView.builder(
              itemCount: 8, 
              itemBuilder: (context, index) => SearchHistorySkeleton(),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No has hecho ninguna búsqueda.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var searchItem = snapshot.data![index];
                String searchId = searchItem['id'];
                
                return SearchHistoryCard(
                  displayText: searchItem['query'],
                  searchId: searchId,
                  deleteSearch: _deleteSearchItem,
                );
              },
            );
          }
        },
      ),
    );
  }
}
