import 'package:firebase_core/firebase_core.dart' as firebaseCore;
import 'package:firebase_storage/firebase_storage.dart' as firebaseStorage;


class Storage {
  final firebaseStorage.FirebaseStorage storage =
      firebaseStorage.FirebaseStorage.instance;
  Future<String> downloadURL(String imageName) async {
    String downloadURL =
        await storage.ref('petImages/$imageName').getDownloadURL();
    return downloadURL;
  }
}
