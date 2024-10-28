// @override
// void initState() {
//   super.initState();
//   checkIfAPIhasBeenModified(); // Check for API modification
// }

// // Modify checkIfAPIhasBeenModified to await storeEventsLocally when necessary
// void checkIfAPIhasBeenModified() async {
//   try {
//     // ANCHOR - GET LAST MODIFIED
//     final lastModifiedQueryNew = await 
//       Supabase.instance.client
//       .from('tbl_calendar')
//       .select('last_modified')
//       .order('last_modified', ascending: false)
//       .limit(1);

//     print("LAST MODIFIED RESPONSE :::: $lastModifiedQueryNew");
//     String lastModifiedNew = lastModifiedQueryNew[0]['last_modified'].toString();

//     var lastModifiedFromHive = boxHeader.get('last-modified');
//     print("LAST MODIFIED NEW       ::: ${lastModifiedNew}");
//     print("LAST MODIFIED FROM HIVE ::: ${lastModifiedFromHive}");

//     if (lastModifiedFromHive != lastModifiedNew) {
//       boxHeader.clear();
//       boxEvents.clear();
//       await storeEventsLocally(); // Await the storing of events
//       Alert.of(context).showSuccess('Calendar has been updated successfully. 🥰🥰🥰');
//     } else {
//       Alert.of(context).showSuccess('Calendar is still up to date. 🥰🥰🥰');
//     }
//   } catch (e) {
//     print("EXCEPTION ::::: $e");
//     filterEventsFromHive();
//   }
//   filterEventsFromHive();
// }
