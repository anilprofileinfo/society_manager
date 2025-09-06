part of 'event_bloc.dart';

abstract class EventState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EventLoading extends EventState {}
class EventLoaded extends EventState {
  final List<EventModel> events;
  EventLoaded(this.events);
  @override
  List<Object?> get props => [events];
}
class EventError extends EventState {
  final String message;
  EventError(this.message);
  @override
  List<Object?> get props => [message];
}
