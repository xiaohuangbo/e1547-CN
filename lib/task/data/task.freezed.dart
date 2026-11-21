// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Task {

 int get id; TaskAction get action; int get postId; TaskStatus get status; String? get error; DateTime get createdAt; DateTime? get completedAt; TaskMetadata? get metadata;
/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskCopyWith<Task> get copyWith => _$TaskCopyWithImpl<Task>(this as Task, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Task&&(identical(other.id, id) || other.id == id)&&(identical(other.action, action) || other.action == action)&&(identical(other.postId, postId) || other.postId == postId)&&(identical(other.status, status) || other.status == status)&&(identical(other.error, error) || other.error == error)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.metadata, metadata) || other.metadata == metadata));
}


@override
int get hashCode => Object.hash(runtimeType,id,action,postId,status,error,createdAt,completedAt,metadata);

@override
String toString() {
  return 'Task(id: $id, action: $action, postId: $postId, status: $status, error: $error, createdAt: $createdAt, completedAt: $completedAt, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class $TaskCopyWith<$Res>  {
  factory $TaskCopyWith(Task value, $Res Function(Task) _then) = _$TaskCopyWithImpl;
@useResult
$Res call({
 int id, TaskAction action, int postId, TaskStatus status, String? error, DateTime createdAt, DateTime? completedAt, TaskMetadata? metadata
});


$TaskMetadataCopyWith<$Res>? get metadata;

}
/// @nodoc
class _$TaskCopyWithImpl<$Res>
    implements $TaskCopyWith<$Res> {
  _$TaskCopyWithImpl(this._self, this._then);

  final Task _self;
  final $Res Function(Task) _then;

/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? action = null,Object? postId = null,Object? status = null,Object? error = freezed,Object? createdAt = null,Object? completedAt = freezed,Object? metadata = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as TaskAction,postId: null == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TaskStatus,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as TaskMetadata?,
  ));
}
/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskMetadataCopyWith<$Res>? get metadata {
    if (_self.metadata == null) {
    return null;
  }

  return $TaskMetadataCopyWith<$Res>(_self.metadata!, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}
}



/// @nodoc


class _Task implements Task {
  const _Task({required this.id, required this.action, required this.postId, required this.status, required this.error, required this.createdAt, required this.completedAt, required this.metadata});
  

@override final  int id;
@override final  TaskAction action;
@override final  int postId;
@override final  TaskStatus status;
@override final  String? error;
@override final  DateTime createdAt;
@override final  DateTime? completedAt;
@override final  TaskMetadata? metadata;

/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskCopyWith<_Task> get copyWith => __$TaskCopyWithImpl<_Task>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Task&&(identical(other.id, id) || other.id == id)&&(identical(other.action, action) || other.action == action)&&(identical(other.postId, postId) || other.postId == postId)&&(identical(other.status, status) || other.status == status)&&(identical(other.error, error) || other.error == error)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.metadata, metadata) || other.metadata == metadata));
}


@override
int get hashCode => Object.hash(runtimeType,id,action,postId,status,error,createdAt,completedAt,metadata);

@override
String toString() {
  return 'Task(id: $id, action: $action, postId: $postId, status: $status, error: $error, createdAt: $createdAt, completedAt: $completedAt, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$TaskCopyWith<$Res> implements $TaskCopyWith<$Res> {
  factory _$TaskCopyWith(_Task value, $Res Function(_Task) _then) = __$TaskCopyWithImpl;
@override @useResult
$Res call({
 int id, TaskAction action, int postId, TaskStatus status, String? error, DateTime createdAt, DateTime? completedAt, TaskMetadata? metadata
});


@override $TaskMetadataCopyWith<$Res>? get metadata;

}
/// @nodoc
class __$TaskCopyWithImpl<$Res>
    implements _$TaskCopyWith<$Res> {
  __$TaskCopyWithImpl(this._self, this._then);

  final _Task _self;
  final $Res Function(_Task) _then;

/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? action = null,Object? postId = null,Object? status = null,Object? error = freezed,Object? createdAt = null,Object? completedAt = freezed,Object? metadata = freezed,}) {
  return _then(_Task(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as TaskAction,postId: null == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TaskStatus,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as TaskMetadata?,
  ));
}

/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskMetadataCopyWith<$Res>? get metadata {
    if (_self.metadata == null) {
    return null;
  }

  return $TaskMetadataCopyWith<$Res>(_self.metadata!, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}
}

/// @nodoc
mixin _$TaskRequest {

 TaskAction get action; int get postId; TaskMetadata? get metadata;
/// Create a copy of TaskRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskRequestCopyWith<TaskRequest> get copyWith => _$TaskRequestCopyWithImpl<TaskRequest>(this as TaskRequest, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskRequest&&(identical(other.action, action) || other.action == action)&&(identical(other.postId, postId) || other.postId == postId)&&(identical(other.metadata, metadata) || other.metadata == metadata));
}


@override
int get hashCode => Object.hash(runtimeType,action,postId,metadata);

@override
String toString() {
  return 'TaskRequest(action: $action, postId: $postId, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class $TaskRequestCopyWith<$Res>  {
  factory $TaskRequestCopyWith(TaskRequest value, $Res Function(TaskRequest) _then) = _$TaskRequestCopyWithImpl;
@useResult
$Res call({
 TaskAction action, int postId, TaskMetadata? metadata
});


$TaskMetadataCopyWith<$Res>? get metadata;

}
/// @nodoc
class _$TaskRequestCopyWithImpl<$Res>
    implements $TaskRequestCopyWith<$Res> {
  _$TaskRequestCopyWithImpl(this._self, this._then);

  final TaskRequest _self;
  final $Res Function(TaskRequest) _then;

/// Create a copy of TaskRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? action = null,Object? postId = null,Object? metadata = freezed,}) {
  return _then(_self.copyWith(
action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as TaskAction,postId: null == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as int,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as TaskMetadata?,
  ));
}
/// Create a copy of TaskRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskMetadataCopyWith<$Res>? get metadata {
    if (_self.metadata == null) {
    return null;
  }

  return $TaskMetadataCopyWith<$Res>(_self.metadata!, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}
}



/// @nodoc


class _TaskRequest implements TaskRequest {
  const _TaskRequest({required this.action, required this.postId, this.metadata});
  

@override final  TaskAction action;
@override final  int postId;
@override final  TaskMetadata? metadata;

/// Create a copy of TaskRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskRequestCopyWith<_TaskRequest> get copyWith => __$TaskRequestCopyWithImpl<_TaskRequest>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskRequest&&(identical(other.action, action) || other.action == action)&&(identical(other.postId, postId) || other.postId == postId)&&(identical(other.metadata, metadata) || other.metadata == metadata));
}


@override
int get hashCode => Object.hash(runtimeType,action,postId,metadata);

@override
String toString() {
  return 'TaskRequest(action: $action, postId: $postId, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$TaskRequestCopyWith<$Res> implements $TaskRequestCopyWith<$Res> {
  factory _$TaskRequestCopyWith(_TaskRequest value, $Res Function(_TaskRequest) _then) = __$TaskRequestCopyWithImpl;
@override @useResult
$Res call({
 TaskAction action, int postId, TaskMetadata? metadata
});


@override $TaskMetadataCopyWith<$Res>? get metadata;

}
/// @nodoc
class __$TaskRequestCopyWithImpl<$Res>
    implements _$TaskRequestCopyWith<$Res> {
  __$TaskRequestCopyWithImpl(this._self, this._then);

  final _TaskRequest _self;
  final $Res Function(_TaskRequest) _then;

/// Create a copy of TaskRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? action = null,Object? postId = null,Object? metadata = freezed,}) {
  return _then(_TaskRequest(
action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as TaskAction,postId: null == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as int,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as TaskMetadata?,
  ));
}

/// Create a copy of TaskRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskMetadataCopyWith<$Res>? get metadata {
    if (_self.metadata == null) {
    return null;
  }

  return $TaskMetadataCopyWith<$Res>(_self.metadata!, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}
}


/// @nodoc
mixin _$TaskMetadata {

 String? get previewUrl; String? get fileUrl; String? get fileName;
/// Create a copy of TaskMetadata
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskMetadataCopyWith<TaskMetadata> get copyWith => _$TaskMetadataCopyWithImpl<TaskMetadata>(this as TaskMetadata, _$identity);

  /// Serializes this TaskMetadata to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskMetadata&&(identical(other.previewUrl, previewUrl) || other.previewUrl == previewUrl)&&(identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl)&&(identical(other.fileName, fileName) || other.fileName == fileName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,previewUrl,fileUrl,fileName);

@override
String toString() {
  return 'TaskMetadata(previewUrl: $previewUrl, fileUrl: $fileUrl, fileName: $fileName)';
}


}

/// @nodoc
abstract mixin class $TaskMetadataCopyWith<$Res>  {
  factory $TaskMetadataCopyWith(TaskMetadata value, $Res Function(TaskMetadata) _then) = _$TaskMetadataCopyWithImpl;
@useResult
$Res call({
 String? previewUrl, String? fileUrl, String? fileName
});




}
/// @nodoc
class _$TaskMetadataCopyWithImpl<$Res>
    implements $TaskMetadataCopyWith<$Res> {
  _$TaskMetadataCopyWithImpl(this._self, this._then);

  final TaskMetadata _self;
  final $Res Function(TaskMetadata) _then;

/// Create a copy of TaskMetadata
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? previewUrl = freezed,Object? fileUrl = freezed,Object? fileName = freezed,}) {
  return _then(_self.copyWith(
previewUrl: freezed == previewUrl ? _self.previewUrl : previewUrl // ignore: cast_nullable_to_non_nullable
as String?,fileUrl: freezed == fileUrl ? _self.fileUrl : fileUrl // ignore: cast_nullable_to_non_nullable
as String?,fileName: freezed == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}



/// @nodoc
@JsonSerializable()

class _TaskMetadata implements TaskMetadata {
  const _TaskMetadata({this.previewUrl, this.fileUrl, this.fileName});
  factory _TaskMetadata.fromJson(Map<String, dynamic> json) => _$TaskMetadataFromJson(json);

@override final  String? previewUrl;
@override final  String? fileUrl;
@override final  String? fileName;

/// Create a copy of TaskMetadata
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskMetadataCopyWith<_TaskMetadata> get copyWith => __$TaskMetadataCopyWithImpl<_TaskMetadata>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskMetadataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskMetadata&&(identical(other.previewUrl, previewUrl) || other.previewUrl == previewUrl)&&(identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl)&&(identical(other.fileName, fileName) || other.fileName == fileName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,previewUrl,fileUrl,fileName);

@override
String toString() {
  return 'TaskMetadata(previewUrl: $previewUrl, fileUrl: $fileUrl, fileName: $fileName)';
}


}

/// @nodoc
abstract mixin class _$TaskMetadataCopyWith<$Res> implements $TaskMetadataCopyWith<$Res> {
  factory _$TaskMetadataCopyWith(_TaskMetadata value, $Res Function(_TaskMetadata) _then) = __$TaskMetadataCopyWithImpl;
@override @useResult
$Res call({
 String? previewUrl, String? fileUrl, String? fileName
});




}
/// @nodoc
class __$TaskMetadataCopyWithImpl<$Res>
    implements _$TaskMetadataCopyWith<$Res> {
  __$TaskMetadataCopyWithImpl(this._self, this._then);

  final _TaskMetadata _self;
  final $Res Function(_TaskMetadata) _then;

/// Create a copy of TaskMetadata
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? previewUrl = freezed,Object? fileUrl = freezed,Object? fileName = freezed,}) {
  return _then(_TaskMetadata(
previewUrl: freezed == previewUrl ? _self.previewUrl : previewUrl // ignore: cast_nullable_to_non_nullable
as String?,fileUrl: freezed == fileUrl ? _self.fileUrl : fileUrl // ignore: cast_nullable_to_non_nullable
as String?,fileName: freezed == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
