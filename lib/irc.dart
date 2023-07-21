import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:irc/irc_message.dart';

import 'config.dart';

class IRCController {
  late Socket _io;
  Configuration? config;
  late StreamController<IRCMessage> input;

  IRCController(c) {
    input = StreamController<IRCMessage>();
    config = c;
  }

  static Future<IRCController> connect(Configuration config) async {
    IRCController irc = IRCController(config);
    print(irc.config);
    irc._io = await SocketIO(config);
    irc._io.listen(irc._onEvent);
    irc.nick();
    irc.user();
    irc.pass();
    print("done");
    return irc;
  }

  _onEvent(s) {
    String str = utf8.decode(s);
    print(str);
    input.add(IRCMessage.parse(str));
  }
}

extension on IRCController {
  nick() {
    _io.writeln('NICK ${config?.nickname}');
  }

  user() {
    _io.writeln('USER ${config?.username} * * ${config?.realname}');
  }

  pass() {
    _io.writeln('PASS ${config?.password}');
  }
}

Future<Socket> SocketIO(Configuration config) async {
  if (config.ssl) return await SecureSocket.connect(config.host, config.port);
  return await Socket.connect(config.host, config.port);
}
