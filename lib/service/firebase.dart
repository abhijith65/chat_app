// import 'package:cloud_firestore/cloud_firestore.dart';
//
// late CollectionReference _userCollection;
// _userCollection = FirebaseFirestore.instance.collection
// ("users
// "
// );Future<void> addUser() {
// return _userCollection
//     .add({'name': nameController.text, 'email': emailController.text}).then(
// (value) {
// print("User Added Successfully");
// nameController.clear();
// emailController.clear();
// }).catchError((error) {
// print("Failed to Add user :$error");
// });
// }
// var chat =FirebaseFirestore.instance.collection('chats').get();
import 'dart:math';

import 'package:async/async.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFunctions {
  late CollectionReference fireUser = FirebaseFirestore.instance.collection("users");
  var userChat=FirebaseFirestore.instance;
  Future<UserCredential?> signUpUser(
      {required String email, required String pwd}) async {
    UserCredential usercred;
    try {
       usercred= await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: pwd,
      );
      return usercred;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return null;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<String?> logInUser(
      {required String email, required String pwd}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: pwd);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      print(e);
      return 'failed $e';
    }

  }

  Future<void> logoutUser() async{
    await FirebaseAuth.instance.signOut();
  }
  Future<void> fireUserAdd({required String id,required String email}) {
    return fireUser
        .add({'userId': id, 'email': email}).then(
            (value) {
          print("User Added");
        }).catchError((error) {
      print("Failed to Add user :$error");
    });
  }
  // QuerySnapshot contains result of query(data from fire store)
  // and metadata (additional information like errors warnings etc)
  Stream<QuerySnapshot> fireUserList() {
    return fireUser.snapshots();
  }

  fireUserChatAdd({required String id,required String userId,required String msg}){
    var data={
      'id':id,
      'userId':userId,
      'msg':msg,
      'time':DateTime.now().microsecondsSinceEpoch
    };
    var l= minDuck('$id $userId', '$userId $id');
    return userChat.collection(l).add(data);
  }
  Stream<QuerySnapshot> fireUserChatGet({required String id,required String userId}){
    var l= minDuck('$id $userId', '$userId $id');
    var chatList=userChat.collection(l).snapshots();
    return chatList;
  }

  String minDuck(String a,String b){
    String min= a+b;
    String max=b+a;
    return min.compareTo(max)<0?min:max;
  }

}