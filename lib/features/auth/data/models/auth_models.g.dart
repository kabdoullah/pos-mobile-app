// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RegisterRequestDto _$RegisterRequestDtoFromJson(Map<String, dynamic> json) =>
    _RegisterRequestDto(
      phoneNumber: json['phone_number'] as String,
      password: json['password'] as String,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$RegisterRequestDtoToJson(_RegisterRequestDto instance) =>
    <String, dynamic>{
      'phone_number': instance.phoneNumber,
      'password': instance.password,
      'email': instance.email,
    };

_RegisterResponseDto _$RegisterResponseDtoFromJson(Map<String, dynamic> json) =>
    _RegisterResponseDto(
      userId: json['user_id'] as String,
      phoneNumber: json['phone_number'] as String,
      message: json['message'] as String,
    );

Map<String, dynamic> _$RegisterResponseDtoToJson(
  _RegisterResponseDto instance,
) => <String, dynamic>{
  'user_id': instance.userId,
  'phone_number': instance.phoneNumber,
  'message': instance.message,
};

_LoginRequestDto _$LoginRequestDtoFromJson(Map<String, dynamic> json) =>
    _LoginRequestDto(
      phoneNumber: json['phone_number'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$LoginRequestDtoToJson(_LoginRequestDto instance) =>
    <String, dynamic>{
      'phone_number': instance.phoneNumber,
      'password': instance.password,
    };

_TokenResponseDto _$TokenResponseDtoFromJson(Map<String, dynamic> json) =>
    _TokenResponseDto(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      tokenType: json['token_type'] as String,
      expiresIn: (json['expires_in'] as num).toInt(),
    );

Map<String, dynamic> _$TokenResponseDtoToJson(_TokenResponseDto instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'token_type': instance.tokenType,
      'expires_in': instance.expiresIn,
    };

_ForgotPasswordRequestDto _$ForgotPasswordRequestDtoFromJson(
  Map<String, dynamic> json,
) => _ForgotPasswordRequestDto(email: json['email'] as String);

Map<String, dynamic> _$ForgotPasswordRequestDtoToJson(
  _ForgotPasswordRequestDto instance,
) => <String, dynamic>{'email': instance.email};

_ResetPasswordRequestDto _$ResetPasswordRequestDtoFromJson(
  Map<String, dynamic> json,
) => _ResetPasswordRequestDto(
  token: json['token'] as String,
  newPassword: json['new_password'] as String,
);

Map<String, dynamic> _$ResetPasswordRequestDtoToJson(
  _ResetPasswordRequestDto instance,
) => <String, dynamic>{
  'token': instance.token,
  'new_password': instance.newPassword,
};

_RefreshRequestDto _$RefreshRequestDtoFromJson(Map<String, dynamic> json) =>
    _RefreshRequestDto(refreshToken: json['refresh_token'] as String);

Map<String, dynamic> _$RefreshRequestDtoToJson(_RefreshRequestDto instance) =>
    <String, dynamic>{'refresh_token': instance.refreshToken};
