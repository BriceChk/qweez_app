import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qweez_app/models/qweez.dart';

class QuestionnaireRepository {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  static const String dbName = 'questionnaire';

  Future<void> add(Qweez questionnaire) async {
    await firestore.collection(dbName).add(questionnaire.toJson());
  }

  Future<void> update(Qweez questionnaire) async {
    await firestore.collection(dbName).doc(questionnaire.id).update(questionnaire.toJson());
  }

  Future<List<Qweez>> getUserQweezes(String userId) async {
    List<Qweez> qweezList = [];

    // Get the querySnapshot of all the elements that are corresponding to the condition
    var res =
        await FirebaseFirestore.instance.collection(dbName).where(Qweez.dbUserId, isEqualTo: userId).get();

    // Loop through the data to format them
    for (var doc in res.docs) {
      Map<String, dynamic> data = doc.data();

      var newEntries = {
        Qweez.dbId: doc.id,
      };

      data.addAll(newEntries);
      qweezList.add(Qweez.fromJson(data));
    }

    return qweezList;
  }

  Future<Qweez> get(String qweezId) async {
    var res = await FirebaseFirestore.instance.collection(dbName).doc(qweezId).get();

    Map<String, dynamic> data = res.data()!;

    var newEntries = {
      Qweez.dbId: res.id,
    };
    data.addAll(newEntries);

    return Qweez.fromJson(data);
  }
}
