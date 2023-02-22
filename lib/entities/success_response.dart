class SuccessResponse {
  final bool isSuccess;
  final String? errorMessage;

  SuccessResponse(this.isSuccess, {this.errorMessage});

  factory SuccessResponse.fromJson(Map<String, dynamic> json) {
    return SuccessResponse(json['IS_SUCCESS'] == 1,
        errorMessage: json['ERROR_MSG']);
  }
}
