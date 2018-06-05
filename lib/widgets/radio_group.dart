import 'package:flutter/material.dart';

class ExpansionRadioGroup extends StatelessWidget {

  final String name;
  List<ExpansionRadioItem> members;
  int selected;

  ExpansionRadioGroup({ this.name, this.members, this.selected });

  @override
  Widget build(BuildContext context) {
    return new ExpansionPanelList(
      
    ).builder(
      shrinkWrap: true,
      itemCount: members.length,
      itemBuilder: (BuildContext context, int idx) => members[idx].builder(context, selected == idx),
    );
  }

}

typedef Widget RadioBuilder(BuildContext context, bool isActive);

class ExpansionRadioItem extends StatefulWidget {

  final RadioBuilder builder;
  final VoidCallback onSelected;

  ExpansionRadioItem({ this.builder, this.onSelected });

  @override
  State<ExpansionRadioItem> createState() => new ExpansionRadioItemState();

}

class ExpansionRadioItemState extends State<ExpansionRadioItem> {
  
  @override
  Widget build(BuildContext context) {

  }

}
