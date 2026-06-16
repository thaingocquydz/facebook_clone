import 'package:equatable/equatable.dart';
import 'package:facebook_clone/features/messages/models/conversation.dart';

abstract class ConversationState extends Equatable {
  const ConversationState();

  @override
  List<Object?> get props => [];
}

class ConversationInitial extends ConversationState {}

class ConversationLoading extends ConversationState {}

class ConversationLoaded extends ConversationState {
  final List<Conversation> conversations;

  const ConversationLoaded({required this.conversations});

  @override
  List<Object?> get props => [conversations];
}

class ConversationFailure extends ConversationState {
  final String error;

  const ConversationFailure(this.error);

  @override
  List<Object?> get props => [error];
}
