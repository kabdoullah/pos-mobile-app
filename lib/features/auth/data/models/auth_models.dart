import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_models.freezed.dart';
part 'auth_models.g.dart';

/// Payload de requête pour l'inscription.
@freezed
sealed class RegisterRequestDto with _$RegisterRequestDto {
  /// Crée un RegisterRequestDto.
  const factory RegisterRequestDto({
    @JsonKey(name: 'phone_number') required String phoneNumber,
    required String password,
    String? email,
  }) = _RegisterRequestDto;

  factory RegisterRequestDto.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestDtoFromJson(json);
}

/// Réponse après une inscription réussie.
@freezed
sealed class RegisterResponseDto with _$RegisterResponseDto {
  /// Crée un RegisterResponseDto.
  const factory RegisterResponseDto({
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'phone_number') required String phoneNumber,
    required String message,
  }) = _RegisterResponseDto;

  factory RegisterResponseDto.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseDtoFromJson(json);
}

/// Payload de requête pour la connexion.
@freezed
sealed class LoginRequestDto with _$LoginRequestDto {
  /// Crée un LoginRequestDto.
  const factory LoginRequestDto({
    @JsonKey(name: 'phone_number') required String phoneNumber,
    required String password,
  }) = _LoginRequestDto;

  factory LoginRequestDto.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestDtoFromJson(json);
}

/// Réponse contenant l'access token et le refresh token.
@freezed
sealed class TokenResponseDto with _$TokenResponseDto {
  /// Crée un TokenResponseDto.
  const factory TokenResponseDto({
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'refresh_token') required String refreshToken,
    @JsonKey(name: 'token_type') required String tokenType,
    @JsonKey(name: 'expires_in') required int expiresIn,
  }) = _TokenResponseDto;

  factory TokenResponseDto.fromJson(Map<String, dynamic> json) =>
      _$TokenResponseDtoFromJson(json);
}

/// Payload de requête pour une demande de réinitialisation du mot de passe.
@freezed
sealed class ForgotPasswordRequestDto with _$ForgotPasswordRequestDto {
  /// Crée un ForgotPasswordRequestDto.
  const factory ForgotPasswordRequestDto({required String email}) =
      _ForgotPasswordRequestDto;

  factory ForgotPasswordRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordRequestDtoFromJson(json);
}

/// Payload de requête pour confirmer la réinitialisation du mot de passe.
@freezed
sealed class ResetPasswordRequestDto with _$ResetPasswordRequestDto {
  /// Crée un ResetPasswordRequestDto.
  const factory ResetPasswordRequestDto({
    required String token,
    @JsonKey(name: 'new_password') required String newPassword,
  }) = _ResetPasswordRequestDto;

  factory ResetPasswordRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordRequestDtoFromJson(json);
}

/// Payload de requête pour le rafraîchissement du token.
@freezed
sealed class RefreshRequestDto with _$RefreshRequestDto {
  /// Crée un RefreshRequestDto.
  const factory RefreshRequestDto({
    @JsonKey(name: 'refresh_token') required String refreshToken,
  }) = _RefreshRequestDto;

  factory RefreshRequestDto.fromJson(Map<String, dynamic> json) =>
      _$RefreshRequestDtoFromJson(json);
}
