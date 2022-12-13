import 'package:animate/home/comment_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

StreamBuilder<QuerySnapshot> getComments(String movieId) {
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance
        .collection('comments')
        .where("movie_id", isEqualTo: movieId)
        .snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (!snapshot.hasData)
        return Center(
          child: CircularProgressIndicator(),
        );
      final int commentCount = snapshot.data.documents.length;
      snapshot.data.documents.sort((a, b) => b.data['time'].compareTo(a.data['time']));
      if (commentCount > 0) {
        return ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: commentCount,
          itemBuilder: (_, int index) {
            final DocumentSnapshot document = snapshot.data.documents[index];
            return commentWidget(
              document['user_email'],
              document['content'],
              document['time'],
            );
          },
        );
      } else {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          alignment: Alignment.center,
          child: Text(
            'no comments...',
            style: TextStyle(fontSize: 20),
          ),
        );
      }
    },
  );
}

void createRecord(String movieId, String email, String content) async {
  await Firestore.instance.collection("comments").document().setData({
    'movie_id': movieId,
    'user_email': email,
    'content': content,
    'time': Timestamp.now()
  });
}

Future<String> getProfilePictureUrl(String email) async {
// 用使用者信箱當作索引值去找到對應的文件
  var doc = await Firestore.instance.collection('Users').document(email).get();
  if (doc.exists) {
    return doc.data['profile_picture_url'];
  }
  return '';
}

void updateProfilePictureUrl(String email, String url) async {
// 用使用者信箱當作索引值去新增or更新 圖片路徑
  await Firestore.instance.collection("Users").document(email).setData({
    'profile_picture_url': url,
  });
}