import 'package:flutter/material.dart';

enum WrappingListDirection { HORIZONTAL, VERTICAL }

class WrappingList extends StatefulWidget {
  
  final WrappingListDirection direction;
  final List<Widget> items;

  WrappingList({ this.direction, this.items });

  @override
  State<WrappingList> createState() => WrappingListState();

}

class WrappingListState extends State<WrappingList> {

  @override
  Widget build(BuildContext context) {
  
  }

}

