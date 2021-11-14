import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class Storage {
  final storage = FirebaseStorage.instance;

  // Upload image
  static UploadTask? uploadFile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);
      return ref.putFile(file);
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  // List all image files
  Future<ListResult> listFiles() async {
    ListResult results = await storage.ref('images').listAll();

    results.items.forEach((Reference ref) {
      print('Found file: $ref');
    });
    return results;
  }
}