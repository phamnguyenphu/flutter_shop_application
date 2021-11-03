class Address {
  final String id;
  final String address;
  final String fullName;
  final String phoneNumber;
  final String idUser;
  final String distance;
  bool status;

  Address({
    required this.id,
    required this.address,
    required this.idUser,
    required this.distance,
    required this.status,
    required this.fullName,
    required this.phoneNumber,
  });

  void dispose() {}
}
