import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:corazon_customerapp/src/bloc/add_address/add_address.dart';
import 'package:corazon_customerapp/src/core/utils/validator.dart';
import 'package:corazon_customerapp/src/di/app_injector.dart';
import 'package:corazon_customerapp/src/models/account_details_model.dart';
import 'package:corazon_customerapp/src/res/app_colors.dart';
import 'package:corazon_customerapp/src/res/string_constants.dart';
import 'package:corazon_customerapp/src/res/text_styles.dart';
import 'package:corazon_customerapp/src/ui/common/commom_text_field.dart';
import 'package:corazon_customerapp/src/ui/common/common_button.dart';

class AddAddressScreen extends StatefulWidget {
  final bool newAddress;
  final AccountDetails accountDetails;
  final Address editAddress;

  AddAddressScreen(this.newAddress, this.accountDetails, this.editAddress);

  @override
  _AddAddressScreenState createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  var addAddressCubit = AppInjector.get<AddAddressCubit>();
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController pincodeEditingController = TextEditingController();
  TextEditingController addressEditingController = TextEditingController();
  TextEditingController cityEditingController = TextEditingController();
  TextEditingController stateEditingController = TextEditingController();
  TextEditingController phoneEditingController = TextEditingController();
  TextEditingController flatEditingController = TextEditingController();

  FocusNode nameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode pincodeFocusNode = FocusNode();
  FocusNode addressFocusNode = FocusNode();
  FocusNode cityFocusNode = FocusNode();
  FocusNode buildingFocusNode = FocusNode();
  FocusNode flatFocusNode = FocusNode();
  FocusNode stateFocusNode = FocusNode();
  FocusNode phoneFocusNode = FocusNode();
  Validator validator = Validator();

  bool setAsDefault;
  String _dropDownValue;
  String type;

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    setAsDefault = false;
    if (widget.editAddress != null) {
      Address address = widget.editAddress;
      nameEditingController.text = address.name;
      pincodeEditingController.text = address.pincode;
      addressEditingController.text = address.address;
      cityEditingController.text = address.city;
      flatEditingController.text = address.flat;
      phoneEditingController.text = address.phoneNumber;
      _dropDownValue = address.type;
      setAsDefault = address.isDefault;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text("${widget.newAddress ? "Add" : "Edit"} Address"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 30),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: widget.newAddress,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 30),
                      child: Text(
                        StringsConstants.addNewAddress,
                        style: AppTextStyles.medium14Black,
                      ),
                    ),
                  ),


                  ///type
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.colorF6F5F8,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    alignment: Alignment.bottomRight,
                    width: double.infinity,
                    // color: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 5),
                    // margin: EdgeInsets.only(left: 2.0, right: 2.0, ),

                    child:DropdownButton(

                      hint: _dropDownValue == null
                          ? Text('-Address Type-')
                          : Text(
                        _dropDownValue,
                        style: TextStyle(color: Colors.black),
                      ),
                      isExpanded: true,
                      underline: SizedBox(),
                      iconSize: 30.0,
                      style: TextStyle(color: Colors.black),
                      items: ['House', 'Apartment', 'Office',].map(
                            (val) {
                          return DropdownMenuItem<String>(
                            value: val,
                            child: Text(val),
                            onTap: (){
                              _dropDownValue= val;
                              print("genderrrrrrrrrrrr");
                              print(type);

                            },
                          );
                        },
                      ).toList(),
                      onChanged: (val) {
                        setState(
                              () {
                            _dropDownValue = val;
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  ///name
                  CustomTextField(
                    hint: StringsConstants.name,
                    textEditingController: nameEditingController,
                    focusNode: nameFocusNode,
                    nextFocusNode: pincodeFocusNode,
                   // validator: validator.validateName,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (val) {
                      FocusScope.of(context).requestFocus(pincodeFocusNode);
                    },
                    // containerHeight: 50,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  ///blding
                  CustomTextField(
                    hint: StringsConstants.address,
                    keyboardType: TextInputType.phone,

                    textEditingController: addressEditingController,
                    focusNode: buildingFocusNode,
                    nextFocusNode: flatFocusNode,
                    validator: (val) {
                      if (val.isEmpty) {
                        return "Building is Required";
                      } else
                        return null;
                    },

                    textInputAction: TextInputAction.next,
                    onSubmitted: (val) {
                      FocusScope.of(context).requestFocus(cityFocusNode);
                    },
                    // containerHeight: 50,
                  ),
                  SizedBox(
                    height: 30,
                  ),

                  ///flt
                  CustomTextField(
                    hint: "Flat",
                    textEditingController: flatEditingController,
                    focusNode: flatFocusNode,
                    nextFocusNode: flatFocusNode,
                    validator: (val) {
                      if (val.isEmpty) {
                        return "Flat is Required";
                      } else
                        return null;
                    },

                    keyboardType: TextInputType.phone,

                    textInputAction: TextInputAction.next,
                    onSubmitted: (val) {
                      FocusScope.of(context).requestFocus(cityFocusNode);
                    },
                    // containerHeight: 50,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  ///area
                  CustomTextField(
                    hint: StringsConstants.pincode,

                    textEditingController: pincodeEditingController,
                    focusNode: pincodeFocusNode,
                    nextFocusNode: addressFocusNode,
                   // validator: validator.validatePinCode,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (val) {
                      FocusScope.of(context).requestFocus(addressFocusNode);
                    },
                    // containerHeight: 50,
                  ),


                  SizedBox(
                    height: 30,
                  ),

                  ///block
                  CustomTextField(
                    hint: StringsConstants.city,
                    textEditingController: cityEditingController,
                    focusNode: cityFocusNode,
                    nextFocusNode: stateFocusNode,
                    keyboardType: TextInputType.phone,

                    //  validator: (val) => validator.validateText(val, "City"),
                    // keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (val) {
                      FocusScope.of(context).requestFocus(stateFocusNode);
                    },
                    // containerHeight: 50,
                  ),
                  SizedBox(
                    height: 30,
                  ),

                  ///road
                  CustomTextField(
                    hint: StringsConstants.state,
                    textEditingController: stateEditingController,
                    focusNode: stateFocusNode,
                    keyboardType: TextInputType.phone,

                    nextFocusNode: phoneFocusNode,
                    //validator: (val) => validator.validateText(val, "State"),
                    //keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (val) {
                      FocusScope.of(context).requestFocus(phoneFocusNode);
                    },
                    // containerHeight: 50,
                  ),
                  SizedBox(
                    height: 30,
                  ),



                  ///email
                  CustomTextField(
                    hint: "Email",
                    textEditingController: emailEditingController,
                    focusNode: addressFocusNode,
                    nextFocusNode: cityFocusNode,
                    validator: (val) {
                      if (val.isEmpty) {
                        return "Email is Required";
                      } else
                        return null;
                    },
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (val) {
                      FocusScope.of(context).requestFocus(cityFocusNode);
                    },
                    // containerHeight: 50,
                  ),
                  SizedBox(
                    height: 30,
                  ),





                  ///phn
                  CustomTextField(
                    hint: StringsConstants.phoneNumber,
                    textEditingController: phoneEditingController,
                    focusNode: phoneFocusNode,
                    //validator: validator.validateMobile,
                    keyboardType: TextInputType.phone,
                    onChanged: (val) {
                      if (validator.validateMobile(val) == null) {
                        FocusScope.of(context).requestFocus(FocusNode());
                      }
                    },
                    // containerHeight: 50,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      StatefulBuilder(
                        builder: (BuildContext context,
                            void Function(void Function()) setState) {
                          return Checkbox(
                            value: setAsDefault,
                            onChanged: (bool value) {
                              setState(() {
                                setAsDefault = value;
                              });
                            },
                          );
                        },
                      ),
                      Text(
                        StringsConstants.setAsDefaultCaps,
                        style: AppTextStyles.medium14Black,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  BlocConsumer<AddAddressCubit, AddAddressState>(
                    cubit: addAddressCubit,
                    listener: (BuildContext context, AddAddressState state) {
                      if (state is Successful) {
                        Navigator.of(context).pop(true);
                      }
                    },
                    builder: (BuildContext context, AddAddressState state) {
                      return CommonButton(
                        title: StringsConstants.save,
                        titleColor: AppColors.white,
                        height: 50,
                        replaceWithIndicator: state is ButtonLoading,
                        //isDisabled:
                        margin: EdgeInsets.only(bottom: 40),
                        onTap: () {
                          onButtonTap();
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onButtonTap() {
 //   if (_formKey.currentState.validate()) {
      Address address = Address(
          name: nameEditingController.text,
          address: addressEditingController.text,
          city: cityEditingController.text,
          isDefault: setAsDefault,
          pincode: pincodeEditingController.text,
          flat: flatEditingController.text,
          email: emailEditingController.text,


          type:_dropDownValue.toString(),
          phoneNumber: "+973${phoneEditingController.text}",
          state: stateEditingController.text);
      addAddressCubit.saveAddress(widget.accountDetails, address);
   // }
  }
}
