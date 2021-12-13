import 'package:beamer/beamer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qweez_app/components/form/my_text_form_field_complete.dart';
import 'package:qweez_app/constants/constants.dart';
import 'package:qweez_app/main.dart';
import 'package:qweez_app/models/question.dart';
import 'package:qweez_app/models/qweez.dart';
import 'package:qweez_app/pages/creation_questionnaire/creation_edition_answer.dart';
import 'package:qweez_app/repository/questionnaire_repository.dart';

class EditQweezPage extends StatefulWidget {
  final String? questionnaireId;

  const EditQweezPage({Key? key, this.questionnaireId}) : super(key: key);

  @override
  State<EditQweezPage> createState() => _EditQweezPageState();
}

class _EditQweezPageState extends State<EditQweezPage> {
  final _formKey = GlobalKey<FormState>();
  final _questionnaireRepository = QuestionnaireRepository();
  Qweez? _questionnaire;

  final List<Question> _listQuestion = [];

  late final String _userId;
  String _name = '', _description = '';

  @override
  void initState() {
    super.initState();
    _userId = MyApp.user!.uid;

    if (widget.questionnaireId != null) {
      _getData();
    }
  }

  Future<void> _getData() async {
    _questionnaireRepository.get(widget.questionnaireId!).then((value) {
      setState(() {
        _questionnaire = value;
        _name = _questionnaire!.name;
        _description = _questionnaire!.description;
        for (var question in _questionnaire!.questions) {
          _listQuestion.add(question);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
          ),
          onPressed: () {
            Beamer.of(context).beamBack();
          },
        ),
        centerTitle: true,
        title: const Text(
          'Create a Qweez',
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: paddingVertical,
              horizontal: paddingHorizontal,
            ),
            //color: Colors.red,
            child: Column(
              children: [
                MyTextFormFieldComplete(
                  titleText: 'Name of the Qweez',
                  valueText: _name,
                  hintText: 'Name',
                  required: true,
                  validator: (String? name) {
                    return name!.isEmpty ? 'Please enter a name' : null;
                  },
                  onChanged: (String name) => _name = name,
                ),
                MyTextFormFieldComplete(
                  titleText: 'Description',
                  valueText: _description,
                  hintText: 'This is a Qweez to learn...',
                  required: true,
                  validator: (String? description) {
                    return description!.isEmpty ? 'Please enter a description' : null;
                  },
                  onChanged: (String description) => _description = description,
                ),
                Column(
                  children: _listQuestion.map((question) {
                    int index = _listQuestion.indexWhere((thisQuestion) => question == thisQuestion);

                    return _buildQuestion(index);
                  }).toList(),
                ),
                SizedBox(
                  width: double.maxFinite,
                  height: 40,
                  child: ElevatedButton(
                    child: const Text(
                      'Add a question',
                    ),
                    onPressed: () {
                      setState(() {
                        _listQuestion.add(Question(question: '', type: '', answers: [], time: 10));
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: paddingVertical),
                  child: SizedBox(
                    width: double.maxFinite,
                    height: 40,
                    child: ElevatedButton(
                      child: const Text(
                        validateText,
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final questionnaire = Qweez(
                            name: _name,
                            description: _description,
                            questions: _listQuestion,
                            userId: _userId,
                          );
                          /*if (widget.questionnaireId != null) {
                            await questionnaireRepository.updateQuestionnaire(questionnaire);
                          } else {*/
                          await _questionnaireRepository.add(questionnaire);
                          //}
                          Beamer.of(context).beamBack();
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestion(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: paddingVertical),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius),
                  color: colorLightGreyForm,
                ),
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: paddingHorizontal),
                  child: Text(
                    _listQuestion[index].question.isEmpty
                        ? 'Question ' + (index + 1).toString()
                        : _listQuestion[index].question,
                    style: const TextStyle(
                      color: colorDarkGray,
                    ),
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => CreationAnswerPage(
                      question: _listQuestion[index],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: paddingHorizontal / 2),
            child: GestureDetector(
              child: Container(
                height: 50,
                width: 50,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorRed,
                ),
                child: const Icon(
                  Icons.delete_outline,
                  color: colorWhite,
                ),
              ),
              onTap: () {
                setState(() {
                  _listQuestion.removeAt(index);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
