import 'package:flutter/material.dart';
import 'package:byday/widgets/contact_widget.dart';

/// A dedicated page that displays the ContactWidget.
/// This page is used to show the customer service contact options in a Scaffold.
class SupportPage extends StatelessWidget {
  const SupportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customer Service"),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: ContactWidget(),
        ),
      ),
    );
  }
}
