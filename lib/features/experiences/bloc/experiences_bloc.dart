import 'package:bloc/bloc.dart';
import 'experiences_event.dart';
import 'experiences_state.dart';
import '../data/experiences_repository.dart';

class ExperiencesBloc extends Bloc<ExperiencesEvent, ExperiencesState> {
  ExperiencesBloc(this._repo) : super(const ExperiencesState()) {
    on<ExperiencesRequested>(_onRequested);
    on<ExperienceToggled>(_onToggled);
    on<ExperienceNoteUpdated>(_onNoteUpdated);
    on<ExperiencesCleared>(_onCleared);
  }

  final ExperiencesRepository _repo;

  Future<void> _onRequested(
    ExperiencesRequested event,
    Emitter<ExperiencesState> emit,
  ) async {
    emit(state.copyWith(status: ExperiencesStatus.loading));
    try {
      final items = await _repo.fetchExperiences();
      emit(state.copyWith(status: ExperiencesStatus.success, items: items));
    } catch (e) {
      emit(
        state.copyWith(status: ExperiencesStatus.failure, error: e.toString()),
      );
    }
  }

  void _onToggled(ExperienceToggled event, Emitter<ExperiencesState> emit) {
    final next = Set<int>.from(state.selectedIds);
    if (next.contains(event.id)) {
      next.remove(event.id);
    } else {
      next.add(event.id);
    }

    // Reorder items: selected first, keeping original relative order
    final reordered = List.of(state.items);
    reordered.sort((a, b) {
      final aSel = next.contains(a.id) ? 0 : 1;
      final bSel = next.contains(b.id) ? 0 : 1;
      return aSel.compareTo(bSel);
    });

    emit(state.copyWith(selectedIds: next, items: reordered));
  }

  void _onNoteUpdated(
    ExperienceNoteUpdated event,
    Emitter<ExperiencesState> emit,
  ) {
    emit(state.copyWith(note: event.note));
  }

  void _onCleared(ExperiencesCleared event, Emitter<ExperiencesState> emit) {
    emit(state.copyWith(selectedIds: const <int>{}));
  }
}
