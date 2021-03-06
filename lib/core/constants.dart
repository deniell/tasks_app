import 'package:flutter/material.dart';

// base API url
const String BASE_URL = "https://testapi.doitserver.in.ua/api";

// Errors messages
const String SERVER_FAILURE_MESSAGE = "Server Failure.";

const String VALIDATION_FAILED_MESSAGE = "Validation failed.";

const String UNAUTHORIZED_MESSAGE = "This action is unauthorized.";

const String UNEXPECTED_ERROR_MESSAGE = "Unexpected error.";

const String UNKNOWN_ERROR_MESSAGE = "Something went wrong.";

const String NO_INTERNET_MESSAGE = "No internet connection.";

const String CACHE_ERROR_MESSAGE = "Cache Failure.";

MaterialColor appColor = Colors.grey[600];

const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  contentPadding: EdgeInsets.all(12.0),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey, width: 2.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blue, width: 2.0),
  ),
);