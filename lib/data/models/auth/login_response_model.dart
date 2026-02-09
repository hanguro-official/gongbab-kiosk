import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gongbab/data/models/auth/restaurant_model.dart';
import 'package:gongbab/domain/entities/auth/login_entity.dart';

part 'login_response_model.freezed.dart';
part 'login_response_model.g.dart';

@freezed
class LoginResponseModel with _$LoginResponseModel {
  const factory LoginResponseModel({
    required String accessToken,
    required String refreshToken,
    required RestaurantModel restaurant,
  }) = _LoginResponseModel;

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) => _$LoginResponseModelFromJson(json);

  LoginEntity toEntity() {
    return LoginEntity(
      accessToken: accessToken,
      refreshToken: refreshToken,
      restaurant: restaurant.toEntity(),
    );
  }
}
