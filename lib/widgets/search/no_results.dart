import 'package:flutter/material.dart';

class NoResults extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(35),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/no_results.png',
            width: 160,
            height: 160,
          ),
          SizedBox(
            height: 25,
          ),
          Text(
            'Ups...',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Text(
            'No se encontaron resultados para tu búsqueda, ¡inténtalo de nuevo!',
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 18,
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 3,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
