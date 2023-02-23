import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:research_buddy/models/project.dart';
import 'package:research_buddy/views/helpers/location_fetcher.dart';
import 'package:research_buddy/views/widgets/fields/abstract_series_field.dart';

class LocationSeriesFieldWidget extends AbstractSeriesFieldWidget<Position> {
  const LocationSeriesFieldWidget(
      {Key? key, required int index, required ProjectField field})
      : super(key: key, index: index, field: field);

  @override
  Future<Position?> collect() {
    return fetchLocation();
  }
}
