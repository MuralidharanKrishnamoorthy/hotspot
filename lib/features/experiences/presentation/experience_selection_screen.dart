import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/dio_client.dart';
import '../bloc/experiences_bloc.dart';
import '../bloc/experiences_event.dart';
import '../bloc/experiences_state.dart';
import '../data/experiences_repository.dart';
import 'widgets/experience_card.dart';
import '../../../design_system/widgets/frosted_button.dart';
import '../../../design_system/widgets/wave_progress.dart';

class ExperienceSelectionScreen extends StatelessWidget {
  const ExperienceSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => ExperiencesRepository(DioClient()),
      child: BlocProvider(
        create: (ctx) =>
            ExperiencesBloc(ctx.read<ExperiencesRepository>())
              ..add(const ExperiencesRequested()),
        child: const _ExperienceSelectionView(),
      ),
    );
  }
}

class _ExperienceSelectionView extends StatefulWidget {
  const _ExperienceSelectionView();
  @override
  State<_ExperienceSelectionView> createState() =>
      _ExperienceSelectionViewState();
}

class _ExperienceSelectionViewState extends State<_ExperienceSelectionView> {
  final _scrollController = ScrollController();
  double _progress = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
              // Fixed header section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    // Top wave progress and close button row
                    Row(
                      children: [
                        // Hide back button on the first screen (nothing to pop)
                        Navigator.of(context).canPop()
                            ? IconButton(
                                icon: const Icon(Icons.arrow_back),
                                onPressed: () => Navigator.of(context).pop(),
                              )
                            : const SizedBox(width: 48),
                        Expanded(child: WaveProgress(progress: _progress)),
                        BlocBuilder<ExperiencesBloc, ExperiencesState>(
                          builder: (context, state) {
                            return state.selectedIds.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () => context
                                        .read<ExperiencesBloc>()
                                        .add(const ExperiencesCleared()),
                                  )
                                : const SizedBox(width: 48);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'What kind of experiences do you want to host?',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
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
                      // Experience cards in horizontal list
                      SizedBox(
                        height: 136,
                        child: BlocBuilder<ExperiencesBloc, ExperiencesState>(
                          builder: (context, state) {
                            switch (state.status) {
                              case ExperiencesStatus.loading:
                              case ExperiencesStatus.initial:
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              case ExperiencesStatus.failure:
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.error_outline,
                                        size: 48,
                                        color: Colors.red,
                                      ),
                                      const SizedBox(height: 16),
                                      const Text(
                                        'Failed to load experiences',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      TextButton.icon(
                                        onPressed: () {
                                          context.read<ExperiencesBloc>().add(
                                            const ExperiencesRequested(),
                                          );
                                        },
                                        icon: const Icon(Icons.refresh),
                                        label: const Text('Retry'),
                                      ),
                                    ],
                                  ),
                                );
                              case ExperiencesStatus.success:
                                return NotificationListener<ScrollNotification>(
                                  onNotification: (n) {
                                    final max =
                                        _scrollController
                                            .position
                                            .hasContentDimensions
                                        ? _scrollController
                                              .position
                                              .maxScrollExtent
                                        : 0.0;
                                    final value = (max == 0)
                                        ? 0.0
                                        : (_scrollController.offset / max)
                                              .clamp(0.0, 1.0);
                                    if ((value - _progress).abs() > 0.01) {
                                      setState(() => _progress = value);
                                    }
                                    return false;
                                  },
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    controller: _scrollController,
                                    itemCount: state.items.length,
                                    itemBuilder: (context, i) {
                                      final e = state.items[i];
                                      return ExperienceCard(
                                        title: e.name,
                                        imageUrl: e.imageUrl,
                                        selected: state.selectedIds.contains(
                                          e.id,
                                        ),
                                        onTap: () {
                                          // Haptic feedback for better UX
                                          HapticFeedback.selectionClick();

                                          context.read<ExperiencesBloc>().add(
                                            ExperienceToggled(e.id),
                                          );
                                          // Slide the tapped card to the first (left-most) position
                                          const itemExtent =
                                              112.0; // ~96 width + 16 horizontal margin
                                          final target = (i * itemExtent).clamp(
                                            0.0,
                                            _scrollController
                                                .position
                                                .maxScrollExtent,
                                          );
                                          _scrollController.animateTo(
                                            target,
                                            duration: const Duration(
                                              milliseconds: 250,
                                            ),
                                            curve: Curves.easeOut,
                                          );
                                        },
                                      );
                                    },
                                  ),
                                );
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Text field for description
                      BlocBuilder<ExperiencesBloc, ExperiencesState>(
                        buildWhen: (p, c) => p.note != c.note,
                        builder: (context, state) {
                          return TextField(
                            maxLines: 5,
                            maxLength: 250,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(250),
                            ],
                            onChanged: (v) => context
                                .read<ExperiencesBloc>()
                                .add(ExperienceNoteUpdated(v)),
                            decoration: const InputDecoration(
                              hintText: 'Describe your perfect hotspot',
                              prefix: Text('/ '),
                              counterText: '',
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

              // Fixed bottom button
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: SizedBox(
                  width: double.infinity,
                  child: BlocBuilder<ExperiencesBloc, ExperiencesState>(
                    builder: (context, state) {
                      return _NextButton(
                        onPressed: () {
                          final ids = state.selectedIds.toList();
                          final text = state.note;

                          // Validation: at least one experience must be selected
                          if (ids.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please select at least one experience type',
                                ),
                                behavior: SnackBarBehavior.floating,
                                duration: Duration(seconds: 2),
                              ),
                            );
                            return;
                          }

                          debugPrint('Selected IDs: $ids');
                          debugPrint('Note: "$text"');
                          Navigator.of(context).pushNamed('/question');
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NextButton extends StatelessWidget {
  const _NextButton({required this.onPressed});
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return FrostedButton(onPressed: onPressed, label: 'Next', icon: Icons.east);
  }
}
