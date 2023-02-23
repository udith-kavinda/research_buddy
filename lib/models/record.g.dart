// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Record _$RecordFromJson(Map<String, dynamic> json) => Record(
      user: const FirestoreReference()
          .fromJson(json['user'] as DocumentReference<Map<String, dynamic>>),
      project: const FirestoreReference()
          .fromJson(json['project'] as DocumentReference<Map<String, dynamic>>),
      timestamp:
          const FirestoreTimestamp().fromJson(json['timestamp'] as Timestamp),
      status: $enumDecode(_$RecordStatusEnumMap, json['status']),
      fields: json['fields'] as List<dynamic>,
    );

Map<String, dynamic> _$RecordToJson(Record instance) => <String, dynamic>{
      'user': const FirestoreReference().toJson(instance.user),
      'project': const FirestoreReference().toJson(instance.project),
      'timestamp': const FirestoreTimestamp().toJson(instance.timestamp),
      'status': _$RecordStatusEnumMap[instance.status],
      'fields': instance.fields,
    };

const _$RecordStatusEnumMap = {
  RecordStatus.done: 'DONE',
  RecordStatus.uploading: 'UPLOADING',
  RecordStatus.failed: 'FAILED',
};
