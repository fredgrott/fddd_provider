// Copyright 2021 by Fredrick Allan Grott
// BSD-style license that can be found in the LICENSE file.


import 'dart:async';
import 'dart:developer';

import 'package:ansicolor/ansicolor.dart';
import 'package:fddd_provider/application/build_modes.dart';
import 'package:fddd_provider/application/log_setup.dart';
import 'package:fddd_provider/application/platform_targets.dart';
import 'package:fddd_provider/presentation/my_app.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

final Logger myMainLogger = Logger("myMain");


Future<void>  main() async {

  // Since we initialize before the runApp is called we need to 
  // to call this as it's not at this time executed internally by
  // the runApp yet at this point.Ensures the Flutter Sky engine is
  // fully initialized before any initialization calls.
  WidgetsFlutterBinding.ensureInitialized();

  // initialize platform info state querying
  initPlatformState();

  // initialize the log settings for this app
  myLogSetUp();


  myMainLogger.info("init of main function completed");





  // The error widget the user will see when an app exception(hard error) trips
  ErrorWidget.builder = (FlutterErrorDetails details) {
      if (isInDebugMode){
          return ErrorWidget(details.exception);
      }
      
      return Container(
      alignment: Alignment.center,
      child: const Text(
        'Error!',
        style: TextStyle(color: Colors.yellow),
        textDirection: TextDirection.ltr,
      ),
    );

  };

  // This captures errors reported by the Flutter framework.
  // For example, if you used a Positioned Widget inside a 
  // ColumnWidget you would get to see the small error report that 
  // gets outputted to stdout via this function as since it's a soft error 
  // will be logged to console.
  FlutterError.onError = (FlutterErrorDetails details) async {
    if (isInDebugMode) {
      // In development mode simply print to console.
      FlutterError.dumpErrorToConsole(details);
    } else {
      // In production mode report to the application zone to report to
      // app exceptions provider. We do not need this in Profile mode.
      if (isInReleaseMode) {
        Zone.current.handleUncaughtError(details.exception, details.stack);
      }
    }
  };


  runZonedGuarded<Future<void>>(
    () async {
      runApp(MyApp());
    },
    (error, stackTrace) async {
      await _reportError(error, stackTrace);
    },
    zoneSpecification: ZoneSpecification(
      // Intercept all print calls
      print: (self, parent, zone, line) async {
        // Paint all logs with Cyan color
        final pen = AnsiPen()..cyan(bold: true);
        // Include a timestamp and the name of the App
        final messageToLog = "[${DateTime.now()}] Provider $line";

        // Also print the message in the "Debug Console"
        parent.print(zone, pen(messageToLog));
      },
    ),
  );


}

// the _reportError function to report error ot an app exception service provider in 
// release mode and log it in debug mode.
Future<void> _reportError(dynamic error, dynamic stackTrace) async {
  log('Caught error: $error');
  // Errors thrown in development mode are unlikely to be interesting. You
  // check if you are running in dev mode using an assertion and omit send
  // the report.
  if (isInDebugMode) {
    log('$stackTrace');
    log('In dev mode. Not sending report to an app exceptions provider.');

    return;
  } else {
    // reporting error and stacktrace to app exceptions provider code goes here
    if (isInReleaseMode) {
        // code goes here
    }
  }
}
