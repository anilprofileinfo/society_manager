import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/event_model.dart';
import '../../data/repositories/event_repository.dart';

part 'event_event.dart';
part 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final EventRepository repository;
  EventBloc({required this.repository}) : super(EventLoading()) {
    on<FetchEvents>(_onFetchEvents);
    on<AddEvent>(_onAddEvent);
    on<DeleteEvent>(_onDeleteEvent);
    on<UpdateEvent>(_onUpdateEvent);
  }

  Future<void> _onFetchEvents(FetchEvents event, Emitter<EventState> emit) async {
    emit(EventLoading());
    try {
      final events = await repository.getEvents();
      emit(EventLoaded(events));
    } catch (e) {
      emit(EventError('Failed to fetch events'));
    }
  }

  Future<void> _onAddEvent(AddEvent event, Emitter<EventState> emit) async {
    try {
      await repository.addEvent(event.event);
      add(FetchEvents());
    } catch (e) {
      emit(EventError('Failed to add event'));
    }
  }

  Future<void> _onDeleteEvent(DeleteEvent event, Emitter<EventState> emit) async {
    try {
      await repository.deleteEvent(event.id);
      add(FetchEvents());
    } catch (e) {
      emit(EventError('Failed to delete event'));
    }
  }

  Future<void> _onUpdateEvent(UpdateEvent event, Emitter<EventState> emit) async {
    try {
      await repository.updateEvent(event.event);
      add(FetchEvents());
    } catch (e) {
      emit(EventError('Failed to update event'));
    }
  }
}
