import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:research_buddy/models/project.dart';
import 'package:research_buddy/views/widgets/fields/abstract_field.dart';

class CheckBoxesFieldWidget extends AbstractFieldWidget {
  const CheckBoxesFieldWidget(
      {Key? key, required int index, required ProjectField field})
      : super(key: key, index: index, field: field);

  @override
  Widget build(BuildContext context) {
    return FormBuilderCheckboxGroup(
      name: fieldKey,
      decoration: InputDecoration(
        label: Text(field.name),
        helperText: field.helperText,
        border: const OutlineInputBorder(),
      ),
      validator: buildValidators<List<int>>(context),
      options: [
        for (int i = 0; i < (field.options?.length ?? 0); i++)
          FormBuilderFieldOption<int>(
            value: i,
            child: Text(field.options?[i] ?? 'Not provided'),
          )
      ],
    );
  }
}
