import 'package:qweez_app/models/questionnaire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionnaireRepository {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  static const String dbName = 'questionnaire';

  Future<void> createQuestionnaire(Questionnaire questionnaire) async {
    await firestore.collection(dbName).add(questionnaire.toJson());
  }

  Future<void> updateQuestionnaire(Questionnaire questionnaire) async {
    await firestore.collection(dbName).doc(questionnaire.id).update(questionnaire.toJson());
  }

  Future<List<Questionnaire>> getQuestionnairesByUserId(String userId) async {
    List<Questionnaire> _listQuestionnaire = [];

    // Get the querySnapshot of all the elements that are corresponding to the condition
    var res =
        await FirebaseFirestore.instance.collection(dbName).where(Questionnaire.dbUserId, isEqualTo: userId).get();

    // Loop through the data to format them
    for (var doc in res.docs) {
      Map<String, dynamic> data = doc.data();

      var newEntries = {
        Questionnaire.dbId: doc.id,
      };

      data.addAll(newEntries);
      _listQuestionnaire.add(Questionnaire.fromJson(data));
    }

    return _listQuestionnaire;
  }

  Future<Questionnaire> getQuestionnairesById(String questionnaireId) async {
    var res = await FirebaseFirestore.instance.collection(dbName).doc(questionnaireId).get();

    Map<String, dynamic> data = res.data()!;

    var newEntries = {
      Questionnaire.dbId: res.id,
    };
    data.addAll(newEntries);

    return Questionnaire.fromJson(data);
  }
}
