import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:myeuc_x_supabase/shared/constants.dart';
import 'package:hive_flutter/adapters.dart';

class ContentScreen extends StatefulWidget {
  final String heading;
  final String content;

  const ContentScreen({Key? key, required this.heading, required this.content}) : super(key: key);

  @override
  _ContentScreenState createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  late Box _myBox;
  double _textScaleFactor = 1.0;
  bool _showSlider = false;
  bool _isDarkMode = false;
  int _selectedIndex=1;

  @override
  void initState() {
    super.initState();
    _myBox = Hive.box('customValues');
    _loadSettings();
  }

void _loadSettings() {
  setState(() {
    _textScaleFactor = _myBox.get('textScaleFactor') ?? 1.0;
    _isDarkMode = _myBox.get('isDarkMode') ?? false;
  });
}

  void _saveSettings() {
    _myBox.put('textScaleFactor', _textScaleFactor);
    _myBox.put('isDarkMode', _isDarkMode);
  }

  Widget build(BuildContext context) {
    return Theme(
      data: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.heading),
          backgroundColor: _isDarkMode ? Color.fromARGB(255, 65, 65, 65) : MAROON,
          foregroundColor: Colors.white,
        ),
        body: SafeArea(
          child: Markdown(
            data: widget.content,
            selectable: true,
            styleSheet: MarkdownStyleSheet(
              h1: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              tableBody: const TextStyle(fontSize: 11),
              tableCellsPadding: const EdgeInsets.all(4),
              textScaler: TextScaler.linear(_textScaleFactor),
              blockSpacing: 10,
              tableHead: const TextStyle(fontWeight: FontWeight.normal ),
            ),
          ),
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          
          children: [
            if (_showSlider)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    const Icon(Icons.text_fields, size: 20,color: MAROON,),
                    Expanded(
                      child: Slider(
                        activeColor:  MAROON,
                        value: _textScaleFactor,
                        min: 0.5,
                        max: 2.0,
                        divisions: 11,
                        onChanged: (value) {
                          setState(() {
                            _textScaleFactor = value;
                            _saveSettings();
                          });
                        },
                      ),
                    ),
                    
                  ],
                ),
              ),
            BottomNavigationBar(
              
              selectedItemColor:_showSlider? MAROON: Colors.grey,
              selectedFontSize: 12,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.text_fields,color: _showSlider ?MAROON:const Color.fromARGB(255, 128, 127, 127),),
                  label: 'Font Size',
                ),
                BottomNavigationBarItem(
                  icon: Icon(_isDarkMode ? Icons.light_mode  : Icons.dark_mode,color: _isDarkMode?Colors.white:Colors.black,),
                  label: _isDarkMode ? 'Light Mode' : 'Dark Mode',
                ),
              ],
              onTap: (index) {
                if (index == 0) {
                  setState(() {
                    _selectedIndex =0;
                    _showSlider = !_showSlider;
                  });
                } else if (index == 1) {
                  setState(() {
                    
                    _selectedIndex=1;
                    _isDarkMode = !_isDarkMode;
                    _saveSettings();
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
