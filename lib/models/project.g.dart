// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Project _$ProjectFromJson(Map<String, dynamic> json) => Project(
      name: json['name'] as String,
      description: json['description'] as String,
      owner: const FirestoreReference()
          .fromJson(json['owner'] as DocumentReference<Map<String, dynamic>>),
      imageUrl: json['imageUrl'] as String?,
      isPrivate: json['isPrivate'] as bool,
      isPublished: json['isPublished'] as bool,
      entryCode: json['entryCode'] as String?,
      allowedUsers: (json['allowedUsers'] as List<dynamic>)
          .map((e) => const FirestoreReference()
              .fromJson(e as DocumentReference<Map<String, dynamic>>))
          .toList(),
      blacklistedUsers: (json['blacklistedUsers'] as List<dynamic>)
          .map((e) => const FirestoreReference()
              .fromJson(e as DocumentReference<Map<String, dynamic>>))
          .toList(),
      fields: (json['fields'] as List<dynamic>)
          .map((e) => ProjectField.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProjectToJson(Project instance) => <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'owner': const FirestoreReference().toJson(instance.owner),
      'imageUrl': instance.imageUrl,
      'isPrivate': instance.isPrivate,
      'isPublished': instance.isPublished,
      'entryCode': instance.entryCode,
      'allowedUsers':
          instance.allowedUsers.map(const FirestoreReference().toJson).toList(),
      'blacklistedUsers': instance.blacklistedUsers
          .map(const FirestoreReference().toJson)
          .toList(),
      'fields': instance.fields.map((e) => e.toJson()).toList(),
    };

ProjectField _$ProjectFieldFromJson(Map<String, dynamic> json) => ProjectField(
      name: json['name'] as String,
      type: $enumDecode(_$ProjectFieldTypeEnumMap, json['type']),
      helperText: json['helperText'] as String?,
      validators: (json['validators'] as List<dynamic>)
          .map((e) => ProjectFieldValidator.fromJson(e as Map<String, dynamic>))
          .toList(),
      options:
          (json['options'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ProjectFieldToJson(ProjectField instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': _$ProjectFieldTypeEnumMap[instance.type],
      'helperText': instance.helperText,
      'validators': instance.validators.map((e) => e.toJson()).toList(),
      'options': instance.options,
    };

const _$ProjectFieldTypeEnumMap = {
  ProjectFieldType.string: 'STRING',
  ProjectFieldType.numeric: 'NUMERIC',
  ProjectFieldType.location: 'LOCATION',
  ProjectFieldType.locationSeries: 'LOCATION_SERIES',
  ProjectFieldType.motionSensorSeries: 'MOTION_SENSOR_SERIES',
  ProjectFieldType.ambientSensorSeries: 'AMBIENT_SENSOR_SERIES',
  ProjectFieldType.image: 'IMAGE',
  ProjectFieldType.video: 'VIDEO',
  ProjectFieldType.audio: 'AUDIO',
  ProjectFieldType.text: 'TEXT',
  ProjectFieldType.boolean: 'BOOLEAN',
  ProjectFieldType.dateTime: 'DATETIME',
  ProjectFieldType.date: 'DATE',
  ProjectFieldType.time: 'TIME',
  ProjectFieldType.dropdown: 'DROPDOWN',
  ProjectFieldType.radio: 'RADIO',
  ProjectFieldType.checkBoxes: 'CHECKBOXES',
};

ProjectFieldValidator _$ProjectFieldValidatorFromJson(
        Map<String, dynamic> json) =>
    ProjectFieldValidator(
      type: $enumDecode(_$ProjectFieldValidatorTypeEnumMap, json['type']),
      value: json['value'],
    );

Map<String, dynamic> _$ProjectFieldValidatorToJson(
        ProjectFieldValidator instance) =>
    <String, dynamic>{
      'type': _$ProjectFieldValidatorTypeEnumMap[instance.type],
      'value': instance.value,
    };

const _$ProjectFieldValidatorTypeEnumMap = {
  ProjectFieldValidatorType.required: 'REQUIRED',
  ProjectFieldValidatorType.email: 'EMAIL',
  ProjectFieldValidatorType.integer: 'INTEGER',
  ProjectFieldValidatorType.match: 'MATCH',
  ProjectFieldValidatorType.max: 'MAX',
  ProjectFieldValidatorType.min: 'MIN',
  ProjectFieldValidatorType.maxLength: 'MAXLENGTH',
  ProjectFieldValidatorType.minLength: 'MINLENGTH',
  ProjectFieldValidatorType.url: 'URL',
};
