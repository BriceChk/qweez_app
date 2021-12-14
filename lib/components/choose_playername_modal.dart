import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:qweez_app/components/form/my_text_form_field.dart';
import 'package:qweez_app/constants.dart';

Future<void> showPickUsername(BuildContext context, String qweezId) {
  var _formKey = GlobalKey<FormState>();
  var _username = '';

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius / 1.5),
        ),
        insetPadding: EdgeInsets.zero,
        title: const Text(
          'Choose a username',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: fontSizeSubtitle,
          ),
        ),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MyTextFormField(
                hintText: 'Username',
                textInputAction: TextInputAction.done,
                valueText: '',
                validator: (username) {
                  if (username!.isEmpty) {
                    return 'Please enter your username';
                  }
                },
                onChanged: (username) {
                  _username = username;
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: paddingVertical),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Beamer.of(context).beamToNamed('/questionPresenterWaiting/$qweezId/$_username');
                    }
                  },
                  child: const Text('Join'),
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}
