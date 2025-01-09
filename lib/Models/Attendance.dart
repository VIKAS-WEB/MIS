class Attendance {
  final String attendeceCode;
  final String checkIn;
  final String checkOut;
  final String duration;
  final String distance;

  Attendance({
    required this.attendeceCode,
    required this.checkIn,
    required this.checkOut,
    required this.duration,
    required this.distance,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      attendeceCode: json['attendeceCode'],
      checkIn: json['checkIn'],
      checkOut: json['checkOut'],
      duration: json['duration'],
      distance: json['distance'],
    );
  }
}
