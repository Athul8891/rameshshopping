import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:corazon_customerapp/src/models/account_details_model.dart';

part 'my_address_state.freezed.dart';

@freezed
abstract class MyAddressState with _$MyAddressState {
  const factory MyAddressState.loading() = Loading;

  const factory MyAddressState.showAccountDetails(
      AccountDetails accountDetails) = ShowAccountDetails;

  const factory MyAddressState.error(String errorMessage) = Error;
}
