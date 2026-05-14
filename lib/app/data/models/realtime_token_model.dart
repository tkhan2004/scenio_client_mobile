class RealtimeTokenModel {
  const RealtimeTokenModel({
    required this.sessionId,
    required this.provider,
    required this.clientSecret,
    required this.sessionConfig,
    required this.selectedVoice,
  });

  factory RealtimeTokenModel.fromMap(Map<String, dynamic> map) {
    return RealtimeTokenModel(
      sessionId: map['sessionId'] as String? ?? '',
      provider: map['realtimeProvider'] as String? ?? 'OPENAI',
      clientSecret: RealtimeClientSecretModel.fromMap(
        map['clientSecret'] as Map<String, dynamic>? ?? <String, dynamic>{},
      ),
      sessionConfig: RealtimeSessionConfigModel.fromMap(
        map['sessionConfig'] as Map<String, dynamic>? ?? <String, dynamic>{},
      ),
      selectedVoice: RealtimeSelectedVoiceModel.fromMap(
        map['selectedVoice'] as Map<String, dynamic>? ?? <String, dynamic>{},
      ),
    );
  }

  final String sessionId;
  final String provider;
  final RealtimeClientSecretModel clientSecret;
  final RealtimeSessionConfigModel sessionConfig;
  final RealtimeSelectedVoiceModel selectedVoice;
}

class RealtimeClientSecretModel {
  const RealtimeClientSecretModel({required this.value, this.expiresAt});

  factory RealtimeClientSecretModel.fromMap(Map<String, dynamic> map) {
    final dynamic rawExpiresAt = map['expiresAt'];

    return RealtimeClientSecretModel(
      value: map['value'] as String? ?? '',
      expiresAt: rawExpiresAt is num
          ? DateTime.fromMillisecondsSinceEpoch(rawExpiresAt.toInt() * 1000)
          : DateTime.tryParse(rawExpiresAt as String? ?? ''),
    );
  }

  final String value;
  final DateTime? expiresAt;
}

class RealtimeSessionConfigModel {
  const RealtimeSessionConfigModel({
    required this.model,
    required this.voice,
    required this.transcriptionModel,
    required this.turnDetection,
    required this.instructions,
  });

  factory RealtimeSessionConfigModel.fromMap(Map<String, dynamic> map) {
    return RealtimeSessionConfigModel(
      model: map['model'] as String? ?? 'gpt-realtime',
      voice: map['voice'] as String? ?? '',
      transcriptionModel:
          map['transcriptionModel'] as String? ?? 'gpt-4o-mini-transcribe',
      turnDetection: map['turnDetection'] as String? ?? 'server_vad',
      instructions: map['instructions'] as String? ?? '',
    );
  }

  final String model;
  final String voice;
  final String transcriptionModel;
  final String turnDetection;
  final String instructions;
}

class RealtimeSelectedVoiceModel {
  const RealtimeSelectedVoiceModel({
    required this.id,
    required this.displayName,
    required this.realtimeVoiceId,
  });

  factory RealtimeSelectedVoiceModel.fromMap(Map<String, dynamic> map) {
    return RealtimeSelectedVoiceModel(
      id: map['id'] as String? ?? '',
      displayName: map['displayName'] as String? ?? 'Scenio voice',
      realtimeVoiceId: map['realtimeVoiceId'] as String? ?? '',
    );
  }

  final String id;
  final String displayName;
  final String realtimeVoiceId;
}
