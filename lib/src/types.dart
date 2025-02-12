import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'extensions.dart';
import 'participant/participant.dart';

typedef CancelListenFunc = Function();

/// Protocol version to use when connecting to server.
/// Usually it's not recommended to change this.
enum ProtocolVersion {
  v2,
  v3,
  v4,
  v5,
}

/// Connection state type used throughout the SDK.
enum ConnectionState {
  disconnected,
  connected,
  reconnecting,
}

/// Connection quality between the [Participant] and server.
enum ConnectionQuality {
  unknown,
  poor,
  good,
  excellent,
}

/// Reliability used for publishing data through data channel.
enum Reliability {
  reliable,
  lossy,
}

enum TrackSource {
  unknown,
  camera,
  microphone,
  screenShareVideo,
  screenShareAudio,
}

/// The state of track data stream.
/// This is controlled by server to optimize bandwidth.
enum StreamState {
  paused,
  active,
}

enum CloseReason {
  network,
  // ...
}

/// The reason why a track failed to publish.
enum TrackSubscribeFailReason {
  invalidServerResponse,
  notTrackMetadataFound,
  unsupportedTrackType,
  // ...
}

/// The iceTransportPolicy used for [RTCConfiguration].
/// See https://developer.mozilla.org/en-US/docs/Web/API/RTCPeerConnection/RTCPeerConnection
enum RTCIceTransportPolicy {
  all,
  relay,
}

@immutable
class RTCConfiguration {
  final int? iceCandidatePoolSize;
  final List<RTCIceServer>? iceServers;
  final RTCIceTransportPolicy? iceTransportPolicy;

  const RTCConfiguration({
    this.iceCandidatePoolSize,
    this.iceServers,
    this.iceTransportPolicy,
  });

  Map<String, dynamic> toMap() {
    final iceServersMap = <Map<String, dynamic>>[
      if (iceServers != null)
        for (final e in iceServers!) e.toMap()
    ];

    return <String, dynamic>{
      // only supports unified plan
      'sdpSemantics': 'unified-plan',
      if (iceServersMap.isNotEmpty) 'iceServers': iceServersMap,
      if (iceCandidatePoolSize != null)
        'iceCandidatePoolSize': iceCandidatePoolSize,
      if (iceTransportPolicy != null)
        'iceTransportPolicy': iceTransportPolicy!.toStringValue(),
    };
  }

  // Returns new options with updated properties
  RTCConfiguration copyWith({
    int? iceCandidatePoolSize,
    List<RTCIceServer>? iceServers,
    RTCIceTransportPolicy? iceTransportPolicy,
  }) =>
      RTCConfiguration(
        iceCandidatePoolSize: iceCandidatePoolSize ?? this.iceCandidatePoolSize,
        iceServers: iceServers ?? this.iceServers,
        iceTransportPolicy: iceTransportPolicy ?? this.iceTransportPolicy,
      );
}

@immutable
class RTCIceServer {
  final List<String>? urls;
  final String? username;
  final String? credential;

  const RTCIceServer({
    this.urls,
    this.username,
    this.credential,
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
        if (urls?.isNotEmpty ?? false) 'urls': urls,
        if (username?.isNotEmpty ?? false) 'username': username,
        if (credential?.isNotEmpty ?? false) 'credential': credential,
      };
}

/// A simple class that represents dimensions of video.
@immutable
class VideoDimensions {
  final int width;
  final int height;

  const VideoDimensions(
    this.width,
    this.height,
  );

  @override
  String toString() => '${runtimeType}(${width}x${height})';

  /// Returns the larger value
  int max() => math.max(width, height);

  VideoDimensions copyWith({
    int? width,
    int? height,
  }) =>
      VideoDimensions(
        width ?? this.width,
        height ?? this.height,
      );
}
