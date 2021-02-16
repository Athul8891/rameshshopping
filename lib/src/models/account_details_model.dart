class AccountDetails {
  String name;
  String phoneNumber;
  List<Address> addresses = [];

  AccountDetails({this.name, this.phoneNumber, this.addresses});

  AccountDetails.fromDocument(json) {
    name = json['name'];
    phoneNumber = json['phone_number'];
    if (json['addresses'] != null) {
      addresses = new List<Address>();
      print(json["addresses"]);
      addresses = (json['addresses'] as List)
          ?.map((e) => e == null ? null : Address.fromDocument(e))
          ?.toList();
    } else {
      addresses = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['phone_number'] = this.phoneNumber;
    if (this.addresses != null) {
      data['addresses'] = this.addresses.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Address {
  String type;

  String name;
  String flat;

  String building;
  String road;
  String block;
  String area;
  String email;

  String landmark;
  String phone;
  bool isDefault;

  Address(
      {this.name,
      this.flat,
      this.building,
      this.road,
      this.block,
      this.area,
      this.email,
      this.landmark,
      this.phone,
      this.type,
      this.isDefault = false});

  Address.fromDocument(json) {
    name = json['name'];
    flat = json['flat'];
    building = json['building'];
    road = json['road'];
    block = json['block'];
    area = json['area'];

    email = json['email'];
    landmark = json['landmark'];
    phone = json['phone'];
    type = json['type'];
    isDefault = json['is_default'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['flat'] = this.flat;
    data['building'] = this.building;
    data['road'] = this.road;
    data['block'] = this.block;
    data['area'] = this.area;
    data['landmark'] = this.landmark;
    data['phone'] = this.phone;
    data['email'] = this.email;

    data['type'] = this.type;

    data['is_default'] = this.isDefault;
    return data;
  }

  String wholeAddress() {
    return "$flat $building $road $block";
  }
}
