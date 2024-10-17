import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MarkdownUtils {
  static const String _fileName = 'student_handbook.md';
  static const String _assetPath = 'assets/markdown/student_handbook.md';

  static Future<String> getMarkdownFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$_fileName';
  }

  static Future<void> initializeMarkdownFile() async {
    final filePath = await getMarkdownFilePath();
    final file = File(filePath);

    if (!await file.exists()) {
      // If the file doesn't exist in app documents, copy it from assets
      final assetContent = await rootBundle.loadString(_assetPath);
      await file.writeAsString(assetContent);
      print("Assets markdown successfully copied to app documents");
    }
  }

  static Future<void> updateMarkdownFile() async {
    final filePath = await getMarkdownFilePath();
    final supabase = Supabase.instance.client;

    try {
      // Fetch the filepath from tbl_handbook where in_use is true
      final response = await supabase
          .from('tbl_handbook')
          .select('filepath')
          .eq('in_use', true)
          .single();

      if (response['filepath'] != null) {
        final remoteUrl = response['filepath'] as String;

        // Download the file using Supabase storage
        final bytes = await supabase.storage
            .from('handbooks') 
            .download(remoteUrl);

        // Save the downloaded file to appdocs
        final file = File(filePath);
        await file.writeAsBytes(bytes);
        print('Markdown file updated successfully');
      } else {
        print('No active handbook found in the database');
      }
    } catch (e) {
      print('Error updating markdown file: $e');
    }
  }

  static Future<String> getMarkdownContent() async {
    final filePath = await getMarkdownFilePath();
    final file = File(filePath);
    return await file.readAsString();
  }

  static Map<String, String> parseMarkdown(String markdown) {
    final lines = markdown.split('\n');
    final Map<String, String> sections = {};
    String currentHeading = '';
    List<String> currentContent = [];

    for (final line in lines) {
      if (line.startsWith('#')) {
        // If theres an existing heading, then add that and its content to the sections, then delete the contents to start over again for the next section
        if (currentHeading.isNotEmpty) {
          sections[currentHeading] = currentContent.join('\n').trim();
          currentContent.clear();
        }
        // Update the current heading and remove marakdown symbols
        currentHeading = line.replaceAll(RegExp(r'^#+\s*|\*|_|~|`'), '').trim();

      } else {
        // Add non-heading lines to the current content
        currentContent.add(line);
      }
    }

    // Add the last section since the saving to sections only triggers if theres heading, so if theres no heading in the end, it cant be saved
    if (currentHeading.isNotEmpty) {
      sections[currentHeading] = currentContent.join('\n').trim();
    }

    return sections;
  }
}