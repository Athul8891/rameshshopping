import 'dart:async';

import 'package:corazon_customerapp/src/di/app_injector.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:corazon_customerapp/src/app.dart';
import 'package:corazon_customerapp/src/bloc/app_cubit_observer.dart';
import 'package:corazon_customerapp/src/core/services/crashlytics_service.dart';
import 'package:corazon_customerapp/src/di/app_injector.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  runZonedGuarded(() async{
    WidgetsFlutterBinding.ensureInitialized();

    //await Firebase.initializeApp();
    AppInjector.create();
    Bloc.observer = MyBlocObserver();
    Crashlytics.instance.enableInDevMode = false;
    FlutterError.onError = CrashlyticsService.recordFlutterError;

    runApp(App());
  }, (error, stack) {
    CrashlyticsService.recordError(error, stack);
  }, zoneSpecification: ZoneSpecification());
}


