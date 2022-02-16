import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class ValidationBuilder {
  final List<FormFieldValidator> _validators = [];

  ValidationBuilder();

  /// Performs the value required validations
  ValidationBuilder valueRequired({message = "Value required"}) {
    _validators.add((value) {
      return value.length == 0 ? message : null;
    });
    return this;
  }

  /// Performs the email format validation
  ValidationBuilder email({message = "Invalid Email"}) {
    _validators.add((value) {
      return EmailValidator.validate(value) ? null : message;
    });
    return this;
  }

  /// Performs the email format validation
  ValidationBuilder minLength(int length, {message = "Value is too short"}) {
    _validators.add((value) {
      return value.toString().length < length ? message : null;
    });
    return this;
  }

  ValidationBuilder custom(FormFieldValidator validator) {
    _validators.add(validator);
    return this;
  }

  /// Builds and returns a validator fuction that takes care of
  /// all the valadations.
  String? Function(String? value)? build() {
    return (String? value) {
      for (int i = 0; i < _validators.length; i += 1) {
        final result = _validators[i](value);
        if (result != null) {
          //Return the FormFieldValidator result if it is not null
          return result;
        }
      }
      return null;
    };
  }
}
