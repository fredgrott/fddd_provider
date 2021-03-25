// Copyright 2021 by Fredrick Allan Grott
// BSD-style license that can be found in the LICENSE file.

import 'package:fddd_provider/application/build_modes.dart';
import 'package:logging/logging.dart';
import 'package:logging_appenders/logging_appenders.dart';

void myLogSetUp() {
  if (isInDebugMode) {
    Logger.root.level = Level.ALL;
    hierarchicalLoggingEnabled = true;
    // ignore: unused_local_variable
    final appender = PrintAppender.setupLogging(stderrLevel: Level.SEVERE);
    PrintAppender(formatter: const ColorFormatter())
        .attachToLogger(Logger.root);
  } else {
    // turn logging into NOOP for release and profile modes
    Logger.root.level = Level.OFF;
  }
}
