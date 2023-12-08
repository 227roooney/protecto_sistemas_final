import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uni_map/widgets/search/no_results.dart';
import 'dart:convert' as convert;

import 'package:uni_map/widgets/search/search_result.dart';
import 'package:uni_map/widgets/search/search_skeleton.dart';

class SearchResults extends StatefulWidget {
  SearchResults({super.key, required this.query});

  final String query;

  @override
  State<StatefulWidget> createState() {
    return _SearchResultsState();
  }
}

class _SearchResultsState extends State<SearchResults> {
  var areasResults = [];
  var buildingsResults = [];
  var combinedResults = [];
  bool isQueryComplete = false;

  Future<void> fetchSearchResults() async {
    setState(() {
      isQueryComplete = false;
    });

    try {
      final response = await http.get(Uri.parse(
          'https://us-central1-uni-map-fe7c6.cloudfunctions.net/app/search?q=${widget.query}'));

      if (response.statusCode == 200) {
        final data = convert.jsonDecode(response.body);
        areasResults = data['areas'];
        buildingsResults = data['buildings'];

        setState(() {
          combinedResults = [
            ...areasResults.map((e) => {'type': 'area', 'data': e}),
            ...buildingsResults.map((e) => {'type': 'building', 'data': e})
          ];
          isQueryComplete = true;
        });
      } else {
        setState(() {
          isQueryComplete = true;
        });
        throw Exception('Failed to load search results.');
      }
    } catch (e) {
      setState(() {
        isQueryComplete = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchSearchResults();
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
      body: Center(
        child: !isQueryComplete
            ? ListView.builder(
                itemCount: 8,
                itemBuilder: (context, index) => SearchSkeleton(),
              )
            : (combinedResults.isEmpty)
                ? NoResults()
                : Container(
                    margin: EdgeInsets.all(6),
                    child: Expanded(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 6),
                            child: Text(
                              "Mostrando resultados para ${widget.query}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: 16, fontStyle: FontStyle.italic),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: combinedResults.length,
                              itemBuilder: (context, index) {
                                var item = combinedResults[index];
                                if (item['type'] == 'building') {
                                  var buildingData = item['data'];
                                  if (buildingData['commonAreas'] != null &&
                                      buildingData['commonAreas'].isNotEmpty) {
                                    return SearchResult(
                                      title: buildingData['commonAreas'][0]
                                          ['name'],
                                      subtitle:
                                          "${buildingData['name']} - ${buildingData['commonAreas'][0]['level']}",
                                      isBuilding: true,
                                      Id: buildingData['id'],
                                    );
                                  } else if (buildingData['rooms'] != null &&
                                      buildingData['rooms'].isNotEmpty) {
                                    return SearchResult(
                                      title:
                                          "${buildingData['rooms'][0]['id']} - ${buildingData['rooms'][0]['name']}",
                                      subtitle:
                                          "${buildingData['name']} - ${buildingData['rooms'][0]['level']}",
                                      isBuilding: true,
                                      Id: buildingData['id'],
                                    );
                                  } else {
                                    return SearchResult(
                                      title: buildingData['name'],
                                      subtitle: buildingData['description'],
                                      isBuilding: true,
                                      Id: buildingData['id'],
                                    );
                                  }
                                } else if (item['type'] == 'area') {
                                  var areaData = item['data'];
                                  return SearchResult(
                                    title: areaData['name'],
                                    subtitle: areaData['type'],
                                    isBuilding: false,
                                    Id: areaData['id'],
                                  );
                                }
                                return SizedBox.shrink();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}
