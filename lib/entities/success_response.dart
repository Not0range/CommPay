class SuccessResponse {
  final bool isSuccess;
  final String? errorMessage;

  SuccessResponse(this.isSuccess, {this.errorMessage});

  factory SuccessResponse.fromJson(Map<String, dynamic> json) {
    return SuccessResponse(json['is_success'] == '1',
        errorMessage: json.containsKey('error_msg') ? json['error_msg'] : null);
  }
}
