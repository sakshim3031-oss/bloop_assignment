import 'package:freezed_annotation/freezed_annotation.dart';

part 'collection.freezed.dart';
part 'collection.g.dart';

@freezed
class Collection with _$Collection {
  const factory Collection({
    required String id,
    required String title,
    required String description,
    String? coverImageUrl,
    required String creatorId,
    required bool isPremium,
    required int sectionCount,
    @JsonKey(fromJson: DateTime.parse, toJson: _dateToIso)
    required DateTime createdAt,
  }) = _Collection;

  factory Collection.fromJson(Map<String, dynamic> json) =>
      _$CollectionFromJson(json);
}

String _dateToIso(DateTime date) => date.toIso8601String();