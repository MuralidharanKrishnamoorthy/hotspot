import 'package:equatable/equatable.dart';

abstract class ExperiencesEvent extends Equatable {
  const ExperiencesEvent();
  @override
  List<Object?> get props => [];
}

class ExperiencesRequested extends ExperiencesEvent {
  const ExperiencesRequested();
}

class ExperienceToggled extends ExperiencesEvent {
  final int id;
  const ExperienceToggled(this.id);
  @override
  List<Object?> get props => [id];
}

class ExperienceNoteUpdated extends ExperiencesEvent {
  final String note;
  const ExperienceNoteUpdated(this.note);
  @override
  List<Object?> get props => [note];
}

class ExperiencesCleared extends ExperiencesEvent {
  const ExperiencesCleared();
}
