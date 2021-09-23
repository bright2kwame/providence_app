class VehicleThings {
  String id = "";
  String name = "";

  VehicleThings({this.id = "", this.name = ""});

  VehicleThings.empty();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  String toString() {
    return 'VehicleThings{name: $name}';
  }
}
