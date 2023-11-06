class RespConfig {
  final String filedCode;
  final String filedMsg;
  final int successCode;

  RespConfig(
      {this.filedCode = "code",
      this.filedMsg = "msg",
      this.successCode = 200});
}
