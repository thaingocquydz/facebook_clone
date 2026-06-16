import 'package:dio/dio.dart';
import 'package:facebook_clone/features/messages/cubit/conversation_state.dart';
import 'package:facebook_clone/features/messages/repository/conversation_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConversationCubit extends Cubit<ConversationState> {
  final ConversationRepository _repository;

  ConversationCubit(this._repository) : super(ConversationInitial());

  Future<void> loadConversations() async {
    emit(ConversationLoading());
    try {
      final conversations = await _repository.getConversations();
      emit(ConversationLoaded(conversations: conversations));
    } on DioException catch (e) {
      emit(ConversationFailure(_handleDioError(e)));
    } catch (_) {
      emit(const ConversationFailure('Đã có lỗi xảy ra, vui lòng thử lại'));
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
