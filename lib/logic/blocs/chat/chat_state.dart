import 'package:equatable/equatable.dart';
import 'package:thamarat/data/models/chat_model.dart';

abstract class ChatState extends Equatable {
  const ChatState();
  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<ChatMessage> messages;

  const ChatLoaded(this.messages);

  @override
  List<Object?> get props => [messages];
}

class ChatError extends ChatState {
  final String message;
  const ChatError(this.message);

  @override
  List<Object?> get props => [message];
}

class MessageSent extends ChatState {
  final ChatMessage message;

  const MessageSent(this.message);

  @override
  List<Object?> get props => [message];
}

class MessageSendingError extends ChatState {
  final String message;

  const MessageSendingError(this.message);

  @override
  List<Object?> get props => [message];
}
