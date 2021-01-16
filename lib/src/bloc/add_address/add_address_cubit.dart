import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:corazon_customerapp/src/bloc/add_address/add_address.dart';
import 'package:corazon_customerapp/src/bloc/add_address/add_address_state.dart';
import 'package:corazon_customerapp/src/di/app_injector.dart';
import 'package:corazon_customerapp/src/models/account_details_model.dart';
import 'package:corazon_customerapp/src/repository/auth_repository.dart';
import 'package:corazon_customerapp/src/repository/firestore_repository.dart';

class AddAddressCubit extends Cubit<AddAddressState> {
  var _firebaseRepo = AppInjector.get<FirestoreRepository>();
  var _authRepo = AppInjector.get<AuthRepository>();

  AddAddressCubit() : super(Idle());

  saveAddress(AccountDetails accountDetails, Address address) {
    emit(ButtonLoading());

    if (address.isDefault) {
      List.generate(accountDetails.addresses.length, (index) {
        accountDetails.addresses[index].isDefault = false;
      });
    }
    accountDetails.addresses.add(address);
    _firebaseRepo.addUserDetails(accountDetails).then((value) {
      emit(AddAddressState.successful());
    }).catchError((e) {
      emit(AddAddressState.error(e.toString()));
    });
  }
}
