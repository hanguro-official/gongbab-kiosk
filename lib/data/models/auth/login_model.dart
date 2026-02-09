import 'package:json_annotation/json_annotation.dart';
import 'package:gongbab/data/models/auth/restaurant_model.dart';
import 'package:gongbab/domain/entities/auth/login_entity.dart';

part 'login_model.g.dart';

@JsonSerializable()
class LoginModel {
  final String accessToken;
  final String refreshToken;
  final RestaurantModel restaurant;

  LoginModel({
    required this.accessToken,
    required this.refreshToken,
    required this.restaurant,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => _$LoginModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginModelToJson(this);

  LoginEntity toEntity() {
    return LoginEntity(
      accessToken: accessToken,
      refreshToken: refreshToken,
      restaurant: restaurant.toEntity(),
    );
  }
}
