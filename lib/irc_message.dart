class IRCMessagePrefix {
  String host = "";
  String nick = "";
  String user = "";

  IRCMessagePrefix({
    host,
    nick,
    user,
  });

  static IRCMessagePrefix parse(String input) {
    final prefixParser =
        RegExp(r'(?<nick>[^!.]+)([!](?<user>[^@]+))*([@](?<host>.+))*');
    final hostnameParser =
        RegExp(r'([a-z]([-a-z0-9]*[a-z0-9])?\.)+[a-z]([-a-z0-9]*[a-z0-9])?');

    String host = "";
    String nick = "";
    String user = "";

    do {
      // is hostname
      if (hostnameParser.hasMatch(input)) {
        host = input;
        break;
      }

      // is not hostname, parse prefix
      print(prefixParser.firstMatch(input)?.input ?? "");
      RegExpMatch match = prefixParser.firstMatch(input)!;

      nick = match.namedGroup("nick") ?? "";
      user = match.namedGroup("user") ?? "";
      host = match.namedGroup("host") ?? "";
    } while (false);

    return IRCMessagePrefix(
      host: host,
      nick: nick,
      user: user,
    );
  }
}

class IRCMessage {
  late IRCMessagePrefix prefix;
  String digits = "";
  String command = "";
  List<String> params = [];
  String trailing = "";

  IRCMessage({
    required prefix,
    digits,
    command,
    params,
    trailing,
  });

  static IRCMessage parse(String input) {
    // define regexp rules
    final msgParser = RegExp(
      r'(:(?<prefix>\S+\s))*((?<digits>\d\d\d)|(?<command>\w+))\s(?<trailing>.*)',
    );
    final tailParser = RegExp(r'(?<params>.[^:]+)(?<trailing>:.*)*');

    // first stage
    RegExpMatch? match = msgParser.firstMatch(input);

    IRCMessagePrefix prefix =
        IRCMessagePrefix.parse(match?.namedGroup("prefix") ?? "");
    String digits = match?.namedGroup("digits") ?? "";
    String command = match?.namedGroup("command") ?? "";
    String tail = match?.namedGroup("trailing") ?? "";

    // second stage
    List<String> params = [""];
    String trailing = "";

    if (tail.isNotEmpty) {
      RegExpMatch? tailMatch = tailParser.firstMatch(tail);
      trailing = (tailMatch?.namedGroup("trailing") ?? "");
      params =
          ((tailMatch?.namedGroup("params") ?? "").substring(1).split(" "));
    }

    return IRCMessage(
      prefix: prefix,
      digits: digits,
      command: command,
      params: params,
      trailing: trailing,
    );
  }
}
