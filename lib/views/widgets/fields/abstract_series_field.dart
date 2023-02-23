import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:research_buddy/models/project.dart';
import 'package:research_buddy/views/helpers/snackbar_messages.dart';
import 'package:research_buddy/views/widgets/fields/base_field_utils.dart';

abstract class AbstractSeriesFieldWidget<T> extends StatefulWidget {
  final int index;
  final ProjectField field;

  const AbstractSeriesFieldWidget(
      {Key? key, required this.index, required this.field})
      : super(key: key);

  @override
  State<AbstractSeriesFieldWidget<T>> createState() =>
      _AbstractSeriesFieldWidgetState<T>();

  Future<T?> collect();
}

class _AbstractSeriesFieldWidgetState<T>
    extends State<AbstractSeriesFieldWidget<T>> {
  Timer? timer;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  String get fieldKey => widget.index.toString();

  @override
  Widget build(BuildContext context) {
    return FormBuilderField(
      name: fieldKey,
      validator: BaseFieldUtils.buildValidators(context, widget.field),
      builder: (FormFieldState<List<SeriesDataPoint<T>>?> fieldState) {
        final isRecording = timer != null;

        return InputDecorator(
          decoration: InputDecoration(
            label: Text(widget.field.name),
            helperText: widget.field.helperText,
            border: const OutlineInputBorder(),
          ),
          child: Row(
            children: [
              // Stop Button - when recording
              if (isRecording)
                ElevatedButton(
                  child: const Text('Stop'),
                  onPressed: () => _stopRecording(context, fieldState),
                ),
              // Start Button - when not recording
              if (!isRecording)
                ElevatedButton(
                  child: const Text('Start'),
                  onPressed: () => _startRecording(context, fieldState),
                ),
              // Recording text - when recording but not recorded yet
              if (isRecording && fieldState.value == null)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Preparing to record'),
                ),
              // Recording text - when recording
              if (isRecording && fieldState.value != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      Text('Recording... Records: ${fieldState.value?.length}'),
                ),
              // Recording text - when not recording
              if (!isRecording && fieldState.value != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Records: ${fieldState.value?.length}'),
                ),
            ],
          ),
        );
      },
    );
  }

  void _startRecording(
    BuildContext context,
    FormFieldState<List<SeriesDataPoint<T>>?> fieldState,
  ) async {
    try {
      setState(() {
        timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
          if (mounted) {
            final value = await widget.collect();
            if (mounted && value != null) {
              setState(() {
                final dataPoint = SeriesDataPoint<T>(value);
                fieldState.didChange([...fieldState.value ?? [], dataPoint]);
              });
            }
          }
        });
      });
    } catch (e) {
      showErrorMessage(context, e.toString());
      fieldState.didChange(null);
    }
  }

  void _stopRecording(
    BuildContext context,
    FormFieldState<List<SeriesDataPoint<T>>?> fieldState,
  ) async {
    try {
      setState(() {
        timer?.cancel();
        timer = null;
      });
    } catch (e) {
      showErrorMessage(context, e.toString());
      fieldState.didChange(null);
    }
  }
}
