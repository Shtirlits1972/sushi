import 'package:flutter/material.dart';

class ItemWidget extends StatelessWidget {
  const ItemWidget({super.key, required this.title, required this.content});

  final String? title;
  final String? content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Expanded(
              child: Text(title ?? '', style: TextStyle(fontSize: 20)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Expanded(
              child: Text(content ?? '', style: TextStyle(fontSize: 20)),
            ),
          ),
        ],
      ),
    );
  }
}
