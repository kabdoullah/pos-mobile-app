import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/network_providers.dart';
import '../data/subscription_repository_impl.dart';
import '../domain/repositories/subscription_repository.dart';

part 'subscription_di_providers.g.dart';

/// Fournit le repository des abonnements (ADR-0017).
@Riverpod(keepAlive: true)
SubscriptionRepository subscriptionRepository(Ref ref) =>
    SubscriptionRepositoryImpl(dio: () => ref.read(dioProvider));
