import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:research_buddy/models/project.dart';

Map<ProjectFieldType, String> _fieldTypes = {
  ProjectFieldType.string: 'String',
  ProjectFieldType.numeric: 'Number',
  ProjectFieldType.location: 'Location',
  ProjectFieldType.locationSeries: 'Location Series',
  ProjectFieldType.motionSensorSeries: 'Motion Sensor Series',
  ProjectFieldType.ambientSensorSeries: 'Ambient Sensor Series',
  ProjectFieldType.image: 'Image',
  ProjectFieldType.video: 'Video',
  ProjectFieldType.audio: 'Audio',
  ProjectFieldType.text: 'Text',
  ProjectFieldType.boolean: 'Yes/No',
  ProjectFieldType.dateTime: 'DateTime',
  ProjectFieldType.date: 'Date',
  ProjectFieldType.time: 'Time',
  ProjectFieldType.dropdown: 'Dropdown',
  ProjectFieldType.radio: 'Radio',
  ProjectFieldType.checkBoxes: 'Check Boxes',
};

Map<ProjectFieldValidatorType, String> _validatorTypes = {
  ProjectFieldValidatorType.required: 'Required',
  ProjectFieldValidatorType.email: 'Email',
  ProjectFieldValidatorType.integer: 'Integer',
  ProjectFieldValidatorType.match: 'Match Regex',
  ProjectFieldValidatorType.max: 'Max',
  ProjectFieldValidatorType.min: 'Min',
  ProjectFieldValidatorType.maxLength: 'Max Length',
  ProjectFieldValidatorType.minLength: 'Min Length',
  ProjectFieldValidatorType.url: 'URL',
};

class AddField extends StatefulWidget {
  final void Function(ProjectField data) onSubmit;

  const AddField({Key? key, required this.onSubmit}) : super(key: key);

  @override
  State<AddField> createState() => _AddFieldState();
}

class _AddFieldState extends State<AddField> {
  final _formKey = GlobalKey<FormBuilderState>();

  bool _hasOptions = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Field'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: FormBuilder(
            key: _formKey,
            child: Column(
              children: [
                FormBuilderTextField(
                  name: 'name',
                  decoration: const InputDecoration(
                    label: Text('Field Name'),
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
                FormBuilderDropdown<ProjectFieldType>(
                  name: 'type',
                  decoration: const InputDecoration(
                    label: Text('Field Type'),
                    labelStyle: TextStyle(color: Colors.black87),
                    filled: true,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30.0))),
                  ),
                  validator: FormBuilderValidators.compose(
                    [FormBuilderValidators.required(context)],
                  ),
                  items: _buildTypeDropdownItems(),
                  onChanged: (value) {
                    setState(() {
                      _hasOptions = value == ProjectFieldType.dropdown ||
                          value == ProjectFieldType.radio ||
                          value == ProjectFieldType.checkBoxes;
                    });
                    _formKey.currentState?.fields["validators"]
                        ?.didChange(null);
                  },
                ),
                const SizedBox(height: 16),
                // FormBuilderTextField(
                //   name: 'helperText',
                //   decoration: const InputDecoration(
                //     label: Text('Helper Text'),
                //     border: OutlineInputBorder(),
                //   ),
                //   validator: FormBuilderValidators.compose(
                //     [FormBuilderValidators.required(context)],
                //   ),
                // ),
                const SizedBox(height: 16),
                _hasOptions
                    ? Column(
                        children: [
                          FormBuilderField(
                            name: 'options',
                            validator: FormBuilderValidators.compose(
                              [FormBuilderValidators.required(context)],
                            ),
                            builder: (FormFieldState<dynamic> field) {
                              return InputDecorator(
                                decoration: InputDecoration(
                                  labelText: "Options",
                                  labelStyle: TextStyle(color: Colors.black87),
                                  filled: true,
                                  floatingLabelBehavior: FloatingLabelBehavior.never,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30.0))),
                                  errorText: field.errorText,
                                ),
                                child: Column(
                                  children: [
                                    FormBuilderTextField(
                                      name: 'tempOption',
                                      decoration: InputDecoration(
                                        label: const Text('Option'),
                                        labelStyle: TextStyle(color: Colors.black87),
                                        filled: true,
                                        floatingLabelBehavior: FloatingLabelBehavior.never,
                                        fillColor: Colors.white,
                                        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30.0))),
                                        suffixIcon: IconButton(
                                          onPressed: _addOption,
                                          icon: const Icon(Icons.add),
                                        ),
                                      ),
                                    ),
                                    ..._getOptions(),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                        ],
                      )
                    : const SizedBox(),
                FormBuilderField(
                  name: 'validators',
                  builder:
                      (FormFieldState<Map<ProjectFieldValidatorType, dynamic>>
                          field) {
                    return InputDecorator(
                      decoration: InputDecoration(
                        labelText: "Validators",
                        labelStyle: TextStyle(color: Colors.black87),
                        filled: true,
                        fillColor: Colors.white,
                        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30.0))),
                        errorText: field.errorText,
                      ),
                      child: Column(
                        children: [
                          FormBuilderDropdown<ProjectFieldValidatorType>(
                            name: 'tempValidator',
                            decoration: InputDecoration(
                              label: const Text('Validator'),
                              labelStyle: TextStyle(color: Colors.black87),
                              filled: true,
                              fillColor: Colors.white,
                              border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30.0))),
                              suffixIcon: IconButton(
                                onPressed: _addValidator,
                                icon: const Icon(Icons.add),
                              ),
                            ),
                            items: _buildValidatorsDropdownItems(),
                          ),
                          ..._buildValidators(),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: <Widget>[
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel', style: TextStyle(color: Colors.blue),),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _onSubmit(context),
                child: const Text('Save'),
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
            const SizedBox(width: 8),
          ],
        ),
      ],
    );
  }

  void _onSubmit(BuildContext context) {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final formState = _formKey.currentState!;

      final List<ProjectFieldValidator> validators = [];
      if (formState.value['validators'] != null) {
        (formState.value['validators']
                as Map<ProjectFieldValidatorType, dynamic>)
            .forEach((key, value) {
          validators.add(
            ProjectFieldValidator(type: key, value: value),
          );
        });
      }
      final field = ProjectField(
          name: formState.value['name'],
          type: formState.value['type'],
          helperText: formState.value['helperText'],
          validators: validators,
          options: formState.value['options']);
      widget.onSubmit(field);
      Navigator.pop(context);
    }
  }

  List<DropdownMenuItem<ProjectFieldType>> _buildTypeDropdownItems() {
    List<DropdownMenuItem<ProjectFieldType>> items = [];
    _fieldTypes.forEach((key, value) {
      items.add(DropdownMenuItem(
        value: key,
        child: Text(value),
      ));
    });
    return items;
  }

  List<DropdownMenuItem<ProjectFieldValidatorType>>
      _buildValidatorsDropdownItems() {
    final validatorTypes = {
      ProjectFieldValidatorType.required: "Required",
    };
    if (_formKey.currentState?.fields["type"]?.value != null) {
      ProjectFieldType type = _formKey.currentState?.fields["type"]?.value;
      if (type == ProjectFieldType.string || type == ProjectFieldType.text) {
        validatorTypes.addAll({
          ProjectFieldValidatorType.email: "Email",
          ProjectFieldValidatorType.match: "Match Regex",
          ProjectFieldValidatorType.maxLength: "Max Length",
          ProjectFieldValidatorType.minLength: "Min Length",
          ProjectFieldValidatorType.url: "URL",
        });
      }
      if (type == ProjectFieldType.numeric) {
        validatorTypes.addAll({
          ProjectFieldValidatorType.max: "Max",
          ProjectFieldValidatorType.min: "Min",
          ProjectFieldValidatorType.integer: "Integer",
        });
      }
    }

    List<DropdownMenuItem<ProjectFieldValidatorType>> items = [];
    validatorTypes.forEach((key, value) {
      items.add(DropdownMenuItem(
        value: key,
        child: Text(value),
      ));
    });
    return items;
  }

  void _addOption() {
    final tempOption = _formKey.currentState?.fields["tempOption"];
    if (tempOption?.value != null && (tempOption?.value as String).isEmpty) {
      return;
    }

    final options = _formKey.currentState?.fields["options"];
    List<String> newOptions = options?.value ?? [];
    newOptions.add(tempOption?.value);

    options?.didChange(newOptions);
    tempOption?.didChange("");
  }

  List<Widget> _getOptions() {
    final options = _formKey.currentState?.fields["options"];
    if (options?.value != null) {
      return (options!.value as List<String>)
          .asMap()
          .map((i, value) => MapEntry(
              i,
              Row(
                children: [
                  const SizedBox(width: 16),
                  Expanded(child: Text('${i + 1}. $value')),
                  IconButton(
                    onPressed: () =>
                        options.didChange(options.value..removeAt(i)),
                    icon: const Icon(Icons.remove_circle),
                    color: Colors.red,
                  ),
                ],
              )))
          .values
          .toList();
    }
    return [];
  }

  void _addValidator() {
    final temp = _formKey.currentState?.fields["tempValidator"];
    if (temp?.value == null) return;

    final validators = _formKey.currentState?.fields["validators"];
    Map<ProjectFieldValidatorType, dynamic> newValidators =
        validators?.value ?? {};
    newValidators.putIfAbsent(temp!.value, () => "");

    validators?.didChange(newValidators);
    temp.didChange(null);
  }

  bool _isNumeric(ProjectFieldValidatorType type) {
    return type == ProjectFieldValidatorType.max ||
        type == ProjectFieldValidatorType.min ||
        type == ProjectFieldValidatorType.maxLength ||
        type == ProjectFieldValidatorType.minLength;
  }

  bool _hasInput(ProjectFieldValidatorType type) {
    return type == ProjectFieldValidatorType.match || _isNumeric(type);
  }

  List<Widget> _buildValidators() {
    final validators = _formKey.currentState?.fields["validators"];
    if (validators?.value != null) {
      return (validators!.value as Map<ProjectFieldValidatorType, dynamic>)
          .map(
            (key, value) => MapEntry(
              key,
              Row(
                children: [
                  const SizedBox(width: 16),
                  Expanded(child: Text(_validatorTypes[key] ?? "")),
                  _hasInput(key)
                      ? Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: _isNumeric(key)
                                ? const TextInputType.numberWithOptions(
                                    decimal: false)
                                : null,
                            onChanged: (val) {
                              validators.value[key] =
                                  _isNumeric(key) ? int.tryParse(val) : val;
                              validators.didChange(validators.value);
                            },
                          ),
                        )
                      : const SizedBox(),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () =>
                        validators.didChange(validators.value..remove(key)),
                    icon: const Icon(Icons.remove_circle),
                    color: Colors.red,
                  ),
                ],
              ),
            ),
          )
          .values
          .toList();
    }
    return [];
  }
}
