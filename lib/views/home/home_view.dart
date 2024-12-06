import 'package:chat_app/constants/colors.dart';
import 'package:chat_app/service/firebase.dart';
import 'package:chat_app/views/chat/chat_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
   HomeView(this.id, {super.key});

  final String? id;
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.chat_rounded,size: 40,color: MyColors.iconColors,),
        title: Text('Chat APP'),
        backgroundColor: MyColors.mainColor,
      ),
      body:   StreamBuilder<QuerySnapshot>(
          stream: FirebaseFunctions().fireUserList(),

          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text("Error :${snapshot.error}"));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Text('no user available'),);
            }
          //creating a list of available users
            final users = snapshot.data!.docs;
            return Expanded(
                child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      final userId = user['userId'];
                      final useremail = user['email'];
                      return Card(
                        child: ListTile(
                          title: Text(useremail),
                          leading: Icon(Icons.face_4_sharp,size: 30,color: MyColors.iconColors,),
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatScreen(userId: userId,id: widget.id,email: useremail,)));
                          },
                        ),
                      );
                    }));
          }),

    );
  }
}
