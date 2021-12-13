import 'dart:math';

import 'package:flutter/material.dart';
import 'package:qweez_app/components/form/my_dropdown_form_field.dart';
import 'package:qweez_app/components/form/my_text_form_field_complete.dart';
import 'package:qweez_app/constants/constants.dart';
import 'package:qweez_app/models/question.dart';

class EditQuestionPage extends StatefulWidget {
  final Question question;

  const EditQuestionPage({
    Key? key,
    required this.question,
  }) : super(key: key);

  @override
  State<EditQuestionPage> createState() => _EditQuestionPageState();
}

class _EditQuestionPageState extends State<EditQuestionPage> {
  final _formKey = GlobalKey<FormState>();
  final List<String> _listExampleQuestion = ['What is the capital of ...', 'When does the ...', 'Wo was the first ...'];
  final List<String> _listAnswersDropDown4 = ['Answer 1', 'Answer 2', 'Answer 3', 'Answer 4'];
  final List<String> _listAnswersDropDown2 = ['Answer 1', 'Answer 2'];
  List<String> _listDropDown = [];

  String _correctAnswerSelected = '';

  @override
  void initState() {
    super.initState();

    if (widget.question.type.isEmpty) {
      widget.question.type = listDropDownValue.last;
      _listDropDown = _listAnswersDropDown4;
      _correctAnswerSelected = _listAnswersDropDown4.first;
      widget.question.answers.first.isGoodAnswer = true;
    } else {
      // Set the listDropDown according to the one selected before (in the database)
      if (widget.question.type == listDropDownValue.last) {
        _listDropDown = _listAnswersDropDown4;
      } else if (widget.question.type == listDropDownValue[1]) {
        _listDropDown = _listAnswersDropDown2;
      }

      int index = widget.question.answers.indexWhere((answer) => answer.isGoodAnswer);
      switch (index) {
        case 0:
          _correctAnswerSelected = _listAnswersDropDown4.first;
          break;
        case 1:
          _correctAnswerSelected = _listAnswersDropDown4[1];
          break;
        case 2:
          _correctAnswerSelected = _listAnswersDropDown4[2];
          break;
        case 3:
          _correctAnswerSelected = _listAnswersDropDown4[3];
      }
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
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: const Text(
          'Create a question',
        ),
      ),
      body: SingleChildScrollView(
        child: Form(key: _formKey, child: _buildQuestion()),
      ),
    );
  }

  Widget _buildQuestion() {
    int random = Random().nextInt(_listExampleQuestion.length);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: paddingVertical, horizontal: paddingHorizontal),
      child: Column(
        children: [
          MyTextFormFieldComplete(
            titleText: 'Question text',
            valueText: widget.question.question,
            hintText: _listExampleQuestion[random],
            required: true,
            validator: (String? questionText) {
              return questionText!.isEmpty ? 'Please enter a question' : null;
            },
            onChanged: (String questionText) => widget.question.question = questionText,
          ),
          MyDropDownFormField(
            titleText: 'Type of the question',
            hintText: 'Choose the type of the question',
            value: widget.question.type,
            itemsList: listDropDownValue,
            onChanged: (String? choice) {
              setState(() {
                widget.question.type = choice!;

                if (widget.question.type == listDropDownValue.last) {
                  _listDropDown = _listAnswersDropDown4;
                  // add the number of answer according to the choice selected
                  while (widget.question.answers.length < 4) {
                    widget.question.answers.add(Answer(answer: ''));
                  }
                } else if (widget.question.type == listDropDownValue[1]) {
                  _listDropDown = _listAnswersDropDown2;
                  // remove the last 2 answer if it was a 4 answers before
                  if (widget.question.answers.length == 4) {
                    while (widget.question.answers.length != 2) {
                      widget.question.answers.removeLast();
                    }
                  }

                  // add the number of answer according to the choice selected
                  while (widget.question.answers.length != 2) {
                    widget.question.answers.add(Answer(answer: ''));
                  }
                } else {
                  while (widget.question.answers.length != 1) {
                    widget.question.answers.removeLast();
                  }
                  widget.question.answers.first.isGoodAnswer = true;
                }
              });
            },
          ),
          _buildAnswers(),
          if (widget.question.type != listDropDownValue.first)
            MyDropDownFormField(
              titleText: 'Choose the correct answer',
              hintText: 'Select the answer that is correct',
              value: _correctAnswerSelected,
              itemsList: _listDropDown,
              onChanged: (value) {
                // Set all the value to false before selecting the new one
                for (var answer in widget.question.answers) {
                  answer.isGoodAnswer = false;
                }

                if (value == 'Answer 1') {
                  widget.question.answers.first.isGoodAnswer = true;
                } else if (value == 'Answer 2') {
                  widget.question.answers[1].isGoodAnswer = true;
                } else if (value == 'Answer 3' && widget.question.type == listDropDownValue.last) {
                  widget.question.answers[2].isGoodAnswer = true;
                } else {
                  widget.question.answers[3].isGoodAnswer = true;
                }
              },
            ),
          MyTextFormFieldComplete(
            titleText: 'Time to answer (seconds)',
            valueText: widget.question.time.toString(),
            hintText: "By default it is 10 seconds",
            textInputAction: TextInputAction.done,
            textInputType: TextInputType.number,
            validator: (value) {
              if (value!.contains(',') || value.contains('.')) {
                return 'Please enter an integer value';
              }
              if (value.startsWith('0')) {
                return 'Please enter a number greater than 0';
              }
              if (value.isEmpty) {
                widget.question.time = 10;
              }
            },
            onChanged: (value) {
              widget.question.time = int.parse(value);
            },
          ),
          ElevatedButton(
            child: Container(
              height: 40,
              width: double.maxFinite,
              alignment: Alignment.center,
              child: const Text(
                validateText,
              ),
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                FocusScope.of(context).unfocus();
                Navigator.of(context).pop();
              }
            },
          )
        ],
      ),
    );
  }

  Widget _buildAnswers() {
    return Column(
      // Use map entry to get the precise index of th iteration
      children: widget.question.answers
          .asMap()
          .map(
            (index, answer) {
              return MapEntry(
                index,
                MyTextFormFieldComplete(
                  // Index + 1 because we do not want that it start at 0
                  titleText: 'Answer ' + (index + 1).toString(),
                  valueText:
                      widget.question.answers[index].answer.isEmpty ? null : widget.question.answers[index].answer,
                  hintText: 'Enter an answer',
                  required: true,
                  // Depending of the question type the textInputAction
                  textInputAction: (widget.question.type == listDropDownValue.first ||
                          (widget.question.type == listDropDownValue.last && index == 3) ||
                          (widget.question.type == listDropDownValue[1] && index == 1))
                      ? TextInputAction.done
                      : TextInputAction.next,
                  validator: (String? answerText) {
                    return answerText!.isEmpty ? 'Please enter an answer' : null;
                  },
                  onChanged: (String answerText) {
                    widget.question.answers[index].answer = answerText;
                  },
                ),
              );
            },
          )
          .values
          .toList(),
    );
  }
}
