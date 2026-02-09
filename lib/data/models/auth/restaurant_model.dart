import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gongbab/domain/entities/auth/restaurant_entity.dart';

part 'restaurant_model.freezed.dart';
part 'restaurant_model.g.dart';

@freezed
class RestaurantModel with _$RestaurantModel {
  const factory RestaurantModel({
    required int id,
    required String name,
  }) = _RestaurantModel;

  factory RestaurantModel.fromJson(Map<String, dynamic> json) => _$RestaurantModelFromJson(json);

  RestaurantEntity toEntity() {
    return RestaurantEntity(
      id: id,
      name: name,
    );
  }
}
