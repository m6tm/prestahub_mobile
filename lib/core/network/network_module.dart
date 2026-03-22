import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prestahub/core/network/http_client.dart';
import 'package:prestahub/data/services/service_module.dart';

/// Provider pour le client HTTP.
final httpClientProvider = Provider<HttpClient>((ref) {
  final authLocalService = ref.watch(authLocalServiceProvider);
  return HttpClient(authLocalService);
});
