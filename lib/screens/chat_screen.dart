import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats/UvqA8vEMRO8X37ezHLAV/messages')
            .snapshots(),
        builder: (context, streamSnapshot) {
          final documents = streamSnapshot.data!.docs;
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (ctx, index) => Container(
              padding: EdgeInsets.all(10),
              child: Text(documents[index]['text']),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FirebaseFirestore.instance
              .collection('chats/UvqA8vEMRO8X37ezHLAV/messages')
              .add({'text': 'Added from codes'});
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
