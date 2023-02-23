import 'dart:io';

import 'package:beamer/beamer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cross_file/cross_file.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:research_buddy/models/project.dart';
import 'package:research_buddy/views/projects/add_field.dart';
import 'package:research_buddy/views/widgets/fields/record_field.dart';

class AddProjectStepper extends StatefulWidget {
  const AddProjectStepper({Key? key}) : super(key: key);

  @override
  State<AddProjectStepper> createState() => _AddProjectStepperState();
}

class _AddProjectStepperState extends State<AddProjectStepper> {
  int _currentStep = 0;
  final List<ProjectField> fields = [];

  final _stepOneFormKey = GlobalKey<FormBuilderState>();
  final _stepThreeFormKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Stepper(
      currentStep: _currentStep,
      type: StepperType.horizontal,
      onStepContinue: _onContinue,
      onStepCancel: _onCancel,
      controlsBuilder: _buidControls,
      steps: [
        Step(
          title: const Text('Project Details'),
          content: _StepOne(formKey: _stepOneFormKey),
          isActive: _currentStep >= 0,
        ),
        Step(
          title: const Text('Form'),
          content: _StepTwo(fields: fields),
          isActive: _currentStep >= 1,
        ),
        Step(
          title: const Text('Publish'),
          content: _StepThree(formKey: _stepThreeFormKey),
          isActive: _currentStep >= 2,
        ),
      ],
    );
  }

  void _onSubmit(bool isDraft) async {
    if (_stepThreeFormKey.currentState?.saveAndValidate() ?? false) {
      final formOneState = _stepOneFormKey.currentState!;
      final formThreeState = _stepThreeFormKey.currentState!;

      final userId = FirebaseAuth.instance.currentUser!.uid;
      String? imageUrl;
      if (formOneState.value['image'] != null) {
        List<dynamic> images = formOneState.value['image'];
        if (images.isNotEmpty) {
          final image = images.first as XFile;
          final imageName = "${Timestamp.now().nanoseconds}-${image.name}";
          final ref = FirebaseStorage.instance
              .ref()
              .child("project-images")
              .child(userId)
              .child(imageName);
          ref.putFile(File(image.path));
          imageUrl = ref.fullPath;
        }
      }

      final userDocRef =
          FirebaseFirestore.instance.collection('users').doc(userId);
      final project = Project(
        name: formOneState.value['name'],
        description: formOneState.value['description'],
        owner: userDocRef,
        imageUrl: imageUrl,
        isPrivate: formThreeState.value['isPrivate'] ?? false,
        isPublished: !isDraft,
        entryCode: formThreeState.value['entryCode'],
        allowedUsers: [userDocRef],
        blacklistedUsers: [],
        fields: fields,
      );

      final data = project.toJson();
      await FirebaseFirestore.instance.collection('projects').add(data);

      Beamer.of(context).beamToNamed("/home");
    }
  }

  _onContinue() {
    if (_currentStep == 0) {
      if (_stepOneFormKey.currentState?.validate() ?? false) {
        _stepOneFormKey.currentState?.save();
        setState(() => _currentStep = 1);
      }
    } else if (_currentStep == 1) {
      setState(() => _currentStep = 2);
    }
  }

  _onCancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }

  Widget _buidControls(_, controls) => Column(
        children: [
          const SizedBox(height: 16),
          if (controls.currentStep == 2)
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _onSubmit(true),
                        child: const Text('Save as Draft'),
                        style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all(Size(100.0, 50.0)),
                            backgroundColor: MaterialStateProperty.resolveWith((states) =>
                            states.contains(MaterialState.pressed) ? Colors.white : Colors.blue),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
                            )
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _onSubmit(false),
                        child: const Text('Publish'),
                        style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all(Size(100.0, 50.0)),
                            backgroundColor: MaterialStateProperty.resolveWith((states) =>
                            states.contains(MaterialState.pressed) ? Colors.white : Colors.red),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
                            )
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          if (controls.currentStep != 2)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: controls.onStepContinue,
                    child: const Text('Next'),
                    style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(Size(100.0, 50.0)),
                        backgroundColor: MaterialStateProperty.resolveWith((states) =>
                        states.contains(MaterialState.pressed) ? Colors.white : Colors.blue),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
                        )
                    ),
                  ),
                ),
              ],
            ),
          if (controls.currentStep != 0)
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: controls.onStepCancel,
                    child: const Text('Back'),
                  ),
                ),
              ],
            ),
        ],
      );
}

class _StepOne extends StatelessWidget {
  final GlobalKey<FormBuilderState> formKey;

  const _StepOne({Key? key, required this.formKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: formKey,
      child: Column(
        children: [
          FormBuilderTextField(
            name: 'name',
            decoration: const InputDecoration(
              label: Text('Project Name'),
              prefixIcon: Icon(Icons.lock),
              labelStyle: TextStyle(color: Colors.black87),
              filled: true,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30.0))),
            ),
            validator: FormBuilderValidators.compose(
              [FormBuilderValidators.required(context)],
            ),
          ),
          const SizedBox(height: 16),
          FormBuilderTextField(
            name: 'description',
            decoration: const InputDecoration(
              label: Text('Project Description'),
              prefixIcon: Icon(Icons.lock),
              labelStyle: TextStyle(color: Colors.black87),
              filled: true,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30.0))),
            ),
            maxLines: 3,
            keyboardType: TextInputType.multiline,
            validator: FormBuilderValidators.compose(
              [FormBuilderValidators.required(context)],
            ),
          ),
          const SizedBox(height: 16),
          FormBuilderImagePicker(
            name: "image",
            decoration: const InputDecoration(
              label: Text('Project Image'),
              labelStyle: TextStyle(color: Colors.black87),
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30.0))),
            ),
            maxImages: 1,
          ),
        ],
      ),
    );
  }
}

class _StepTwo extends StatefulWidget {
  final List<ProjectField> fields;
  const _StepTwo({Key? key, required this.fields}) : super(key: key);

  @override
  State<_StepTwo> createState() => _StepTwoState();
}

class _StepTwoState extends State<_StepTwo> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ..._buildFields(),
        ElevatedButton(
          onPressed: _showAddFieldForm,
          child: const Text("Add Field"),
          style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(Size(100.0, 50.0)),
              backgroundColor: MaterialStateProperty.resolveWith((states) =>
              states.contains(MaterialState.pressed) ? Colors.white : Colors.green),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
              )
          ),
        ),
      ],
    );
  }

  Future<void> _showAddFieldForm() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AddField(onSubmit: _addToFields);
      },
    );
  }

  void _addToFields(ProjectField field) {
    setState(() => widget.fields.add(field));
  }

  List<Widget> _buildFields() {
    return widget.fields
        .asMap()
        .map(
          (i, value) => MapEntry(
            i,
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Expanded(
                      child: RecordFieldWidget(
                    index: i,
                    field: widget.fields[i],
                  )),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: IconButton(
                      onPressed: () =>
                          setState(() => widget.fields.removeAt(i)),
                      icon: const Icon(Icons.remove_circle),
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        .values
        .toList();
  }
}

class _StepThree extends StatefulWidget {
  final GlobalKey<FormBuilderState> formKey;
  const _StepThree({Key? key, required this.formKey}) : super(key: key);

  @override
  State<_StepThree> createState() => _StepThreeState();
}

class _StepThreeState extends State<_StepThree> {
  bool _isPrivate = false;

  @override
  Widget build(BuildContext context) {
    final _formKey = widget.formKey;

    return FormBuilder(
      key: _formKey,
      child: Column(
        children: [
          FormBuilderSwitch(
            name: 'isPrivate',
            title: const Text('Make Private'),
            decoration: const InputDecoration(
              labelStyle: TextStyle(color: Colors.black87),
              filled: true,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30.0))),
            ),
            onChanged: (val) => {
              setState(() => {_isPrivate = val == true})
            },
          ),
          const SizedBox(height: 8),
          _isPrivate
              ? Column(children: [
                  FormBuilderTextField(
                    name: 'entryCode',
                    decoration: const InputDecoration(
                      label: Text('Entry Code'),
                      labelStyle: TextStyle(color: Colors.black87),
                      filled: true,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30.0))),
                    ),
                    validator: FormBuilderValidators.compose(
                      [
                        FormBuilderValidators.required(context),
                        FormBuilderValidators.maxLength(context, 5),
                        FormBuilderValidators.minLength(context, 5),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8)
                ])
              : const SizedBox(),
        ],
      ),
    );
  }
}
