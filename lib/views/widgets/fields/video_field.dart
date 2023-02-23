import 'package:flutter/material.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:research_buddy/models/project.dart';
import 'package:research_buddy/views/widgets/fields/abstract_field.dart';

class VideoFieldWidget extends AbstractFieldWidget {
  const VideoFieldWidget(
      {Key? key, required int index, required ProjectField field})
      : super(key: key, index: index, field: field);

  @override
  Widget build(BuildContext context) {
    return FormBuilderFilePicker(
      name: fieldKey,
      decoration: InputDecoration(
        label: Text(field.name),
        helperText: field.helperText,
        border: const OutlineInputBorder(),
      ),
      type: FileType.video,
      maxFiles: 1,
      previewImages: true,
      validator: buildValidators(context),
    );
  }
}
