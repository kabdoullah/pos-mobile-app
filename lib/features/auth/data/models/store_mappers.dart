import '../../../../core/network/api_models/store_dto.dart';
import '../../domain/entities/store.dart';

/// Convertit StoreDto (API) → Store (domaine).
extension StoreDtoToDomain on StoreDto {
  /// Convertit le DTO de l'API en entité du domaine.
  Store toDomain() => Store(
    name: name,
    address: address,
    ncc: ncc,
    isSubjectToVat: vatSubject,
    receiptFooterText: receiptFooterText,
    phone: phone,
    logoVersion: logoVersion,
  );
}

/// Convertit Store (domaine) → StoreUpdateDto (requête API).
extension StoreUpdateDtoMapper on Store {
  /// Convertit l'entité du domaine en DTO de requête de mise à jour.
  StoreUpdateDto toUpdateDto() => StoreUpdateDto(
    name: name,
    address: address,
    ncc: ncc,
    vatSubject: isSubjectToVat,
    receiptFooterText: receiptFooterText,
    phone: phone,
  );
}

/// Convertit Store (domaine) → StoreCreateDto (requête API).
extension StoreCreateDtoMapper on Store {
  /// Convertit l'entité du domaine en DTO de requête de création.
  StoreCreateDto toCreateDto() => StoreCreateDto(
    name: name,
    address: address,
    ncc: ncc,
    vatSubject: isSubjectToVat,
    receiptFooterText: receiptFooterText,
    phone: phone,
  );
}
