import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utils {
  static DateFormat dateFormat = DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ');
  static bool isNullOrEmpty(String? value) {
    if (value == null || value.trim().isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  static bool isValidEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  static bool isValidPasswordLength(String password) {
    return (password.trim().length > 7 && password.trim().length < 21);
  }

  static String getNameInitials(String name) {
    var nameInitials = '';
    try {
      final nameComponents = name.trim().split(' ');
      switch (nameComponents.length) {
        case 1:
          nameInitials = nameComponents.first[0];
          break;
        case 2:
        case 3:
          nameInitials = nameComponents[0].characters.first +
              nameComponents[1].characters.first;
          break;
        case 4:
          nameInitials = nameComponents[0].characters.first +
              nameComponents[2].characters.first;
          break;
        default:
          nameInitials = nameComponents.first[0];
      }
    } catch (e) {
      nameInitials = '';
    }
    return nameInitials;
  }

  static String getLocationTextGMaps(String latitude, String longitude) {
    var _googleServ = 'https://www.google.com/maps/search/?api=1&query=';
    return '$_googleServ$latitude,$longitude';
  }

  static String timestampToDateFormat(
      int seconds, int nano, String dateFormat) {
    var timestamp = Timestamp(seconds, nano);
    var df = DateFormat(dateFormat);
    return df.format(timestamp.toDate());
  }

  static DateTime? fromDateFormat(dynamic date) =>
      date == null ? null : dateFormat.parse(date as String);
}
