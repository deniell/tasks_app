import 'dart:convert';

///
/// Evaluate exact error message from response
///
String getExactErrorMessage(String respBody) {

  if (respBody == null) {
    return null;
  }

  String cause;

  try {

    final Map responseBody = json.decode(respBody);

    if (responseBody != null) {

      if (responseBody.containsKey('message')) {
        cause = responseBody['message'];
        cause += ". ";

        print(cause);
      }

      if (responseBody.containsKey('fields')) {
        final Map fields = responseBody['fields'];
        fields.forEach((k,v) => cause += v[0]);
        cause += " ";
      }

      print(cause);
    }

    return cause;

  } catch(e) {
    return null;
  }
}