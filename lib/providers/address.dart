class Address {
  final String id;
  final String street;
  final String wards;
  final String district;
  final String city;
  bool status;

  Address(
      {required this.id,
      required this.street,
      required this.wards,
      required this.district,
      required this.city,
      required this.status
      });
}
