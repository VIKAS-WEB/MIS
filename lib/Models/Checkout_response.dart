class CheckOutElement {
  String userId;
  String checkOutDate;
  String checkOutTime;
  int status;

  CheckOutElement({
    required this.userId,
    required this.checkOutDate,
    required this.checkOutTime,
    required this.status,
  });

  factory CheckOutElement.fromJson(Map<String, dynamic> json) =>
      CheckOutElement(
        userId: json["userId"],
        checkOutDate: json["checkOutDate"],
        checkOutTime: json["checkOutTime"],
        status: json["status"],
      );
}
