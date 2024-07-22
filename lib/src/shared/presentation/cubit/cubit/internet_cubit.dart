import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import for ValueNotifier
import 'package:flutter_clean_architecture/src/core/enums/enums.dart';

part 'internet_state.dart';

class NetworkCubit extends Cubit<InternetStatus> {
  NetworkCubit() : super(const InternetStatus(ConnectivityStatus.connected));

  final ValueNotifier<InternetStatus> _connectivityStatusNotifier =
      ValueNotifier<InternetStatus>(
    const InternetStatus(ConnectivityStatus.connected),
  );

  ValueNotifier<InternetStatus> get connectivityStatusNotifier =>
      _connectivityStatusNotifier;

  String? lastRoute;

  void checkConnectivity() async {
    ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    _updatedConnectivityStatus(connectivityResult);
  }

  void _updatedConnectivityStatus(ConnectivityResult result) {
    InternetStatus newStatus;
    if (result == ConnectivityResult.none) {
      newStatus = const InternetStatus(ConnectivityStatus.disconnected);
    } else {
      newStatus = const InternetStatus(ConnectivityStatus.connected);
    }

    emit(newStatus);
    _connectivityStatusNotifier.value = newStatus;
  }

  late StreamSubscription<ConnectivityResult?> _subscription;

  void trackConnectivityChange() {
    _subscription = Connectivity().onConnectivityChanged.listen(
      (ConnectivityResult result) {
        _updatedConnectivityStatus(result);
      },
    );
  }

  void dispose() {
    _subscription.cancel();
    _connectivityStatusNotifier.dispose();
  }
}
