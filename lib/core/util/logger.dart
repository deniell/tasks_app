import 'package:logger/logger.dart' as package;

Logger logger = Logger(); // get back the singleton

class Logger
{
  package.Logger log;

  static final Logger _singleton = Logger._internal();

  factory Logger()
  {
    return _singleton;
  }

  Logger._internal()
  {
    // Initialize logger
    log = package.Logger(
      printer: package.PrettyPrinter(
        methodCount: 1, // number of method calls to be displayed
        errorMethodCount: 8, // number of method calls if stacktrace is provided
        lineLength: 120, // width of the output
        colors: false, // Colorful log messages
        printEmojis: true, // Print an emoji for each log message
        printTime: false // Should each log print contain a timestamp
      ),
      // filter: DebugFilter()
    );

    // Set logging level
    package.Logger.level = package.Level.debug; // for detailed debugging
  }
}

class DebugFilter extends package.LogFilter
{
  @override
  bool shouldLog(package.LogEvent event)
  {
    return true;
  }
}