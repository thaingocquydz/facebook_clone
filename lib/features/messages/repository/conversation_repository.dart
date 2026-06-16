import 'package:dio/dio.dart';
import 'package:facebook_clone/features/messages/models/conversation.dart';
import 'package:facebook_clone/services/dio_client.dart';

class ConversationRepository {
  final Dio _dio = DioClient().dio;

  Future<List<Conversation>> getConversations() async {
    final response = await _dio.get('/api/v1/conversations');
    final data = ConversationsResponse.fromJson(
      response.data as Map<String, dynamic>,
    );
    return data.data;
  }
}
