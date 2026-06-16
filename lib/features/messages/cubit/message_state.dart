import 'package:equatable/equatable.dart';
import 'package:facebook_clone/features/messages/models/message.dart';

abstract class MessageState extends Equatable {
  const MessageState();

  @override
  List<Object?> get props => [];
}

class MessageInitial extends MessageState {}

class MessageLoading extends MessageState {}

class MessageLoaded extends MessageState {
  final List<Message> messages;

  const MessageLoaded({required this.messages});

  @override
  List<Object?> get props => [messages];
}

class MessageFailure extends MessageState {
  final String error;

  const MessageFailure(this.error);

  @override
  List<Object?> get props => [error];
}
