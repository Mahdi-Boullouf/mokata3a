class CodedProduct {
  final String name;
  final String barCode;
  final bool isBoyCotted;
  CodedProduct({
    required this.name,
    required this.barCode,
    required this.isBoyCotted,
  });

  factory CodedProduct.fromJson(Map<String, dynamic> json) {
    return CodedProduct(
        name: json['name'],
        barCode: json['barCode'],
        isBoyCotted: json['boycotted']);
  }
  Map<String, dynamic> toJson() =>
      {"name": name, "barCode": barCode, 'boycotted': true};
}
