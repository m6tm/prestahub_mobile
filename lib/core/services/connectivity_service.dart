import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Enumération pour représenter l'état de la connexion simplifiée.
enum ConnectionStatus { online, offline }

/// Service de gestion de la connectivité réseau.
/// Fournit un flux (Stream) d'états de connexion et permet de vérifier l'état actuel.
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  
  /// Contrôleur pour diffuser les changements d'état de connexion.
  final StreamController<ConnectionStatus> _connectionChangeController = 
      StreamController<ConnectionStatus>.broadcast();

  ConnectionStatus _currentStatus = ConnectionStatus.online;

  /// Flux (Stream) des changements d'état de connexion.
  Stream<ConnectionStatus> get connectionStream => _connectionChangeController.stream;

  /// État actuel de la connexion.
  ConnectionStatus get currentStatus => _currentStatus;

  /// Constructeur qui initialise l'écouteur de connectivité.
  ConnectivityService() {
    _connectivity.onConnectivityChanged.listen(_connectionChanged);
    _checkInitialConnection();
  }

  /// Vérifie l'état initial de la connexion au démarrage du service.
  Future<void> _checkInitialConnection() async {
    final List<ConnectivityResult> results = await _connectivity.checkConnectivity();
    _connectionChanged(results);
  }

  /// Appelé chaque fois que l'état de la connectivité change.
  Future<void> _connectionChanged(List<ConnectivityResult> results) async {
    // Si la liste contient autre chose que 'none', on a potentiellement une connexion.
    final bool hasInterface = results.any((result) => result != ConnectivityResult.none);
    
    bool isOnline = false;
    if (hasInterface) {
      // On vérifie si on a un véritable accès internet.
      isOnline = await _hasRealInternetAccess();
    }
    
    final newStatus = isOnline ? ConnectionStatus.online : ConnectionStatus.offline;
    
    if (_currentStatus != newStatus) {
      _currentStatus = newStatus;
      _connectionChangeController.add(_currentStatus);
    }
  }

  /// Vérifie si l'appareil a un véritable accès à internet via un lookup DNS.
  Future<bool> _hasRealInternetAccess() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 3));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  /// Méthode utilitaire pour vérifier si l'appareil est actuellement en ligne.
  Future<bool> isConnected() async {
    final results = await _connectivity.checkConnectivity();
    final hasInterface = results.any((result) => result != ConnectivityResult.none);
    if (!hasInterface) return false;
    return _hasRealInternetAccess();
  }

  /// Dispose des ressources.
  void dispose() {
    _connectionChangeController.close();
  }
}
