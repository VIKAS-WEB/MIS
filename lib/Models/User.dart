class User {
  final String name;
  final String imagePath;
  final String address;
  final String checkInStatus;
  final String checkInTime;  // Add checkInTime field

  User({
    required this.name,
    required this.imagePath,
    required this.address,
    required this.checkInStatus,
    required this.checkInTime,  // Include checkInTime in the constructor
  });

  // Modify the fromJson method to parse checkInTime
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      imagePath: json['imagePath'],
      address: json['address'],
      checkInStatus: json['checkInStatus'],
      checkInTime: json['checkInTime'],  // Parse checkInTime
    );
  }
}
