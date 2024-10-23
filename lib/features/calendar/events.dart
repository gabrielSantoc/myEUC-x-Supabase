import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:myeuc_x_supabase/box/boxes.dart';
import 'package:myeuc_x_supabase/components/my_drawer.dart';
import 'package:myeuc_x_supabase/features/calendar/model/eventModel.dart';
import 'package:myeuc_x_supabase/features/calendar/model/eventModelHive.dart';
import 'package:myeuc_x_supabase/features/calendar/model/tileModel.dart';
import 'package:myeuc_x_supabase/shared/alert.dart';
import 'package:myeuc_x_supabase/shared/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

DateTime todayDate = DateTime.now();
String todayMonth = "${todayDate.month}";
var formattedDate = DateFormat('yyyy-MM-dd');
var fromattedTimestamp = DateFormat("yyyy-MM-dd hh:mm:ss");

class MyEucEvents extends StatefulWidget {
  const MyEucEvents({super.key});

  @override
  State<MyEucEvents> createState() => MyEucEventsState();
}

class MyEucEventsState extends State<MyEucEvents> {
 
  List<EventModel> events = [];
  String dropdownValue = todayMonth;
  late Future<void> futureEvents;

  @override
  void initState() {
    // if this is the first time ever opening the app, then fetch the events and store them locally
    // if(boxEvents.get('EventBox') == null && boxHeader.get('HeaderBox') == null) {
    //   storeEventsLocally();
    // }

    //TODO - check if api is modified, if not dont run the store local events fucntion
    checkIfAPIhasBeenModified();
    futureEvents = storeEventsLocally();
     
    super.initState();
  }

  // Get events(Hive)
  List<EventModelHive> eventsFromHive = []; 
  Future storeEventsLocally() async { // ANCHOR -Run only when it's first time or storage has been modified

    try {

      final listOfEventsQuery = await 
        Supabase.instance.client
        .from('tbl_calendar')
        .select()
        .order('date', ascending: true);

      // print('SCHOOL CALENDAR EVENTS ::::: $listOfEvents');


      // ANCHOR - GET LAST MODIFIED
      final lastModifiedQuery = await 
        Supabase.instance.client
        .from('tbl_calendar')
        .select('last_modified')
        .order('last_modified', ascending: false)
        .limit(1);

      print("LAST MODIFIED RESPONSE :::: $lastModifiedQuery");
      String lastModified = lastModifiedQuery[0]['last_modified'].toString();
      
      print("LAST MODIFIED :::: $lastModified");

      boxHeader.put('last-modified', lastModified);

      int index = 0;
      for(var eachEvent in listOfEventsQuery){

        var eventHive = EventModelHive(
          date: eachEvent['date'],
          eventName: eachEvent['event_name'],
          eventDescription: eachEvent['event_description']
        );

        eventsFromHive.add(eventHive);
        boxEvents.put(index, eventHive);
        index++;
      }

      filterEventsFromHive();

    } on Exception catch(e) {

      print("EXCEPTION ::::: $e");
      filterEventsFromHive();

    }
    
  }

  // ANCHOR -  Filter events from local database
  List<EventModelHive> listForFilter = [];
  void filterEventsFromHive() {
    listForFilter = [];

    for(int i = 0; i < boxEvents.length; i++) {
      EventModelHive event = boxEvents.getAt(i);
      DateTime eventDateConverted = DateTime.parse(event.date.toString());
      
      if(eventDateConverted.month.toString() == dropdownValue) {
        listForFilter.add(event); 
      }
    }

    for(var e in listForFilter){
      print("EVENT NAME : ${e.eventName}");
    }

    setState(() {
      listForFilter;
    });

  }

  void checkIfAPIhasBeenModified() async {
     
    try {
      // ANCHOR - GET LAST MODIFIED
      final lastModifiedQueryNew = await 
        Supabase.instance.client
        .from('tbl_calendar')
        .select('last_modified')
        .order('last_modified', ascending: false)
        .limit(1);

      print("LAST MODIFIED RESPONSE :::: $lastModifiedQueryNew");
      String lastModifiedNew = lastModifiedQueryNew[0]['last_modified'].toString();


      var lastModifiedFromHive = boxHeader.get('last-modified');
      print("LAST MODIFIED NEW       ::: ${lastModifiedNew}");
      print("LAST MODIFIED FROM HIVE ::: ${boxHeader.get('last-modified')}");

      if(lastModifiedFromHive != lastModifiedNew) {
        boxHeader.clear();
        boxEvents.clear();
        storeEventsLocally();
        Alert.of(context).showSuccess('Calendar has been updated successfully". 🥰🥰🥰');
      } else {
        Alert.of(context).showSuccess('Calendar is still up to date". 🥰🥰🥰');
      }


    } on Exception catch(e) {

      print("EXCEPTION ::::: $e");
      filterEventsFromHive();

    }
    filterEventsFromHive();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        elevation: 0,

        title: Theme(
          data: ThemeData.dark(),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String> (
              value: dropdownValue,
              items: const [
          
                DropdownMenuItem<String>(
                  value: "1",
                  child: Text("January"),
                ),
                
                DropdownMenuItem<String>(
                  value: "2",
                  child: Text("February"),
                ),
          
                DropdownMenuItem<String>(
                  value: "3",
                  child: Text("March"),
                ),
          
                DropdownMenuItem<String>(
                  value: "4",
                  child: Text("April"),
                ),
          
                DropdownMenuItem<String>(
                  value: "5",
                  child: Text("May"),
                ),
                
                DropdownMenuItem<String>(
                  value: "6",
                  child: Text("June"),
                ),
                // Hello
                DropdownMenuItem<String>(
                  value: "7",
                  child: Text("July"),
                ),
                
                DropdownMenuItem<String>(
                  value: "8",
                  child: Text("August"),
                ),
          
                DropdownMenuItem<String>(
                  value: "9",
                  child: Text("September"),
                ),
          
                DropdownMenuItem<String>(
                  value: "10",
                  child: Text("October"),
                ),
          
                DropdownMenuItem<String>(
                  value: "11",
                  child: Text("November"),
                ),
          
                DropdownMenuItem<String>(
                  value: "12",
                  child: Text("December"),
                ),
          
              ],
              onChanged: (String? newValue) {

                setState(() {
                  dropdownValue = newValue!;
                  filterEventsFromHive();
                });

              },
            ),
          )
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: MAROON,
      ),

      backgroundColor: Colors.white,
    
      drawer: const MyDrawer(),

      body: 
      RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          checkIfAPIhasBeenModified();
        },
        child: FutureBuilder(
          future: futureEvents,
          builder: (context, snapshot) {
            
            if(snapshot.connectionState == ConnectionState.waiting) {


              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LoadingAnimationWidget.fourRotatingDots(
                      color: const Color.fromARGB(255, 170, 0, 0),
                      size: 60
                    ),

                    const SizedBox(height: 20),

                    Text(
                      'Loading...',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600])
                    ),
                  ],
                ),
              );
        
            } else if(listForFilter.isEmpty) {
              
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: RefreshIndicator(
                  onRefresh: () async {
                    await Future.delayed(const Duration(seconds: 1));
                    checkIfAPIhasBeenModified();
                  }, 
                  child: const NoScheduleNotice(),
                ),
              );
        
            }if(snapshot.hasError){
              
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
              
            }  else  { 
        
              return ListView.builder(
                itemCount: listForFilter.length,
                itemBuilder: (context, index) {
                  
                  EventModelHive event = listForFilter[index];
                  // ANCHOR - WALANG KATUPASANG CONVERTIONS
                  var dateNumberFormatted = DateFormat('d');
                  var dayNameFormatted = DateFormat('EEE');
                  var dateParesed = DateTime.parse(event.date);
                  
                  if(event.date == formattedDate.format(todayDate).toString()) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 13.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 30),
                          TodayDaySchedule(
                            day: dayNameFormatted.format(dateParesed), 
                            date: dateNumberFormatted.format(dateParesed),
                            title: event.eventName,
                            subtitle: event.eventDescription,
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 13.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 30),
                          DaySchedule(
                            day: dayNameFormatted.format(dateParesed), 
                            date: dateNumberFormatted.format(dateParesed),
                            title: event.eventName,
                            subtitle: event.eventDescription,
                          ),
                        ],
                      ),
                    );
                  }
                },
              );
            }  
          },
        ),
      ),
    );
  }
}
