import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:myeuc_x_supabase/shared/constants.dart';

class Manual extends StatelessWidget {
  const Manual({super.key});

  Future<String> loadMarkdown() async {
    return await rootBundle.loadString('assets/markdown/manual.md');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MAROON,
        title: const Text("USER MANUAL"),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<String>(
        future: loadMarkdown(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error loading manual"));
          } else {
            return Padding(
                padding: EdgeInsets.all(4),
                child: Markdown(data: snapshot.data ?? ''));
          }
        },
      ),
    );
  }
}
