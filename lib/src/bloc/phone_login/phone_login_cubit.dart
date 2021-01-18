import 'package:corazon_customerapp/src/res/string_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:corazon_customerapp/src/bloc/phone_login/phone_login_state.dart';

class PhoneLoginCubit extends Cubit<PhoneLoginState> {
  PhoneLoginCubit() : super(PhoneLoginState.onButtonDisabled());

  validateButton(String phoneNumber) {
    if (phoneNumber.isNotEmpty && phoneNumber.length == StringsConstants.valdationNum) {
      emit(PhoneLoginState.onButtonEnabled());
    } else {
      emit(PhoneLoginState.onButtonDisabled());
    }
  }

  checkPhoneNumber(String phoneNumber) {}
}
