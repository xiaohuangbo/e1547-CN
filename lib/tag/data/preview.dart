import 'package:freezed_annotation/freezed_annotation.dart';

part 'preview.freezed.dart';
part 'preview.g.dart';

@freezed
abstract class TagPreview with _$TagPreview {
  const factory TagPreview({
    int? id,
    required String name,
    int? category,
    int? postCount,
    List<String>? implies,
    String? alias,
    String? resolved,
  }) = _TagPreview;

  factory TagPreview.fromJson(Map<String, dynamic> json) =>
      _$TagPreviewFromJson(json);
}
