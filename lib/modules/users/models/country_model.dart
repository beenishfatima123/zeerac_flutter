class CountryModel {
  String? name = '';
  String? dialCode = '';
  String? code = '';

  CountryModel({this.name = '', this.dialCode = '', this.code = ''});

  CountryModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    dialCode = json['dial_code'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['dial_code'] = this.dialCode;
    data['code'] = this.code;
    return data;
  }

  @override
  String toString() {
    return 'CountryModel{name: $name, dialCode: $dialCode, code: $code}';
  }
}
