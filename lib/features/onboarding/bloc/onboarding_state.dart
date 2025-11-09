import 'package:equatable/equatable.dart';

enum RecordingStatus { idle, recording, recorded }

class OnboardingState extends Equatable {
  final String text;
  final String? audioPath;
  final String? videoPath;
  final int? audioDuration; // Duration in seconds
  final int? videoDuration; // Duration in seconds
  final RecordingStatus audioStatus;
  final RecordingStatus videoStatus;
  final bool isPlayingAudio;

  const OnboardingState({
    this.text = '',
    this.audioPath,
    this.videoPath,
    this.audioDuration,
    this.videoDuration,
    this.audioStatus = RecordingStatus.idle,
    this.videoStatus = RecordingStatus.idle,
    this.isPlayingAudio = false,
  });

  OnboardingState copyWith({
    String? text,
    String? audioPath,
    String? videoPath,
    int? audioDuration,
    int? videoDuration,
    RecordingStatus? audioStatus,
    RecordingStatus? videoStatus,
    bool? isPlayingAudio,
    bool clearAudioPath = false,
    bool clearVideoPath = false,
  }) => OnboardingState(
    text: text ?? this.text,
    audioPath: clearAudioPath ? null : (audioPath ?? this.audioPath),
    videoPath: clearVideoPath ? null : (videoPath ?? this.videoPath),
    audioDuration: clearAudioPath ? null : audioDuration,
    videoDuration: clearVideoPath ? null : videoDuration,
    audioStatus: audioStatus ?? this.audioStatus,
    videoStatus: videoStatus ?? this.videoStatus,
    isPlayingAudio: isPlayingAudio ?? this.isPlayingAudio,
  );

  @override
  List<Object?> get props => [
    text,
    audioPath,
    videoPath,
    audioDuration,
    videoDuration,
    audioStatus,
    videoStatus,
    isPlayingAudio,
  ];
}
