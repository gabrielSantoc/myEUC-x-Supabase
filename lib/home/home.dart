import 'package:flutter/material.dart';
import 'package:myeuc_x_supabase/components/my_drawer.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:myeuc_x_supabase/features/handbook/contentpage.dart';
import 'package:myeuc_x_supabase/utils/markdown_utils.dart';

import 'package:myeuc_x_supabase/shared/constants.dart';
import 'package:page_transition/page_transition.dart';


DateTime date = DateTime.now();
int timeCheck = date.hour;

String greeting = '';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _markdownData = '';
  Map<String, String> _sections = {};
  Map<String, String> _filteredSections = {};

  @override
  void initState() {
    super.initState();
    loadMarkdownData();
    updateGreetingMessage();
  }

  void updateGreetingMessage() {
    if (timeCheck < 12) {
      greeting = "Good Morning 🌞";
    } else if (timeCheck < 17) {
      greeting = "Good Afternoon 🌞";
    } else {
      greeting = "Good Evening 🌙";
    }
  }

  Future<void> loadMarkdownData() async {
    await MarkdownUtils.initializeMarkdownFile();
    final String data = await MarkdownUtils.getMarkdownContent();
    setState(() {
      _markdownData = data;
      _sections = MarkdownUtils.parseMarkdown(data);
      _filteredSections = _sections;
    });
  }

  

  void runFilter(String enteredKeyword) {
    Map<String, String> results = {};
    if (enteredKeyword.isEmpty) {
      results = _sections;
    } else {
      results = _sections.keys
      .where( (key) => key.toLowerCase().contains(enteredKeyword.toLowerCase()) )
      .fold({}, (result, key) {
        result[key] = _sections[key]!;
        return result;
      });
    }

    setState(() {
      _filteredSections = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("TIME CHECK ::::: ${timeCheck}");
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: maroon,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: Colors.white,

        
      ),
      drawer:  MyDrawer(onUpdateComplete: () => loadMarkdownData()),
      body: Container(
        height: double.infinity,
        child: Stack(
          children: [
            Positioned(
                top: 110,
                left: 0,
                right: 0,
                bottom: 0,
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 50),
                  shrinkWrap: true,
                  itemCount: _filteredSections.length,
                  itemBuilder: (context, index) {
                    final heading = _filteredSections.keys.elementAt(index);
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(4, 4),
                            blurRadius: 15,
                            color: Colors.grey.shade500,
                            spreadRadius: 1
                          ),
                          const BoxShadow(
                            offset: Offset(-4, -4),
                            blurRadius: 15,
                            color: Colors.white,
                            spreadRadius: 1
                          ),
                        ]
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        title: Text(
                          heading,
                          style: const TextStyle(
                            fontSize: 16,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w400
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: MAROON,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              child: ContentScreen(
                                heading: heading,
                                content: _filteredSections[heading]!,
                              ),
                              childCurrent: Home(),
                              type: PageTransitionType.rightToLeftJoined
                            ),
                          );
                        },
                      ),
                    );
                  },
              )
            ),
            Container(
              height: 129,
              decoration: const BoxDecoration(
                color: maroon,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40.0),
                  bottomRight: Radius.circular(40.0),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 1),
                    blurRadius: 15,
                    spreadRadius: 2.0,
                    color: Color.fromARGB(125, 158, 11, 0)
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Transform.translate(
                  offset: const Offset(0, -12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        greeting,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 31,
                          fontWeight: FontWeight.w200,
                          fontFamily: 'mont'
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),

            // TEXT FIELD
            Positioned(
              top: 98,
              left: 0,
              right: 0,
              child: Container(
                alignment: Alignment.center,
                height: 54,
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(5, 5),
                      blurRadius: 10,
                      color: maroon.withOpacity(0.23),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    onChanged: (value) => runFilter(value),
                    decoration: const InputDecoration(
                      hintText: 'Search for something...',
                      icon: Icon(
                        Icons.search,
                        color: maroon,
                      ),
                      hintStyle: TextStyle(
                        color: Color.fromARGB(204, 80, 80, 80),
                        fontWeight: FontWeight.w300,
                        letterSpacing: 1.5
                      ),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}