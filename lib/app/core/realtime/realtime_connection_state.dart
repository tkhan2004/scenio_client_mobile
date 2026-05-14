enum RealtimeConnectionPhase {
  idle,
  requestingPermission,
  connecting,
  connected,
  userSpeaking,
  aiThinking,
  aiSpeaking,
  reconnecting,
  paused,
  finishing,
  completed,
  error,
}

extension RealtimeConnectionPhaseX on RealtimeConnectionPhase {
  bool get isLive {
    switch (this) {
      case RealtimeConnectionPhase.connected:
      case RealtimeConnectionPhase.userSpeaking:
      case RealtimeConnectionPhase.aiThinking:
      case RealtimeConnectionPhase.aiSpeaking:
      case RealtimeConnectionPhase.paused:
        return true;
      case RealtimeConnectionPhase.idle:
      case RealtimeConnectionPhase.requestingPermission:
      case RealtimeConnectionPhase.connecting:
      case RealtimeConnectionPhase.reconnecting:
      case RealtimeConnectionPhase.finishing:
      case RealtimeConnectionPhase.completed:
      case RealtimeConnectionPhase.error:
        return false;
    }
  }
}
