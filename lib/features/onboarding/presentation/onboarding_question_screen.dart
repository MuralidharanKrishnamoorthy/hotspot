import 'dart:async';
import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import '../bloc/onboarding_bloc.dart';
import '../bloc/onboarding_event.dart';
import '../bloc/onboarding_state.dart';
import '../../../design_system/widgets/frosted_button.dart';

class OnboardingQuestionScreen extends StatelessWidget {
  const OnboardingQuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingBloc(),
      child: const _OnboardingQuestionView(),
    );
  }
}

class _OnboardingQuestionView extends StatefulWidget {
  const _OnboardingQuestionView();

  @override
  State<_OnboardingQuestionView> createState() =>
      _OnboardingQuestionViewState();
}

class _OnboardingQuestionViewState extends State<_OnboardingQuestionView>
    with SingleTickerProviderStateMixin {
  late final RecorderController _recorder;
  late final PlayerController _player;
  final _picker = ImagePicker();
  Timer? _recordingTimer;
  int _recordingSeconds = 0;

  @override
  void initState() {
    super.initState();
    _recorder = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 44100;

    _player = PlayerController();
  }

  @override
  void dispose() {
    _recordingTimer?.cancel();
    _recorder.dispose();
    _player.dispose();
    super.dispose();
  }

  Future<String> _tempAudioPath() async {
    final dir = await getTemporaryDirectory();
    return '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
  }

  Future<void> _startAudioRecording() async {
    try {
      context.read<OnboardingBloc>().add(
        const OnboardingAudioRecordingStarted(),
      );
      final path = await _tempAudioPath();
      await _recorder.record(path: path);

      _recordingSeconds = 0;
      _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (mounted) setState(() => _recordingSeconds++);
      });
    } catch (e) {
      debugPrint('Error starting audio recording: $e');
    }
  }

  Future<void> _stopAudioRecording() async {
    _recordingTimer?.cancel();
    final path = await _recorder.stop();
    if (path != null && mounted) {
      context.read<OnboardingBloc>().add(
        OnboardingAudioRecordingCompleted(path, _recordingSeconds),
      );
    }
    setState(() => _recordingSeconds = 0);
  }

  Future<void> _cancelAudioRecording() async {
    _recordingTimer?.cancel();
    await _recorder.stop();
    context.read<OnboardingBloc>().add(const OnboardingAudioDeleted());
    setState(() => _recordingSeconds = 0);
  }

  Future<void> _recordVideo() async {
    try {
      context.read<OnboardingBloc>().add(
        const OnboardingVideoRecordingStarted(),
      );
      final video = await _picker.pickVideo(
        source: ImageSource.camera,
        maxDuration: const Duration(minutes: 2),
      );

      if (video != null && mounted) {
        final duration = await _getVideoDuration(video.path);
        context.read<OnboardingBloc>().add(
          OnboardingVideoRecordingCompleted(video.path, duration),
        );
      } else if (mounted) {
        context.read<OnboardingBloc>().add(const OnboardingVideoDeleted());
      }
    } catch (e) {
      debugPrint('Error recording video: $e');
      if (mounted) {
        context.read<OnboardingBloc>().add(const OnboardingVideoDeleted());
      }
    }
  }

  Future<int> _getVideoDuration(String videoPath) async {
    try {
      final controller = VideoPlayerController.file(File(videoPath));
      await controller.initialize();
      final durationInSeconds = controller.value.duration.inSeconds;
      await controller.dispose();
      return durationInSeconds;
    } catch (e) {
      debugPrint('Error getting video duration: $e');
      return 0;
    }
  }

  void _showVideoPreview(String videoPath) {
    showDialog(
      context: context,
      builder: (context) => _VideoPreviewDialog(videoPath: videoPath),
    );
  }

  Future<void> _playAudio(String path) async {
    try {
      context.read<OnboardingBloc>().add(
        const OnboardingAudioPlaybackStarted(),
      );
      await _player.preparePlayer(path: path);
      await _player.startPlayer();

      _player.onCompletion.listen((_) {
        if (mounted) {
          context.read<OnboardingBloc>().add(
            const OnboardingAudioPlaybackStopped(),
          );
        }
      });
    } catch (e) {
      debugPrint('Error playing audio: $e');
      if (mounted) {
        context.read<OnboardingBloc>().add(
          const OnboardingAudioPlaybackStopped(),
        );
      }
    }
  }

  Future<void> _stopAudio() async {
    try {
      await _player.stopPlayer();
      if (mounted) {
        context.read<OnboardingBloc>().add(
          const OnboardingAudioPlaybackStopped(),
        );
      }
    } catch (e) {
      debugPrint('Error stopping audio: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(automaticallyImplyLeading: false, toolbarHeight: 0),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/images/Background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Fixed header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        // Hide back button on the first screen (nothing to pop)
                        Navigator.of(context).canPop()
                            ? IconButton(
                                icon: const Icon(Icons.arrow_back),
                                onPressed: () => Navigator.of(context).pop(),
                              )
                            : const SizedBox(width: 48),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Why do you want to host with us?',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tell us about your intent and what motivates you to create experiences.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),

              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Text field
                      BlocBuilder<OnboardingBloc, OnboardingState>(
                        buildWhen: (p, c) => p.text != c.text,
                        builder: (context, state) {
                          return TextField(
                            maxLines: 5,
                            maxLength: 600,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(600),
                            ],
                            onChanged: (v) => context
                                .read<OnboardingBloc>()
                                .add(OnboardingTextUpdated(v)),
                            decoration: const InputDecoration(
                              hintText: 'Start typing here',
                              prefix: Text('/ '),
                              counterText: '',
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),

                      // Audio recording/recorded card
                      BlocBuilder<OnboardingBloc, OnboardingState>(
                        buildWhen: (p, c) =>
                            p.audioStatus != c.audioStatus ||
                            p.audioPath != c.audioPath ||
                            p.isPlayingAudio != c.isPlayingAudio,
                        builder: (context, state) {
                          if (state.audioStatus == RecordingStatus.recording ||
                              _recorder.isRecording) {
                            return _AudioRecordingCard(
                              recorder: _recorder,
                              duration: _recordingSeconds,
                              onStop: _stopAudioRecording,
                              onCancel: _cancelAudioRecording,
                            );
                          } else if (state.audioStatus ==
                                  RecordingStatus.recorded &&
                              state.audioPath != null) {
                            return _AudioRecordedCard(
                              audioPath: state.audioPath!,
                              duration: state.audioDuration ?? 0,
                              isPlaying: state.isPlayingAudio,
                              onPlay: () => _playAudio(state.audioPath!),
                              onStop: _stopAudio,
                              onDelete: () => context
                                  .read<OnboardingBloc>()
                                  .add(const OnboardingAudioDeleted()),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),

                      // Video recorded card
                      BlocBuilder<OnboardingBloc, OnboardingState>(
                        buildWhen: (p, c) =>
                            p.videoStatus != c.videoStatus ||
                            p.videoPath != c.videoPath,
                        builder: (context, state) {
                          if (state.videoStatus == RecordingStatus.recorded &&
                              state.videoPath != null) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: _VideoRecordedCard(
                                videoPath: state.videoPath!,
                                duration: state.videoDuration ?? 0,
                                onPreview: () =>
                                    _showVideoPreview(state.videoPath!),
                                onDelete: () => context
                                    .read<OnboardingBloc>()
                                    .add(const OnboardingVideoDeleted()),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

              // Fixed bottom section with buttons (voice, video, next in one row)
              BlocBuilder<OnboardingBloc, OnboardingState>(
                builder: (context, state) {
                  final showAudioButton =
                      state.audioStatus == RecordingStatus.idle;
                  final showVideoButton =
                      state.videoStatus == RecordingStatus.idle;
                  final anyButtonVisible = showAudioButton || showVideoButton;

                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      alignment: Alignment.centerLeft,
                      child: anyButtonVisible
                          ? Row(
                              children: [
                                if (showAudioButton)
                                  _RecordButton(
                                    icon: Icons.mic,
                                    onPressed: _startAudioRecording,
                                  ),
                                if (showAudioButton && showVideoButton)
                                  const SizedBox(width: 12),
                                if (showVideoButton)
                                  _RecordButton(
                                    icon: Icons.videocam,
                                    onPressed: _recordVideo,
                                  ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: FrostedButton(
                                    onPressed: () {
                                      debugPrint(
                                        'Text: ${state.text.length} characters',
                                      );
                                      debugPrint(
                                        'Audio: ${state.audioPath ?? "None"}',
                                      );
                                      debugPrint(
                                        'Video: ${state.videoPath ?? "None"}',
                                      );
                                    },
                                    label: 'Next',
                                    icon: Icons.east,
                                  ),
                                ),
                              ],
                            )
                          : SizedBox(
                              width: double.infinity,
                              child: FrostedButton(
                                onPressed: () {
                                  debugPrint(
                                    'Text: ${state.text.length} characters',
                                  );
                                  debugPrint(
                                    'Audio: ${state.audioPath ?? "None"}',
                                  );
                                  debugPrint(
                                    'Video: ${state.videoPath ?? "None"}',
                                  );
                                },
                                label: 'Next',
                                icon: Icons.east,
                              ),
                            ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Recording button widget
class _RecordButton extends StatelessWidget {
  const _RecordButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
          ),
          child: Icon(icon, size: 24, color: Colors.white),
        ),
      ),
    );
  }
}

// Audio recording in progress card
class _AudioRecordingCard extends StatelessWidget {
  const _AudioRecordingCard({
    required this.recorder,
    required this.duration,
    required this.onStop,
    required this.onCancel,
  });

  final RecorderController recorder;
  final int duration;
  final VoidCallback onStop;
  final VoidCallback onCancel;

  String _formatDuration(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Recording Audio...',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[300],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close, size: 20, color: Colors.white70),
                onPressed: onCancel,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.stop, color: Colors.blue, size: 20),
                  onPressed: onStop,
                  padding: EdgeInsets.zero,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AudioWaveforms(
                  enableGesture: false,
                  size: const Size(double.infinity, 40),
                  recorderController: recorder,
                  waveStyle: const WaveStyle(
                    waveColor: Colors.blue,
                    showDurationLabel: false,
                    spacing: 4,
                    extendWaveform: true,
                    scaleFactor: 80,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                _formatDuration(duration),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Audio recorded card with playback
class _AudioRecordedCard extends StatelessWidget {
  const _AudioRecordedCard({
    required this.audioPath,
    required this.duration,
    required this.isPlaying,
    required this.onPlay,
    required this.onStop,
    required this.onDelete,
  });

  final String audioPath;
  final int duration;
  final bool isPlaying;
  final VoidCallback onPlay;
  final VoidCallback onStop;
  final VoidCallback onDelete;

  String _formatDuration(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.5), width: 1),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: isPlaying ? onStop : onPlay,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isPlaying ? Icons.stop : Icons.play_arrow,
                color: Colors.blue,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Audio Recorded',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '• ${_formatDuration(duration)}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.delete_outline,
              color: Colors.blue,
              size: 22,
            ),
            onPressed: onDelete,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          ),
        ],
      ),
    );
  }
}

// Video recorded card
class _VideoRecordedCard extends StatelessWidget {
  const _VideoRecordedCard({
    required this.videoPath,
    required this.duration,
    required this.onPreview,
    required this.onDelete,
  });

  final String videoPath;
  final int duration;
  final VoidCallback onPreview;
  final VoidCallback onDelete;

  String _formatDuration(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.5), width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onPreview,
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 56,
                      height: 56,
                      color: Colors.grey[850],
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (File(videoPath).existsSync())
                            Image.file(
                              File(videoPath),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.videocam,
                                  size: 28,
                                  color: Colors.white70,
                                );
                              },
                            )
                          else
                            const Icon(
                              Icons.videocam,
                              size: 28,
                              color: Colors.white70,
                            ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const Icon(
                            Icons.play_circle_outline,
                            size: 32,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Video Recorded',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '• ${_formatDuration(duration)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.delete_outline,
              color: Colors.blue,
              size: 22,
            ),
            onPressed: onDelete,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          ),
        ],
      ),
    );
  }
}

// Video preview dialog
class _VideoPreviewDialog extends StatefulWidget {
  const _VideoPreviewDialog({required this.videoPath});

  final String videoPath;

  @override
  State<_VideoPreviewDialog> createState() => _VideoPreviewDialogState();
}

class _VideoPreviewDialogState extends State<_VideoPreviewDialog> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      _controller = VideoPlayerController.file(File(widget.videoPath));
      await _controller.initialize();
      await _controller.setLooping(true);
      await _controller.play();
      if (mounted) {
        setState(() => _isInitialized = true);
      }
    } catch (e) {
      debugPrint('Error initializing video: $e');
      if (mounted) {
        setState(() => _hasError = true);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black,
      insetPadding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              if (_hasError)
                Container(
                  height: 300,
                  alignment: Alignment.center,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 48, color: Colors.red),
                      SizedBox(height: 16),
                      Text(
                        'Unable to load video',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                )
              else if (!_isInitialized)
                Container(
                  height: 300,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                )
              else
                AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black.withOpacity(0.5),
                  ),
                ),
              ),
            ],
          ),
          if (_isInitialized && !_hasError)
            Container(
              color: Colors.black,
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      _controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        if (_controller.value.isPlaying) {
                          _controller.pause();
                        } else {
                          _controller.play();
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
