class User {
  final int userId;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  int? ownerId;
  int? subId;
  final String userRole;

  User.ownerUser(this.userId, this.firstName, this.lastName, this.email,
      this.password, this.ownerId, this.userRole, this.subId);

  User(this.userId, this.firstName, this.lastName, this.email, this.password,
      this.userRole, this.subId);

  factory User.fromJson(Map<String, dynamic> json) => User.ownerUser(
        int.parse(json['user_id']),
        json['first_name'],
        json['last_name'],
        json['email'],
        json['password'],
        json['owner_id'] == null ? 0 : int.parse(json['owner_id']),
        json['user_role'],
        json['sub_id'] == null ? 0 : int.parse(json['sub_id']),
      );

  Map<String, dynamic> toJson() => {
        'user_id': userId.toString(),
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'password': password,
        'owner_id': ownerId.toString(),
        'user_role': userRole,
        'sub_id': subId.toString()
      };

  Map<String, dynamic> toJsonRegister() => {
        'user_id': userId.toString(),
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'password': password,
        'user_role': userRole,
        'sub_id': subId.toString(),
      };

  @override
  String toString() {
    return 'Firstame : $firstName \nLastname : $lastName \nEmail : $email';
  }
}
