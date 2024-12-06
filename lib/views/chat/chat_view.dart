
import 'package:chat_app/constants/colors.dart';
import 'package:chat_app/constants/textstyles.dart';
import 'package:chat_app/service/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final String? userId;

  final String? id;
 final String? email;

  ChatScreen({this.userId, this.id, this.email});

  final TextEditingController controller = TextEditingController();


@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' $email'),
        backgroundColor: MyColors.mainColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFunctions().fireUserChatGet(id: id!,userId: userId!),

              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text("Error :${snapshot.error}"));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final chats = snapshot.data!.docs;
                return Expanded(
                    child: ListView.builder(
                        itemCount: chats.length,
                        reverse: true,
                        itemBuilder: (context, index) {
                          var chat = chats[index];
                          return ChatBox( chat,id);
                        }));
              }),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: "Type here",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: MyColors.iconColors),
                  onPressed: sendMessage(id!,userId!,controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
//Adding message to firebase collection
  sendMessage(String id,String userId, String msg) {
  controller.clear();
  FirebaseFunctions().fireUserChatAdd(id: id, userId: userId, msg: msg);
  
  }
}




class ChatBox extends StatelessWidget {
  final chat;

  final String? id;
  

  ChatBox(this.chat, this.id);

 

  @override
  Widget build(BuildContext context) {
    bool sender=chat['id'==id];
    return Align(
      alignment: sender ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        child: Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: sender ? Colors.blueGrey[100] : Colors.grey[300],
              borderRadius:sender ? BorderRadius.only(bottomLeft: Radius.circular(20)):BorderRadius.only(bottomRight: Radius.circular(20)),
            ),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Text(
              chat['msg'],
              style: MyTextThemes.chatStyle
            ),
          ),
        ),
      ),
    );
  }
}