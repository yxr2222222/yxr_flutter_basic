class BaseRespConfig {
  final String filedCode;
  final String filedMsg;
  final int successCode;

  BaseRespConfig(
      {this.filedCode = "code",
      this.filedMsg = "msg",
      this.successCode = 200});
}
