class RespConfig {
  static const option_filed_code = "option_filed_code";
  static const option_filed_msg = "option_filed_msg";
  static const option_filed_success_code = "option_filed_success_code";
  final String filedCode;
  final String filedMsg;
  final String successCode;

  RespConfig(
      {this.filedCode = "code",
      this.filedMsg = "msg",
      this.successCode = "200"});
}
