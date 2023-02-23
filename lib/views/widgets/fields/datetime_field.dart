import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:research_buddy/models/project.dart';
import 'package:research_buddy/views/widgets/fields/abstract_field.dart';

class DateTimeFieldWidget extends AbstractFieldWidget {
  const DateTimeFieldWidget(
      {Key? key, required int index, required ProjectField field})
      : super(key: key, index: index, field: field);

  @override
  Widget build(BuildContext context) {
    return FormBuilderDateTimePicker(
      name: fieldKey,
      inputType: InputType.both,
      decoration: InputDecoration(
        label: Text(field.name),
        helperText: field.helperText,
        border: const OutlineInputBorder(),
      ),
      validator: buildValidators(context),
    );
  }
}
