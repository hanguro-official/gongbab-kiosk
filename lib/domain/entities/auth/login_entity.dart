import 'package:equatable/equatable.dart';
import 'package:gongbab/domain/entities/auth/restaurant_entity.dart';

class LoginEntity extends Equatable {
  final String accessToken;
  final String refreshToken;
  final RestaurantEntity? restaurant;

  const LoginEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.restaurant,
  });

  @override
  List<Object?> get props => [accessToken, refreshToken, restaurant];
}
