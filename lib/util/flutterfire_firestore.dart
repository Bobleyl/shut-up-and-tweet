import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<bool> docExists() async {
  var collectionRef = FirebaseFirestore.instance.collection('Users');
  String uid = FirebaseAuth.instance.currentUser.uid;
  var doc = await collectionRef.doc(uid).get();
  return doc.exists;
}

Future<void> addUser(String twitterHandle) async {
  bool exists = await docExists();
  if (exists) {
    return;
  } else {
    String uid = FirebaseAuth.instance.currentUser.uid;
    DateTime now = new DateTime.now();
    String date = DateTime(now.year, now.month, now.day).toString();
    date = date.split(" ")[0];
    FirebaseFirestore.instance.collection('Users').doc(uid).set({
      "UID": uid,
      "Creation Date": date,
      "Twitter Handle": twitterHandle,
      "Tweet Count": 0,
      "Last Check": date
    });
    await setUpGrid();
  }
}

Future<void> addGrid(String uid, String gridName) async {
  FirebaseFirestore.instance
      .collection('Users')
      .doc(uid)
      .collection('Strategy')
      .doc()
      .set({"Name": gridName});
}

Future<void> addGoals(String uid, String goalName) async {
  FirebaseFirestore.instance
      .collection('Users')
      .doc(uid)
      .collection('Strategy')
      .doc(goalName)
      .set({'Goal': 0});
}

Future<void> setUpGrid() async {
  String uid = FirebaseAuth.instance.currentUser.uid;
  await addGrid(uid, "Self Promotion");
  await addGrid(uid, "Quick Question");
  await addGrid(uid, "Industry Buzz");
  await addGrid(uid, "Networking");
  await addGoals(uid, 'Followers');
  await addGoals(uid, 'Tweets');
  await addGoals(uid, 'Impressions');
}

Future<void> updateTweetCount() async {
  String uid = FirebaseAuth.instance.currentUser.uid;
  DocumentReference documentReference =
      FirebaseFirestore.instance.collection('Users').doc(uid);
  FirebaseFirestore.instance.runTransaction((transaction) async {
    DocumentSnapshot snapshot = await transaction.get(documentReference);
    if (!snapshot.exists) {
      documentReference.set({'Tweet Count': 1});
    }
    int newAmount = snapshot.data()['Tweet Count'] + 1;
    transaction.update(documentReference, {'Tweet Count': newAmount});
  });
}

// ignore: missing_return
Future<int> getTweetCount(String uid) async {
  DocumentSnapshot snapshot =
      await FirebaseFirestore.instance.collection('Users').doc(uid).get();
  return snapshot.data()['Tweet Count'];
}

Future<void> addTweet(String tweet, String section) async {
  String uid = FirebaseAuth.instance.currentUser.uid;
  int count = await getTweetCount(uid);
  print("Starting adding method: $count");
  await FirebaseFirestore.instance
      .collection('Users')
      .doc(uid)
      .collection("Strategy")
      .doc(section)
      .collection("Backlog")
      .doc((count + 1).toString())
      .set({
    "Tweet": tweet,
    "Date": DateTime.now().toIso8601String(),
  });
  await updateTweetCount();
}

Future<void> updateTweet(String tweetId, String tweet, String sectionId) async {
  String uid = FirebaseAuth.instance.currentUser.uid;
  FirebaseFirestore.instance
      .collection('Users')
      .doc(uid)
      .collection('Strategy')
      .doc(sectionId)
      .collection('Backlog')
      .doc(tweetId)
      .update({"Tweet": tweet});
}

Future<void> deleteTweet(String id, String section) async {
  String uid = FirebaseAuth.instance.currentUser.uid;
  await FirebaseFirestore.instance
      .collection('Users')
      .doc(uid)
      .collection("Strategy")
      .doc(section)
      .collection('Backlog')
      .doc(id)
      .delete();
}

Future<void> archiveTweet(String tweetId, String tweet, String section) async {
  String uid = FirebaseAuth.instance.currentUser.uid;
  await FirebaseFirestore.instance
      .collection('Users')
      .doc(uid)
      .collection("Strategy")
      .doc(section)
      .collection("Archive")
      .doc(tweetId)
      .set({
    "Tweet": tweet,
    "Date": DateTime.now().toIso8601String(),
  });
  await deleteTweet(tweetId, section);
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

Future<void> updateStrategyName(String id, String newName) async {
  String uid = FirebaseAuth.instance.currentUser.uid;
  FirebaseFirestore.instance
      .collection('Users')
      .doc(uid)
      .collection('Strategy')
      .doc(id)
      .update({'Name': newName});
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

Future<void> addItemToChecklist(String item) async {
  String uid = FirebaseAuth.instance.currentUser.uid;
  FirebaseFirestore.instance
      .collection('Users')
      .doc(uid)
      .collection('Checklist')
      .add({"Item": item, "Done": false});
}

Future<void> sameDayCheck() async {
  String uid = FirebaseAuth.instance.currentUser.uid;
  DocumentSnapshot docSnapshot =
      await FirebaseFirestore.instance.collection('Users').doc(uid).get();
  String lastCheck = docSnapshot.data()['Last Check'];
  DateTime now = new DateTime.now();
  String date = DateTime(now.year, now.month, now.day).toString();
  date = date.split(" ")[0];
  if (lastCheck != date) {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('Checklist')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                FirebaseFirestore.instance
                    .collection('Users')
                    .doc(uid)
                    .collection('Checklist')
                    .doc(doc.id)
                    .update({"Done": false});
              })
            });
    FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .update({"Last Check": date});
  } else {
    return;
  }
}

Future<void> checkItem(String id, bool value) async {
  String uid = FirebaseAuth.instance.currentUser.uid;
  FirebaseFirestore.instance
      .collection('Users')
      .doc(uid)
      .collection('Checklist')
      .doc(id)
      .update({"Done": value});
}

Future<void> deleteFromChecklist(String id) async {
  String uid = FirebaseAuth.instance.currentUser.uid;
  FirebaseFirestore.instance
      .collection('Users')
      .doc(uid)
      .collection('Checklist')
      .doc(id)
      .delete();
}

Future<void> changeFollowerGoal(int goal) async {
  String uid = FirebaseAuth.instance.currentUser.uid;
  FirebaseFirestore.instance
      .collection('Users')
      .doc(uid)
      .collection('Goals')
      .doc("Followers")
      .update({"Goal": goal});
}
