import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:research_buddy/models/project.dart';

class BaseFieldUtils {
  static FormFieldValidator<T>? buildValidators<T>(BuildContext context, ProjectField field) {
    if (field.validators.isEmpty) return null;
    // If only one validator, simply construct it.
    if (field.validators.length == 1) {
      return buildValidator(field.validators[0], context);
    }
    // If there are multiple, componse them.
    final validators = field.validators.map((v) => buildValidator(v, context)).toList();
    return FormBuilderValidators.compose(validators);
  }

  static FormFieldValidator<T> buildValidator<T>(ProjectFieldValidator validator, BuildContext context) {
    if (validator.type == ProjectFieldValidatorType.required) {}

    switch (validator.type) {
      case ProjectFieldValidatorType.required:
        return FormBuilderValidators.required(context);
      case ProjectFieldValidatorType.email:
        return (dynamic value) => FormBuilderValidators.email(context)(value.toString());
      case ProjectFieldValidatorType.integer:
        return FormBuilderValidators.integer(context) as FormFieldValidator<T>;
      case ProjectFieldValidatorType.match:
        final value = validator.value as String;
        return FormBuilderValidators.match(context, value) as FormFieldValidator<T>;
      case ProjectFieldValidatorType.max:
        final value = validator.value as num;
        return FormBuilderValidators.max(context, value);
      case ProjectFieldValidatorType.min:
        final value = validator.value as num;
        return FormBuilderValidators.min(context, value);
      case ProjectFieldValidatorType.maxLength:
        final value = validator.value as int;
        return FormBuilderValidators.maxLength(context, value);
      case ProjectFieldValidatorType.minLength:
        final value = validator.value as int;
        return FormBuilderValidators.minLength(context, value);
      case ProjectFieldValidatorType.url:
        return FormBuilderValidators.url(context) as FormFieldValidator<T>;
      default:
        return (_) => null;
    }
  }
}
