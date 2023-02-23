import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:research_buddy/models/project.dart';
import 'package:research_buddy/views/widgets/fields/abstract_field.dart';

class NumericFieldWidget extends AbstractFieldWidget {
  const NumericFieldWidget(
      {Key? key, required int index, required ProjectField field})
      : super(key: key, index: index, field: field);

  @override
  Widget build(BuildContext context) {
    final validators = [FormBuilderValidators.numeric(context)];
    final builtValidators = buildValidators<String>(context);
    if (builtValidators != null) {
      validators.add(builtValidators);
    }

    return FormBuilderTextField(
      name: fieldKey,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        label: Text(field.name),
        helperText: field.helperText,
        border: const OutlineInputBorder(),
      ),
      validator: FormBuilderValidators.compose(validators),
    );
  }
}
