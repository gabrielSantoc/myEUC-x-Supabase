import 'package:flutter/material.dart';
import 'package:myeuc_x_supabase/shared/constants.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  
  Map<String, String> faq = {
    "What is the purpose of this app ?" : "This app provides a digital copy of student handbook, AI powered chat assistant, and a school calendar. It’s designed to help students stay informed and connected to campus life.",
    "Can I access the app offline ?"  : "Features such as STUDENT HANDBOOK and SCHOOL CALENDAR are available offline. However, you'll need an internet connection to use the AI chatbot, receive notifications, and to be able to update the school calendar",
    "Is this app available on both Android and iOS ?"  : "Unfortunately, the app is currently only available on Android. But don’t worry—once we have access to a Mac, we’ll build an iOS version too. (We’re a bit broke 😞😞😞).",
    "Is my personal information safe in the app ? " : "Yes, the app follows strict university data protection policies and complies with privacy regulations to keep your information secure.",
    "Is there a way to report technical issues or bugs in the app ?"  : "Yes, you can tell it to ma'am Wish or your University and I professor.",
    "Can I receive notifications for important updates?"   : "Yes, you can allow notifications in your phone settings to stay updated on university anouncement and calendar events.",
    "What should I do if I forget my password ?"  : "Press the forgot password on the login page to reset your password, follow the instruction and wait for the token to be send to your email.",
  }; 

  late int faqLength;
  List<bool> expandedState = [];

  bool collapsed = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    faqLength = faq.length;
    expandedState = List<bool>.filled(faqLength, false);
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("FAQ"),
        backgroundColor: MAROON,
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            // color: Colors.whiter,
            borderRadius: BorderRadius.circular(12),
          ),
          child:  ListView.builder(
            itemCount: faqLength,
            itemBuilder: (context, index) {
              String question = faq.keys.elementAt(index);
              String answer = faq.values.elementAt(index);

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ExpansionTile(

                    onExpansionChanged: (isExpanded) {
                      setState(() {
                        expandedState[index] = isExpanded;
                      });
                    },
                    trailing: !expandedState[index] ? const Icon(Icons.add) : const Icon(Icons.remove),
                    collapsedIconColor: MAROON,
                    iconColor: MAROON,
                    childrenPadding:  const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    title: Text(question, style: const TextStyle(fontWeight: FontWeight.bold)),
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    collapsedShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide.none
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide.none
                    ),
                    
                    children: [
                      Text(answer),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      )
    ); 
  }
}