class ResponceModel {
  final String message;
  final int status;
  final List<dynamic> result; // Ensure this matches the expected type
  final String description;

  ResponceModel(this.message, this.status, this.result, this.description);

  factory ResponceModel.fromJson(Map<String, dynamic> json) {
    return ResponceModel(
      json['msg'] as String,
      json['status'] as int,
      json['data'] as List<dynamic> ?? [],
      json['description'] as String ?? "",
    );
  }
}
