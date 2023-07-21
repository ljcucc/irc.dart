import 'package:irc/irc_message.dart';
import 'package:irc/config.dart';
import 'package:irc/irc.dart';

void main(List<String> arguments) async {
  var config = Configuration(
    host: arguments[4],
    port: int.parse(arguments[3]),
    ssl: true,
    password: arguments[2],
    username: arguments[1],
    nickname: arguments[0],
  );
  var irc = await IRCController.connect(config);
}
