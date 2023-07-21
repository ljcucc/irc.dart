class Configuration {
  String host;
  int port;
  String username;
  String nickname;
  String realname;
  String password;
  bool ssl;

  Configuration({
    this.host = "",
    this.port = 6697,
    this.ssl = false,
    this.nickname = "",
    this.realname = "",
    this.username = "",
    this.password = "",
  });
}
