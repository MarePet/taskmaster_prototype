class Subscription {
  final int subId;
  final String name;
  final String price;
  final int maxUsers;

  Subscription(
      {required this.subId,
      required this.name,
      required this.price,
      required this.maxUsers});

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
      subId: int.parse(json['sub_id']),
      name: json['name'],
      price: json['price'],
      maxUsers: int.parse(json['max_users']));

  Map<String, dynamic> toJson() => {
        'sub_id': subId.toString(),
        'name': name,
        'price': price,
        'max_users': maxUsers.toString()
      };

  @override
  String toString() {
    return "$name with $maxUsers max users to be created, only $price monthly";
  }
}
