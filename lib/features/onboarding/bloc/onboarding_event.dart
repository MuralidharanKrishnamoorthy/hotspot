import 'package:equatable/equatable.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();
  @override
  List<Object?> get props => [];
}

class OnboardingTextUpdated extends OnboardingEvent {
  final String text;
  const OnboardingTextUpdated(this.text);
  @override
  List<Object?> get props => [text];
}

class OnboardingAudioRecordingStarted extends OnboardingEvent {
  const OnboardingAudioRecordingStarted();
}

class OnboardingAudioRecordingCompleted extends OnboardingEvent {
  final String path;
  final int duration; // Duration in seconds
  const OnboardingAudioRecordingCompleted(this.path, this.duration);
  @override
  List<Object?> get props => [path, duration];
}

class OnboardingAudioDeleted extends OnboardingEvent {
  const OnboardingAudioDeleted();
}

class OnboardingVideoRecordingStarted extends OnboardingEvent {
  const OnboardingVideoRecordingStarted();
}

class OnboardingVideoRecordingCompleted extends OnboardingEvent {
  final String path;
  final int duration; // Duration in seconds
  const OnboardingVideoRecordingCompleted(this.path, this.duration);
  @override
  List<Object?> get props => [path, duration];
}

class OnboardingVideoDeleted extends OnboardingEvent {
  const OnboardingVideoDeleted();
}

class OnboardingAudioPlaybackStarted extends OnboardingEvent {
  const OnboardingAudioPlaybackStarted();
}

class OnboardingAudioPlaybackStopped extends OnboardingEvent {
  const OnboardingAudioPlaybackStopped();
}
