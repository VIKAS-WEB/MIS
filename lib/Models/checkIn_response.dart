class CheckInResponse {
  final String userId;
  final String checkInId;
  final String checkInDate;
  final String checkInTime;
  final int status;

  CheckInResponse({
    required this.userId,
    required this.checkInId,
    required this.checkInDate,
    required this.checkInTime,
    required this.status,
  });

  factory CheckInResponse.fromJson(Map<String, dynamic> json) {
    return CheckInResponse(
      userId: json['userId'],
      checkInId: json['checkInId'],
      checkInDate: json['checkInDate'],
      checkInTime: json['checkInTime'],
      status: json['status'],
    );
  }
}
