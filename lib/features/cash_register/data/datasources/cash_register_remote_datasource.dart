import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api_models/cash_session_dto.dart';

part 'cash_register_remote_datasource.g.dart';

/// Data source distante des sessions de caisse (api.md, « Sessions de
/// caisse »). Les UUID des sessions et des mouvements sont générés par l'app ;
/// un retry du même UUID avec le même contenu renvoie 200.
@RestApi()
abstract class CashRegisterRemoteDataSource {
  /// Crée une instance CashRegisterRemoteDataSource.
  factory CashRegisterRemoteDataSource(Dio dio, {String baseUrl}) =
      _CashRegisterRemoteDataSource;

  /// Ouvre une session (201, ou 200 pour un retry du même id).
  /// Endpoint : POST /api/v1/cash-sessions
  @POST('/api/v1/cash-sessions')
  Future<CashSessionDto> openSession(@Body() CashSessionOpenRequestDto body);

  /// Session ouverte de l'appareil ; 404 si aucune.
  /// Endpoint : GET /api/v1/cash-sessions/active
  @GET('/api/v1/cash-sessions/active')
  Future<CashSessionDetailDto> getActiveSession(
    @Query('device_id') String deviceId,
  );

  /// Historique paginé par curseur, `opened_at` décroissant.
  /// Endpoint : GET /api/v1/cash-sessions
  @GET('/api/v1/cash-sessions')
  Future<CashSessionPageDto> listSessions({
    @Query('cursor') String? cursor,
    @Query('limit') int? limit,
    @Query('device_id') String? deviceId,
  });

  /// Session, résumé et mouvements.
  /// Endpoint : GET /api/v1/cash-sessions/{id}
  @GET('/api/v1/cash-sessions/{id}')
  Future<CashSessionDetailDto> getSession(@Path('id') String id);

  /// Enregistre une entrée ou une sortie d'espèces (201, ou 200 pour un
  /// retry du même id).
  /// Endpoint : POST /api/v1/cash-sessions/{id}/movements
  @POST('/api/v1/cash-sessions/{id}/movements')
  Future<CashMovementDto> createMovement(
    @Path('id') String sessionId,
    @Body() CashMovementCreateRequestDto body,
  );

  /// Clôture la session (200, y compris pour un retry identique).
  /// Endpoint : POST /api/v1/cash-sessions/{id}/close
  @POST('/api/v1/cash-sessions/{id}/close')
  Future<CashSessionDetailDto> closeSession(
    @Path('id') String sessionId,
    @Body() CashSessionCloseRequestDto body,
  );
}
