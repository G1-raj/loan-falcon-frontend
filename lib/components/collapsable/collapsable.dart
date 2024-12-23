import 'package:flutter/material.dart';

class CollapsibleForm extends StatefulWidget {
  final List<Widget> children;

  const CollapsibleForm({super.key, required this.children});

  @override
  CollapsibleFormState createState() => CollapsibleFormState();
}

class CollapsibleFormState extends State<CollapsibleForm> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            title: const Text('Address Details'),
            trailing: IconButton(
              icon: Icon(
                _isExpanded ? Icons.expand_less : Icons.expand_more,
              ),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: widget.children,
              ),
            ),
        ],
      ),
    );
  }
}
