import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CompanentHelper extends StatelessWidget {
  String titleName, value;
  CompanentHelper({
    super.key,
    required this.titleName,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.blue.shade100, // Renk burada ayarlanıyor
        borderRadius: BorderRadius.circular(20), // Köşe yuvarlama burada belirleniyor
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            titleName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
