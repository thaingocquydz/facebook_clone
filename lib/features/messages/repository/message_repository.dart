import 'package:dio/dio.dart';
import 'package:facebook_clone/features/messages/models/message.dart';
import 'package:facebook_clone/services/dio_client.dart';

class MessageRepository {
  final Dio _dio = DioClient().dio;

  Future<List<Message>> getMessages(String conversationId) async {
    final response = await _dio.get(
      '/api/v1/conversations/$conversationId/messages',
    );
    final data = MessagesResponse.fromJson(
      response.data as Map<String, dynamic>,
    );
    return data.data;
  }
}
