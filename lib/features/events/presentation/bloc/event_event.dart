part of 'event_bloc.dart';

abstract class EventEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchEvents extends EventEvent {}
class AddEvent extends EventEvent {
  final EventModel event;
  AddEvent(this.event);
  @override
  List<Object?> get props => [event];
}
class DeleteEvent extends EventEvent {
  final String id;
  DeleteEvent(this.id);
  @override
  List<Object?> get props => [id];
}
class UpdateEvent extends EventEvent {
  final EventModel event;
  UpdateEvent(this.event);
  @override
  List<Object?> get props => [event];
}
