import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class SensorSchema {
  ///Websocket Link
  WebSocketLink webSocketLink = WebSocketLink(
    "wss://medikal-backend.herokuapp.com/query",
    config: SocketClientConfig(
      autoReconnect: true,
      delayBetweenReconnectionAttempts: const Duration(seconds: 1),
    ),
  );

  ///Auth client
  ValueNotifier<GraphQLClient> getClient() {
    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        link: HttpLink('https://medikal-backend.herokuapp.com/query')
            .concat(webSocketLink),
        // The default cache is the InMemoryStore, which does NOT persist to disk
        cache: GraphQLCache(store: HiveStore()),
      ),
    );

    return client;
  }
}
