import 'package:flutter/material.dart';
import 'package:uni_map/screens/search_results.dart';

class SearchHistoryCard extends StatelessWidget {
  const SearchHistoryCard({
    super.key,
    required this.displayText,
    required this.deleteSearch,
    required this.searchId,
  });

  final String displayText;
  final Function deleteSearch;
  final String searchId;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Dismissible(
      key: Key(searchId),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        deleteSearch(searchId);
      },
      background: Container(
        padding: EdgeInsets.only(right: 16),
        color: Colors.red.shade600,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(
              Icons.delete_forever,
              color: Colors.white,
              size: 28,
            ),
          ],
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 24),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: screenWidth * 0.5,
              child: Text(
                style: TextStyle(fontSize: 17),
                displayText,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SearchResults(query: displayText.toUpperCase())),
                );
              },
              iconSize: 28,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
