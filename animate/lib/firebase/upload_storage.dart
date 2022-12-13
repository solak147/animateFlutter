import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

StorageUploadTask uploadImage(File image, String email) {
  final extension = p.extension(image.path);
  final StorageReference ref =
  FirebaseStorage(storageBucket: 'gs://animate-e10a9.appspot.com')
      .ref()
      .child('$email$extension');
  StorageUploadTask uploadTask = ref.putFile(image);
  return uploadTask;
}