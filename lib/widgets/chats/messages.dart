import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:let_us_chat/widgets/chats/message_bubble.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats/UvqA8vEMRO8X37ezHLAV/messages')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (ctx, snapshot) {
          final user = FirebaseAuth.instance.currentUser;
          final document = snapshot.data!.docs;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          return ListView.builder(
              reverse: true,
              itemCount: document.length,
              itemBuilder: (ctx, index) {
                return MessageBubble(
                  document[index]['text'],
                  document[index]['userName'],
                  document[index]['image_url'],
                  document[index]['userId'] == user!.uid,
                  key: ValueKey(document[index].id),
                );
              });
        });
  }
}
