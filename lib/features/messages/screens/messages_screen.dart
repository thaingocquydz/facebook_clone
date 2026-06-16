import 'package:facebook_clone/features/auth/cubit/auth_cubit.dart';
import 'package:facebook_clone/features/auth/cubit/auth_state.dart';
import 'package:facebook_clone/features/messages/cubit/conversation_cubit.dart';
import 'package:facebook_clone/features/messages/cubit/conversation_state.dart';
import 'package:facebook_clone/features/messages/models/conversation.dart';
import 'package:facebook_clone/features/messages/repository/conversation_repository.dart';
import 'package:facebook_clone/features/messages/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessagesScreen extends StatelessWidget {
  static const String routeName = '/messages';

  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ConversationCubit(ConversationRepository())..loadConversations(),
      child: const _MessagesView(),
    );
  }
}

class _MessagesView extends StatefulWidget {
  const _MessagesView();

  @override
  State<_MessagesView> createState() => _MessagesViewState();
}

class _MessagesViewState extends State<_MessagesView> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leadingWidth: 40,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 22),
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Đoạn chat',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          _AppBarCircleButton(
            icon: Icons.videocam_outlined,
            onTap: () {},
          ),
          _AppBarCircleButton(
            icon: Icons.edit_outlined,
            onTap: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF0F2F5),
                borderRadius: BorderRadius.circular(22),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _query = value),
                decoration: const InputDecoration(
                  hintText: 'Tìm kiếm',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                  prefixIcon: Icon(Icons.search, color: Colors.grey, size: 22),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 11),
                ),
              ),
            ),
          ),
          // Conversation list
          Expanded(
            child: BlocBuilder<ConversationCubit, ConversationState>(
              builder: (context, state) {
                if (state is ConversationLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF0084FF),
                    ),
                  );
                }

                if (state is ConversationFailure) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            color: Colors.grey, size: 48),
                        const SizedBox(height: 12),
                        Text(
                          state.error,
                          style: const TextStyle(color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0084FF),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () => context
                              .read<ConversationCubit>()
                              .loadConversations(),
                          child: const Text('Thử lại'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is ConversationLoaded) {
                  final filtered = _query.isEmpty
                      ? state.conversations
                      : state.conversations
                          .where((c) => c.name
                              .toLowerCase()
                              .contains(_query.toLowerCase()))
                          .toList();

                  if (filtered.isEmpty) {
                    return const Center(
                      child: Text(
                        'Không tìm thấy cuộc hội thoại nào',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) =>
                        _ConversationTile(conversation: filtered[index]),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AppBarCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _AppBarCircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        width: 36,
        height: 36,
        decoration: const BoxDecoration(
          color: Color(0xFFF0F2F5),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20, color: Colors.black),
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  final Conversation conversation;

  const _ConversationTile({required this.conversation});

  bool get _hasOnlineMember =>
      conversation.members.any((m) => m.online);

  String get _avatarLetter {
    final name = conversation.name.trim();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  Color _avatarColor(String id) {
    const colors = [
      Color(0xFF0084FF),
      Color(0xFF44BEC7),
      Color(0xFFFFC300),
      Color(0xFFFA3C4C),
      Color(0xFFD696BB),
      Color(0xFF6699CC),
    ];
    final index = id.isNotEmpty ? id.codeUnitAt(0) % colors.length : 0;
    return colors[index];
  }

  @override
  Widget build(BuildContext context) {
    final isGroup = conversation.type == 'GROUP';
    final hasUnread = conversation.unreadCount > 0;
    final String subtitle = isGroup
        ? '${conversation.members.length} thành viên'
        : (conversation.description ?? '');

    return InkWell(
      onTap: () {
        final authState = context.read<AuthCubit>().state;
        final currentUserId =
            authState is LoginSuccess ? authState.user?.id : null;
        Navigator.pushNamed(
          context,
          ChatScreen.routeName,
          arguments: ChatScreenArgs(
            conversation: conversation,
            currentUserId: currentUserId,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            // Avatar
            Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: _avatarColor(conversation.id),
                  child: isGroup
                      ? const Icon(Icons.group, color: Colors.white, size: 26)
                      : Text(
                          _avatarLetter,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                if (_hasOnlineMember)
                  Positioned(
                    bottom: 1,
                    right: 1,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: const Color(0xFF31A24C),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            // Name + subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    conversation.name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight:
                          hasUnread ? FontWeight.bold : FontWeight.w500,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color:
                            hasUnread ? Colors.black87 : Colors.grey[600],
                        fontWeight: hasUnread
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            // Unread badge
            if (hasUnread) ...[
              const SizedBox(width: 8),
              Container(
                constraints: const BoxConstraints(minWidth: 22),
                padding: const EdgeInsets.symmetric(
                    horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF0084FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${conversation.unreadCount}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
