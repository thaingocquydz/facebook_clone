import 'dart:async';

import 'package:dio/dio.dart';
import 'package:facebook_clone/features/messages/cubit/message_state.dart';
import 'package:facebook_clone/features/messages/models/message.dart';
import 'package:facebook_clone/features/messages/repository/message_repository.dart';
import 'package:facebook_clone/services/chat_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageCubit extends Cubit<MessageState> {
  final MessageRepository _repository;
  final ChatService _chat = ChatService();
  final String? currentUserId;
  StreamSubscription<Message>? _messageSub;

  MessageCubit(this._repository, {this.currentUserId}) : super(MessageInitial());

  Future<void> loadMessages(String conversationId) async {
    emit(MessageLoading());
    try {
      final messages = await _repository.getMessages(conversationId);
      final sorted = [...messages]
        ..sort((a, b) => a.sentAt.compareTo(b.sentAt));
      emit(MessageLoaded(messages: sorted));
      // Connect WS only after REST history is loaded
      connectRealtime(conversationId);
    } on DioException catch (e) {
      emit(MessageFailure(_handleDioError(e)));
    } catch (_) {
      emit(const MessageFailure('Đã có lỗi xảy ra, vui lòng thử lại'));
    }
  }

  void connectRealtime(String conversationId) {
    _messageSub?.cancel();
    _messageSub = _chat.onMessage.listen((msg) {
      final current = state;
      if (current is MessageLoaded) {
        // Replace matching optimistic (temp) message with the real one from server
        final withoutTemp = current.messages.where((m) {
          if (!m.id.startsWith('temp_')) return true;
          return !(m.senderId == msg.senderId && m.content == msg.content);
        }).toList();
        // Dedup: skip if a real message with the same id already exists
        if (withoutTemp.any((m) => m.id == msg.id)) return;
        final updated = [...withoutTemp, msg]
          ..sort((a, b) => a.sentAt.compareTo(b.sentAt));
        emit(MessageLoaded(messages: updated));
      }
    });
    _chat.connect(conversationId: conversationId);
  }

  void sendMessage({required String conversationId, required String content}) {
    // Optimistic update: show message immediately on sender's side
    if (currentUserId != null) {
      final current = state;
      if (current is MessageLoaded) {
        final tempMsg = Message(
          id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
          conversationId: conversationId,
          senderId: currentUserId!,
          senderUsername: '',
          senderDisplayName: '',
          content: content,
          type: 'TEXT',
          sentAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        emit(MessageLoaded(messages: [...current.messages, tempMsg]));
      }
    }
    _chat.sendMessage(conversationId: conversationId, content: content);
  }

  void sendTyping({required String conversationId, required bool typing}) {
    _chat.sendTyping(conversationId: conversationId, typing: typing);
  }

  void sendRead({
    required String conversationId,
    required String lastReadMessageId,
  }) {
    _chat.sendRead(
      conversationId: conversationId,
      lastReadMessageId: lastReadMessageId,
    );
  }

  @override
  Future<void> close() {
    _messageSub?.cancel();
    _chat.disconnect();
    return super.close();
  }

  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Kết nối quá thời gian, vui lòng thử lại';
      case DioExceptionType.connectionError:
        return 'Không thể kết nối đến máy chủ';
      case DioExceptionType.badResponse:
        final data = e.response?.data;
        if (data is Map && data['message'] != null) {
          return data['message'].toString();
        }
        return 'Lỗi máy chủ: ${e.response?.statusCode}';
      default:
        return 'Đã có lỗi xảy ra, vui lòng thử lại';
    }
  }
}
