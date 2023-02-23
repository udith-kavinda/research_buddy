import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:research_buddy/models/project.dart';
import 'package:research_buddy/views/helpers/location_fetcher.dart';
import 'package:research_buddy/views/helpers/snackbar_messages.dart';
import 'package:research_buddy/views/widgets/fields/abstract_field.dart';

class LocationFieldWidget extends AbstractFieldWidget {
  const LocationFieldWidget(
      {Key? key, required int index, required ProjectField field})
      : super(key: key, index: index, field: field);

  @override
  Widget build(BuildContext context) {
    return FormBuilderField(
      name: fieldKey,
      validator: buildValidators(context),
      builder: (FormFieldState<Position?> fieldState) {
        return InputDecorator(
          decoration: InputDecoration(
            label: Text(field.name),
            helperText: field.helperText,
            border: const OutlineInputBorder(),
          ),
          child: Row(
            children: [
              ElevatedButton(
                child: const Text('Fetch location'),
                onPressed: () => _handleClick(context, fieldState),
              ),
              if (fieldState.value != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Latitude: ${fieldState.value?.latitude}'),
                      Text('Longitude: ${fieldState.value?.longitude}'),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _handleClick(
    BuildContext context,
    FormFieldState<Position?> fieldState,
  ) async {
    try {
      final position = await fetchLocation();
      fieldState.didChange(position);
    } catch (e) {
      showErrorMessage(context, e.toString());
      fieldState.didChange(null);
    }
  }
}
