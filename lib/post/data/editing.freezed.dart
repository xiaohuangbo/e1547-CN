// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'editing.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PostEdit {

 Post get post; String? get editReason; Rating get rating; String get description; int? get parentId; List<String> get sources; List<String> get tags;
/// Create a copy of PostEdit
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostEditCopyWith<PostEdit> get copyWith => _$PostEditCopyWithImpl<PostEdit>(this as PostEdit, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostEdit&&(identical(other.post, post) || other.post == post)&&(identical(other.editReason, editReason) || other.editReason == editReason)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.description, description) || other.description == description)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&const DeepCollectionEquality().equals(other.sources, sources)&&const DeepCollectionEquality().equals(other.tags, tags));
}


@override
int get hashCode => Object.hash(runtimeType,post,editReason,rating,description,parentId,const DeepCollectionEquality().hash(sources),const DeepCollectionEquality().hash(tags));

@override
String toString() {
  return 'PostEdit(post: $post, editReason: $editReason, rating: $rating, description: $description, parentId: $parentId, sources: $sources, tags: $tags)';
}


}

/// @nodoc
abstract mixin class $PostEditCopyWith<$Res>  {
  factory $PostEditCopyWith(PostEdit value, $Res Function(PostEdit) _then) = _$PostEditCopyWithImpl;
@useResult
$Res call({
 Post post, String? editReason, Rating rating, String description, int? parentId, List<String> sources, List<String> tags
});


$PostCopyWith<$Res> get post;

}
/// @nodoc
class _$PostEditCopyWithImpl<$Res>
    implements $PostEditCopyWith<$Res> {
  _$PostEditCopyWithImpl(this._self, this._then);

  final PostEdit _self;
  final $Res Function(PostEdit) _then;

/// Create a copy of PostEdit
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? post = null,Object? editReason = freezed,Object? rating = null,Object? description = null,Object? parentId = freezed,Object? sources = null,Object? tags = null,}) {
  return _then(_self.copyWith(
post: null == post ? _self.post : post // ignore: cast_nullable_to_non_nullable
as Post,editReason: freezed == editReason ? _self.editReason : editReason // ignore: cast_nullable_to_non_nullable
as String?,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as Rating,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as int?,sources: null == sources ? _self.sources : sources // ignore: cast_nullable_to_non_nullable
as List<String>,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}
/// Create a copy of PostEdit
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostCopyWith<$Res> get post {
  
  return $PostCopyWith<$Res>(_self.post, (value) {
    return _then(_self.copyWith(post: value));
  });
}
}


/// @nodoc


class _PostEdit extends PostEdit {
  const _PostEdit({required this.post, this.editReason, required this.rating, required this.description, this.parentId, required final  List<String> sources, required final  List<String> tags}): _sources = sources,_tags = tags,super._();
  

@override final  Post post;
@override final  String? editReason;
@override final  Rating rating;
@override final  String description;
@override final  int? parentId;
 final  List<String> _sources;
@override List<String> get sources {
  if (_sources is EqualUnmodifiableListView) return _sources;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sources);
}

 final  List<String> _tags;
@override List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}


/// Create a copy of PostEdit
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostEditCopyWith<_PostEdit> get copyWith => __$PostEditCopyWithImpl<_PostEdit>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostEdit&&(identical(other.post, post) || other.post == post)&&(identical(other.editReason, editReason) || other.editReason == editReason)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.description, description) || other.description == description)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&const DeepCollectionEquality().equals(other._sources, _sources)&&const DeepCollectionEquality().equals(other._tags, _tags));
}


@override
int get hashCode => Object.hash(runtimeType,post,editReason,rating,description,parentId,const DeepCollectionEquality().hash(_sources),const DeepCollectionEquality().hash(_tags));

@override
String toString() {
  return 'PostEdit(post: $post, editReason: $editReason, rating: $rating, description: $description, parentId: $parentId, sources: $sources, tags: $tags)';
}


}

/// @nodoc
abstract mixin class _$PostEditCopyWith<$Res> implements $PostEditCopyWith<$Res> {
  factory _$PostEditCopyWith(_PostEdit value, $Res Function(_PostEdit) _then) = __$PostEditCopyWithImpl;
@override @useResult
$Res call({
 Post post, String? editReason, Rating rating, String description, int? parentId, List<String> sources, List<String> tags
});


@override $PostCopyWith<$Res> get post;

}
/// @nodoc
class __$PostEditCopyWithImpl<$Res>
    implements _$PostEditCopyWith<$Res> {
  __$PostEditCopyWithImpl(this._self, this._then);

  final _PostEdit _self;
  final $Res Function(_PostEdit) _then;

/// Create a copy of PostEdit
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? post = null,Object? editReason = freezed,Object? rating = null,Object? description = null,Object? parentId = freezed,Object? sources = null,Object? tags = null,}) {
  return _then(_PostEdit(
post: null == post ? _self.post : post // ignore: cast_nullable_to_non_nullable
as Post,editReason: freezed == editReason ? _self.editReason : editReason // ignore: cast_nullable_to_non_nullable
as String?,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as Rating,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as int?,sources: null == sources ? _self._sources : sources // ignore: cast_nullable_to_non_nullable
as List<String>,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

/// Create a copy of PostEdit
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostCopyWith<$Res> get post {
  
  return $PostCopyWith<$Res>(_self.post, (value) {
    return _then(_self.copyWith(post: value));
  });
}
}

// dart format on
