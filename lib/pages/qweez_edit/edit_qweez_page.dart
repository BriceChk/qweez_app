import 'package:beamer/beamer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qweez_app/components/form/my_text_form_field_complete.dart';
import 'package:qweez_app/constants.dart';
import 'package:qweez_app/main.dart';
import 'package:qweez_app/models/question.dart';
import 'package:qweez_app/models/qweez.dart';
import 'package:qweez_app/pages/qweez_edit/edit_question_page.dart';
import 'package:qweez_app/repository/questionnaire_repository.dart';

class EditQweezPage extends StatefulWidget {
  final String? qweezId;

  const EditQweezPage({Key? key, this.qweezId}) : super(key: key);

  @override
  State<EditQweezPage> createState() => _EditQweezPageState();
}

class _EditQweezPageState extends State<EditQweezPage> {
  final _formKey = GlobalKey<FormState>();
  final _qweezRepo = QweezRepository();

  late Qweez _qweez;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();

    if (widget.qweezId != null) {
      _qweezRepo.get(widget.qweezId!).then((value) {
        setState(() {
          if (value == null) {
            //TODO ID invalide
            return;
          }

          _isLoaded = true;
          _qweez = value;
        });
      });
    } else {
      _qweez = Qweez.empty(userId: MyApp.user!.uid);
      _isLoaded = true;
    }
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
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: const Text(
          'Create a Qweez',
          style: TextStyle(color: colorWhite),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (!_isLoaded) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Form(
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
                valueText: _qweez.name,
                hintText: 'Name',
                required: true,
                validator: (String? name) {
                  return name!.isEmpty ? 'Please enter a name' : null;
                },
                onChanged: (String name) => _qweez.name = name,
              ),
              MyTextFormFieldComplete(
                titleText: 'Description',
                valueText: _qweez.description,
                hintText: 'This is a Qweez to learn...',
                required: true,
                validator: (String? description) {
                  return description!.isEmpty ? 'Please enter a description' : null;
                },
                onChanged: (String description) => _qweez.description = description,
              ),
              Column(
                children: _qweez.questions.map((question) {
                  var index = _qweez.questions.indexOf(question);
                  return _buildQuestion(question, index);
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
                    // Create question and edit it immediatly
                    setState(() {
                      _qweez.questions.add(Question.empty());
                    });
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => EditQuestionPage(
                          question: _qweez.questions.last,
                        ),
                      ),
                    );
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
                      saveText,
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (_qweez.id != null) {
                          await _qweezRepo.update(_qweez);
                        } else {
                          await _qweezRepo.add(_qweez);
                        }

                        context.beamToReplacementNamed('/');
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestion(Question q, int index) {
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
                    q.question.isEmpty ? 'Question ' + (index + 1).toString() : q.question,
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
                    builder: (context) => EditQuestionPage(
                      question: q,
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
                  _qweez.questions.remove(q);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
