import 'package:freezed_annotation/freezed_annotation.dart';

import '../../extensions/string_formatting.dart';

part 'filter_model.freezed.dart';

@freezed
class FilterModel with _$FilterModel {

  const FilterModel._();

  const factory FilterModel({
    String? employeeNumber,
    String? fullName,
    String? firstAndLastName,
    String? commercialName,
    String? name,
  }) = _FilterModel;

  Map<String, dynamic> toJson() => {
    'filter': {
      if(employeeNumber?.isNotEmpty ?? false) 'employee_number': employeeNumber,
      if(fullName != null) ...fullName!.splitNameToFour(),
      if(firstAndLastName != null) ...firstAndLastName!.splitNameToTwo(),
      if(name != null) ...{'name': name!},
      if(commercialName != null) ...{'commercial_name': commercialName!},
    }
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is FilterModel &&
              runtimeType == other.runtimeType &&
              employeeNumber == other.employeeNumber &&
              fullName == other.fullName;

  @override
  int get hashCode => Object.hash(
    employeeNumber,
    fullName,
  );
}
