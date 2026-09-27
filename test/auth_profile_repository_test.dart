import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:mobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:mobile/features/auth/data/models/auth_models.dart';
import 'package:mobile/features/auth/data/repositories/profile_repository_impl.dart';

class _MockRemote extends Mock implements AuthRemoteDataSource {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late _MockRemote remote;
  late ProfileRepositoryImpl repo;

  setUpAll(() => registerFallbackValue(const UserMeUpdateDto()));

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
    remote = _MockRemote();
    repo = ProfileRepositoryImpl(remoteDataSource: remote);
  });

  const me = UserMeDto(id: 'u1', phoneNumber: '+2250700000000');

  test(
    'lit le serveur une fois puis le cache (impression hors ligne)',
    () async {
      when(
        remote.getMe,
      ).thenAnswer((_) async => me.copyWith(displayName: 'Awa'));

      expect(await repo.getDisplayName(), 'Awa');
      when(remote.getMe).thenThrow(Exception('hors ligne'));
      expect(await repo.getDisplayName(), 'Awa');
      verify(remote.getMe).called(1);
    },
  );

  test('un nom vide est envoyé comme null (ligne retirée)', () async {
    when(() => remote.updateMe(any())).thenAnswer((_) async => me);

    expect(await repo.updateDisplayName('   '), isNull);
    final sent =
        verify(() => remote.updateMe(captureAny())).captured.single
            as UserMeUpdateDto;
    expect(sent.displayName, isNull);
  });

  test('clearLocal oublie le nom du compte précédent', () async {
    when(remote.getMe).thenAnswer((_) async => me.copyWith(displayName: 'Awa'));
    await repo.getDisplayName();
    await repo.clearLocal();

    when(
      remote.getMe,
    ).thenAnswer((_) async => me.copyWith(displayName: 'Koffi'));
    expect(await repo.getDisplayName(), 'Koffi');
  });
}
