import 'package:equatable/equatable.dart';
import '../data/experience.dart';

enum ExperiencesStatus { initial, loading, success, failure }

class ExperiencesState extends Equatable {
  final ExperiencesStatus status;
  final List<Experience> items;
  final Set<int> selectedIds;
  final String note;
  final String? error;

  const ExperiencesState({
    this.status = ExperiencesStatus.initial,
    this.items = const [],
    this.selectedIds = const {},
    this.note = '',
    this.error,
  });

  ExperiencesState copyWith({
    ExperiencesStatus? status,
    List<Experience>? items,
    Set<int>? selectedIds,
    String? note,
    String? error,
  }) => ExperiencesState(
    status: status ?? this.status,
    items: items ?? this.items,
    selectedIds: selectedIds ?? this.selectedIds,
    note: note ?? this.note,
    error: error,
  );

  @override
  List<Object?> get props => [status, items, selectedIds, note, error];
}
