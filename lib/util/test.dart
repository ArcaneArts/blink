import 'dart:convert';
import 'dart:typed_data';

import 'package:blink/util/mnode.dart';
import 'package:dcid/dcid.dart';

Future<void> test() async {
  MobileP2PNode node = MobileP2PNode();
  try {
    // Initialize the mobile node
    await node.initialize(enableBackgroundRefresh: true);

    // Simulate mobile app lifecycle
    await _simulateMobileUsage(node);
  } catch (e, stackTrace) {
    print('Error: $e');
    print('Stack trace: $stackTrace');
  } finally {
    await node.shutdown();
  }
}

/// Simulate typical mobile app usage patterns
Future<void> _simulateMobileUsage(MobileP2PNode node) async {
  CID cid = CID.fromData(
    CID.V1,
    'dag-pb',
    Uint8List.fromList(utf8.encode('blinkapptest__dan__aidan')),
  );
  print(cid);
  print('\n=== Mobile P2P Node Usage Simulation ===');

  // Simulate finding some content
  print('\n--- Simulating content discovery ---');
  await node.findContentProviders(cid.toString(), maxProviders: 2);

  // Simulate retrieving a value
  print('\n--- Simulating value retrieval ---');
  await node.retrieveValue('mobile-test-key');

  // Simulate finding a service
  print('\n--- Simulating service discovery ---');
  await node.findServiceProviders('mobile-chat-service', maxPeers: 2);

  // Initial network stats
  for (int i = 0; i < 30; i++) {
    await node.printNetworkStats();
    await Future.delayed(Duration(seconds: 5));
  }

  // Simulate app going to background (pause background tasks)
  print('\n--- Simulating app backgrounding ---');
  node.pauseBackgroundTasks();
  await Future.delayed(Duration(seconds: 5));

  // Simulate app coming to foreground (resume background tasks)
  print('\n--- Simulating app foregrounding ---');
  node.resumeBackgroundTasks();

  // Manual refresh when user actively uses the app
  print('\n--- Simulating manual refresh ---');
  await node.refresh();

  // Final network stats
  print('\n--- Final network statistics ---');
  await node.printNetworkStats();

  print('\n--- Mobile simulation completed ---');
}
