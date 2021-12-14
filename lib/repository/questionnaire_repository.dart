import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qweez_app/models/qweez.dart';

class QweezRepository {
  CollectionReference<Map<String, dynamic>> get _collection =>
      FirebaseFirestore.instance.collection(Qweez.dbCollectionName);

  Future<Qweez?> get(String qweezId) async {
    var doc = await _collection.doc(qweezId).get();

    if (!doc.exists) {
      return null;
    }

    Map<String, dynamic> data = doc.data()!;
    data[Qweez.dbId] = doc.id;

    return Qweez.fromJson(data);
  }

  Future<void> add(Qweez qweez) async {
    await _collection.add(qweez.toJson());
  }

  Future<void> update(Qweez qweez) async {
    await _collection.doc(qweez.id).update(qweez.toJson());
  }

  Future<void> remove(Qweez qweez) async {
    await _collection.doc(qweez.id).delete();
  }

  Future<List<Qweez>> getUserQweezes(String userId) async {
    List<Qweez> qweezList = [];

    // Get the querySnapshot of all the elements that are corresponding to the condition
    var res = await _collection.where(Qweez.dbUserId, isEqualTo: userId).get();

    // Loop through the data to format them
    for (var doc in res.docs) {
      Map<String, dynamic> data = doc.data();
      data[Qweez.dbId] = doc.id;

      qweezList.add(Qweez.fromJson(data));
    }

    return qweezList;
  }
}
