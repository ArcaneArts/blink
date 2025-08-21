import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bittorrent_dht/bittorrent_dht.dart';
import 'package:crypto/crypto.dart';
import 'package:fast_log/fast_log.dart';

class DHTConnect {
  Future<void> broadcast({
    required String key,
    required String findKey,
    int port = 6881,
  }) async {
    DHT dht = DHT();
    String h = blinkHash(key);
    String hf = blinkHash(findKey);
    warn(
      "Starting DHT broadcast for key: $key on port: $port SHA1 (hex) = ${sha1.convert(utf8.encode(key)).toString()}",
    ); // Print hex for readability
    dht.announce(h, port);
    dht.createListener().listen((DHTEvent event) {
      if (event is DHTError) {
        error('DHT Error: ${event.code} - ${event.message}');
      } else if (event is NewPeerEvent) {
        verbose(
          "+ Peer ${event.address.addressString}:${event.address.port} [${event.infoHash}]",
        );

        if (event.infoHash == hf) {
          success("  +++ PEER FOUND!");
          connectToPeer(
            event.address.addressString,
            event.address.port,
          ); // Use discovered port
          dht.stop();
        }
      } else if (event is NewNodeAdded) {
        network("+ Node ${event.node.address?.toString()}:${event.node.port}");
      } else if (event is NodeRemoved) {
        warn(
          "- Node ${(event as NodeRemoved).node.address?.toString()}:${(event as NodeRemoved).node.port}",
        );
      } else {
        verbose("[${event.runtimeType}]");
      }
    });

    await dht.bootstrap();
    verbose("Bootstrap completed");
    dht.requestPeers(h);

    Timer.periodic(Duration(seconds: 30), (timer) {
      verbose("Requesting peers again...");
      dht.requestPeers(h);
    });

    await Future.delayed(Duration(minutes: 10));
  }

  String blinkHash(String input) {
    String a = sha512.convert(utf8.encode("blink?$input")).toString();
    String b = sha256.convert(utf8.encode("$input!blink")).toString();
    var hash = sha1.convert(utf8.encode("$a${input.split("").join(".?")}$b"));
    return String.fromCharCodes(hash.bytes);
  }

  Future<void> connectToPeer(String address, int port) async {
    try {
      info("Attempting to connect to peer: $address:$port");
      Socket socket = await Socket.connect(address, port);
      success('Connected to peer');
      socket.write('Hello from chat!');

      socket.listen((data) {
        network('Received: ${String.fromCharCodes(data)}');
      });
    } catch (e) {
      error('Connection failed: $e');
    }
  }
}
