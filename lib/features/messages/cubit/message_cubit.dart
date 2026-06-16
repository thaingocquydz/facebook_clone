import 'package:dio/dio.dart';
import 'package:facebook_clone/features/messages/cubit/message_state.dart';
import 'package:facebook_clone/features/messages/repository/message_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageCubit extends Cubit<MessageState> {
  final MessageRepository _repository;

  MessageCubit(this._repository) : super(MessageInitial());

  Future<void> loadMessages(String conversationId) async {
    emit(MessageLoading());
    try {
      final messages = await _repository.getMessages(conversationId);
      // Sort oldest first so newest appears at the bottom
      final sorted = [...messages]
        ..sort((a, b) => a.sentAt.compareTo(b.sentAt));
      emit(MessageLoaded(messages: sorted));
    } on DioException catch (e) {
      emit(MessageFailure(_handleDioError(e)));
    } catch (_) {
      emit(const MessageFailure('Đã có lỗi xảy ra, vui lòng thử lại'));
    }
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
