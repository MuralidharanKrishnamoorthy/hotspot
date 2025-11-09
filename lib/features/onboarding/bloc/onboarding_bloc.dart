import 'package:bloc/bloc.dart';
import 'onboarding_event.dart';
import 'onboarding_state.dart';

/// BLoC that manages the state for the onboarding question screen.
///
/// Handles:
/// - Text input updates
/// - Audio recording lifecycle (start, complete, delete)
/// - Video recording lifecycle (start, complete, delete)
/// - Audio playback state
class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(const OnboardingState()) {
    on<OnboardingTextUpdated>(_onTextUpdated);
    on<OnboardingAudioRecordingStarted>(_onAudioRecordingStarted);
    on<OnboardingAudioRecordingCompleted>(_onAudioRecordingCompleted);
    on<OnboardingAudioDeleted>(_onAudioDeleted);
    on<OnboardingVideoRecordingStarted>(_onVideoRecordingStarted);
    on<OnboardingVideoRecordingCompleted>(_onVideoRecordingCompleted);
    on<OnboardingVideoDeleted>(_onVideoDeleted);
    on<OnboardingAudioPlaybackStarted>(_onAudioPlaybackStarted);
    on<OnboardingAudioPlaybackStopped>(_onAudioPlaybackStopped);
  }

  void _onTextUpdated(
    OnboardingTextUpdated event,
    Emitter<OnboardingState> emit,
  ) {
    emit(state.copyWith(text: event.text));
  }

  void _onAudioRecordingStarted(
    OnboardingAudioRecordingStarted event,
    Emitter<OnboardingState> emit,
  ) {
    emit(state.copyWith(audioStatus: RecordingStatus.recording));
  }

  void _onAudioRecordingCompleted(
    OnboardingAudioRecordingCompleted event,
    Emitter<OnboardingState> emit,
  ) {
    emit(
      state.copyWith(
        audioPath: event.path,
        audioDuration: event.duration,
        audioStatus: RecordingStatus.recorded,
      ),
    );
  }

  void _onAudioDeleted(
    OnboardingAudioDeleted event,
    Emitter<OnboardingState> emit,
  ) {
    emit(
      state.copyWith(
        clearAudioPath: true,
        audioStatus: RecordingStatus.idle,
        isPlayingAudio: false,
      ),
    );
  }

  void _onVideoRecordingStarted(
    OnboardingVideoRecordingStarted event,
    Emitter<OnboardingState> emit,
  ) {
    emit(state.copyWith(videoStatus: RecordingStatus.recording));
  }

  void _onVideoRecordingCompleted(
    OnboardingVideoRecordingCompleted event,
    Emitter<OnboardingState> emit,
  ) {
    emit(
      state.copyWith(
        videoPath: event.path,
        videoDuration: event.duration,
        videoStatus: RecordingStatus.recorded,
      ),
    );
  }

  void _onVideoDeleted(
    OnboardingVideoDeleted event,
    Emitter<OnboardingState> emit,
  ) {
    emit(
      state.copyWith(clearVideoPath: true, videoStatus: RecordingStatus.idle),
    );
  }

  void _onAudioPlaybackStarted(
    OnboardingAudioPlaybackStarted event,
    Emitter<OnboardingState> emit,
  ) {
    emit(state.copyWith(isPlayingAudio: true));
  }

  void _onAudioPlaybackStopped(
    OnboardingAudioPlaybackStopped event,
    Emitter<OnboardingState> emit,
  ) {
    emit(state.copyWith(isPlayingAudio: false));
  }
}
