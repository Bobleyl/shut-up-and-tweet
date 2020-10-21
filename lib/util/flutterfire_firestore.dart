import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> addUser(String twitterHandle) async {
  String uid = FirebaseAuth.instance.currentUser.uid;
  String date = DateTime.now().toIso8601String();
  FirebaseFirestore.instance.collection('Users').doc(uid).set({
    "UID": uid,
    "Creation Date": date,
    "Twitter Handle": twitterHandle,
    "Tweet Count": 0
  });
}

Future<void> addGrid(String uid, String gridName) async {
  FirebaseFirestore.instance
      .collection('Users')
      .doc(uid)
      .collection('Strategy')
      .doc()
      .set({"Name": gridName});
}

Future<void> setUpGrid() async {
  String uid = FirebaseAuth.instance.currentUser.uid;
  await addGrid(uid, "Self Promotion");
  await addGrid(uid, "Quick Question");
  await addGrid(uid, "Industry Buzz");
  await addGrid(uid, "Networking");
}

// ignore: missing_return
Future<int> getTweetCount(String uid) async {
  FirebaseFirestore.instance
      .collection('Users')
      .doc(uid)
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
      return documentSnapshot.data()['Tweet Count'];
    }
  });
}

Future<void> addTweet(String tweet, String section) async {
  String uid = FirebaseAuth.instance.currentUser.uid;
  int count = await getTweetCount(uid);
  await FirebaseFirestore.instance
      .collection('Users')
      .doc(uid)
      .collection("Strategy")
      .where("Name", isEqualTo: section)
      .get()
      .then((QuerySnapshot querySnapshot) => {
            FirebaseFirestore.instance
                .collection('Users')
                .doc(uid)
                .collection("Strategy")
                .doc(querySnapshot.docs[0].id)
                .collection("Backlog")
                .doc((count + 1).toString())
                .set({
              "Tweet": tweet,
              "Date": DateTime.now().toIso8601String(),
            })
          });
}

Future<List<String>> getStrategySectionIds() async {
  String uid = FirebaseAuth.instance.currentUser.uid;
  List<String> list = [];
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('Users')
      .doc(uid)
      .collection('Strategy')
      .get();
  snapshot.docs.forEach((doc) {
    list.add(doc.id);
  });
  return list;
}

Future<List<String>> getStrategySections() async {
  String uid = FirebaseAuth.instance.currentUser.uid;
  List<String> list = [];
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('Users')
      .doc(uid)
      .collection('Strategy')
      .get();
  snapshot.docs.forEach((doc) {
    list.add(doc.data()['Name']);
  });
  return list;
}

// ignore: missing_return
Future<String> getHandle() async {
  try {
    String uid = FirebaseAuth.instance.currentUser.uid;
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('Users').doc(uid).get();
    return doc.data()['Twitter Handle'];
  } catch (e) {
    print(e.toString());
  }
}
