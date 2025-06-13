import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thamarat/data/repositories/chat_repository.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;

  ChatBloc({required this.chatRepository}) : super(ChatInitial()) {
    on<LoadMessages>(_onLoadMessages);
    on<SendMessage>(_onSendMessage);
    on<RefreshMessages>(_onRefreshMessages);
  }

  Future<void> _onLoadMessages(LoadMessages event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      final messages = await chatRepository.getMessages();
      emit(ChatLoaded(messages));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _onSendMessage(SendMessage event, Emitter<ChatState> emit) async {
    try {
      final message = await chatRepository.sendMessage(event.message);
      emit(MessageSent(message));
      // Reload messages after sending
      final messages = await chatRepository.getMessages();
      emit(ChatLoaded(messages));
    } catch (e) {
      emit(MessageSendingError(e.toString()));
    }
  }

  Future<void> _onRefreshMessages(RefreshMessages event, Emitter<ChatState> emit) async {
    try {
      final messages = await chatRepository.getMessages();
      emit(ChatLoaded(messages));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }
}
