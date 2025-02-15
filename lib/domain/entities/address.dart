class Address {
  final String id;
  final String userId;
  final String street;
  final String city;
  final String state;

  Address({
    required this.id,
    required this.userId,
    required this.street,
    required this.city,
    required this.state,
  });

  Address.create({
    required this.street,
    required this.city,
    required this.state,
  })  : id = '',
        userId = '';
  @override
  List<Object> get props  => [id, userId, street, city, state];
}