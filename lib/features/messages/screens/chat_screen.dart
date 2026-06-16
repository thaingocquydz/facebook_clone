import 'package:facebook_clone/features/messages/cubit/message_cubit.dart';
import 'package:facebook_clone/features/messages/cubit/message_state.dart';
import 'package:facebook_clone/features/messages/models/conversation.dart';
import 'package:facebook_clone/features/messages/models/message.dart';
import 'package:facebook_clone/features/messages/repository/message_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

String _formatTime(DateTime dt) {
  final h = dt.hour.toString().padLeft(2, '0');
  final m = dt.minute.toString().padLeft(2, '0');
  return '$h:$m';
}

String _formatDateLabel(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final d = DateTime(date.year, date.month, date.day);
  final diff = today.difference(d).inDays;

  if (diff == 0) return 'Hôm nay';
  if (diff == 1) return 'Hôm qua';
  if (diff < 7) {
    const days = [
      'Thứ Hai',
      'Thứ Ba',
      'Thứ Tư',
      'Thứ Năm',
      'Thứ Sáu',
      'Thứ Bảy',
      'Chủ Nhật',
    ];
    return days[date.weekday - 1];
  }
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day/$month/${date.year}';
}

class ChatScreenArgs {
  final Conversation conversation;
  final String? currentUserId;

  const ChatScreenArgs({
    required this.conversation,
    this.currentUserId,
  });
}

class ChatScreen extends StatelessWidget {
  static const String routeName = '/chat';

  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as ChatScreenArgs;

    return BlocProvider(
      create: (_) => MessageCubit(MessageRepository())
        ..loadMessages(args.conversation.id),
      child: _ChatView(
        conversation: args.conversation,
        currentUserId: args.currentUserId,
      ),
    );
  }
}

class _ChatView extends StatefulWidget {
  final Conversation conversation;
  final String? currentUserId;

  const _ChatView({
    required this.conversation,
    required this.currentUserId,
  });

  @override
  State<_ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<_ChatView> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _inputController.addListener(() {
      final hasText = _inputController.text.trim().isNotEmpty;
      if (hasText != _hasText) setState(() => _hasText = hasText);
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(
          _scrollController.position.maxScrollExtent,
        );
      }
    });
  }

  bool _isOnline() =>
      widget.conversation.members.any((m) => m.online);

  bool _isMe(String senderId) => widget.currentUserId == senderId;

  @override
  Widget build(BuildContext context) {
    final conv = widget.conversation;
    final isGroup = conv.type == 'GROUP';

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
        title: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: const Color(0xFF0084FF),
                  child: isGroup
                      ? const Icon(Icons.group,
                          color: Colors.white, size: 18)
                      : Text(
                          conv.name.isNotEmpty
                              ? conv.name[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                ),
                if (_isOnline())
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 11,
                      height: 11,
                      decoration: BoxDecoration(
                        color: const Color(0xFF31A24C),
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  conv.name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _isOnline() ? 'Đang hoạt động' : 'Không hoạt động',
                  style: TextStyle(
                    fontSize: 12,
                    color: _isOnline()
                        ? const Color(0xFF31A24C)
                        : Colors.grey[500],
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          _AppBarIcon(
            icon: Icons.phone_outlined,
            onTap: () {},
          ),
          _AppBarIcon(
            icon: Icons.videocam_outlined,
            onTap: () {},
          ),
          _AppBarIcon(
            icon: Icons.info_outline,
            onTap: () {},
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<MessageCubit, MessageState>(
              listener: (context, state) {
                if (state is MessageLoaded) _scrollToBottom();
              },
              builder: (context, state) {
                if (state is MessageLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF0084FF),
                    ),
                  );
                }

                if (state is MessageFailure) {
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
                              .read<MessageCubit>()
                              .loadMessages(conv.id),
                          child: const Text('Thử lại'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is MessageLoaded) {
                  if (state.messages.isEmpty) {
                    return const Center(
                      child: Text(
                        'Hãy bắt đầu cuộc trò chuyện!',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final msg = state.messages[index];
                      final prevMsg = index > 0
                          ? state.messages[index - 1]
                          : null;
                      final nextMsg = index < state.messages.length - 1
                          ? state.messages[index + 1]
                          : null;

                      final showDateSep = prevMsg == null ||
                          !_isSameDay(prevMsg.sentAt, msg.sentAt);

                      final isMe = _isMe(msg.senderId);
                      // Show avatar if last in a group of same sender
                      final isLastInGroup = nextMsg == null ||
                          nextMsg.senderId != msg.senderId;
                      final isFirstInGroup = prevMsg == null ||
                          prevMsg.senderId != msg.senderId;

                      return Column(
                        children: [
                          if (showDateSep)
                            _DateSeparator(date: msg.sentAt),
                          _MessageBubble(
                            message: msg,
                            isMe: isMe,
                            isGroup: isGroup,
                            showAvatar: !isMe && isLastInGroup,
                            showSenderName:
                                !isMe && isGroup && isFirstInGroup,
                            isFirstInGroup: isFirstInGroup,
                            isLastInGroup: isLastInGroup,
                          ),
                        ],
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
          _BottomInputBar(
            controller: _inputController,
            hasText: _hasText,
            onSend: () {
              // TODO: hook up send message API
              _inputController.clear();
            },
          ),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

// ─────────────────────────────────────────────
// Date separator
// ─────────────────────────────────────────────
class _DateSeparator extends StatelessWidget {
  final DateTime date;

  const _DateSeparator({required this.date});

  String _label() => _formatDateLabel(date);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          const Expanded(child: Divider(color: Color(0xFFE0E0E0))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              _label(),
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ),
          const Expanded(child: Divider(color: Color(0xFFE0E0E0))),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Message bubble
// ─────────────────────────────────────────────
class _MessageBubble extends StatelessWidget {
  final Message message;
  final bool isMe;
  final bool isGroup;
  final bool showAvatar;
  final bool showSenderName;
  final bool isFirstInGroup;
  final bool isLastInGroup;

  const _MessageBubble({
    required this.message,
    required this.isMe,
    required this.isGroup,
    required this.showAvatar,
    required this.showSenderName,
    required this.isFirstInGroup,
    required this.isLastInGroup,
  });

  BorderRadius _bubbleRadius() {
    const r = Radius.circular(18);
    const rSmall = Radius.circular(4);
    if (isMe) {
      return BorderRadius.only(
        topLeft: r,
        bottomLeft: r,
        topRight: isFirstInGroup ? r : rSmall,
        bottomRight: isLastInGroup ? r : rSmall,
      );
    } else {
      return BorderRadius.only(
        topRight: r,
        bottomRight: r,
        topLeft: isFirstInGroup ? r : rSmall,
        bottomLeft: isLastInGroup ? r : rSmall,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const messengerBlue = Color(0xFF0084FF);
    final bubbleBg = isMe ? messengerBlue : const Color(0xFFF0F2F5);
    final textColor = isMe ? Colors.white : Colors.black87;
    final timeStr = _formatTime(message.sentAt);

    return Padding(
      padding: EdgeInsets.only(
        top: isFirstInGroup ? 6 : 1.5,
        bottom: isLastInGroup ? 2 : 1.5,
      ),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Avatar placeholder for non-me messages (keeps alignment)
          if (!isMe) ...[
            SizedBox(
              width: 32,
              child: showAvatar
                  ? CircleAvatar(
                      radius: 14,
                      backgroundColor: messengerBlue,
                      backgroundImage: message.senderAvatarUrl != null
                          ? NetworkImage(message.senderAvatarUrl!)
                          : null,
                      child: message.senderAvatarUrl == null
                          ? Text(
                              message.senderDisplayName.isNotEmpty
                                  ? message.senderDisplayName[0]
                                      .toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : null,
                    )
                  : null,
            ),
            const SizedBox(width: 6),
          ],

          // Bubble column
          Flexible(
            child: Column(
              crossAxisAlignment: isMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                if (showSenderName)
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 2),
                    child: Text(
                      message.senderDisplayName,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                Tooltip(
                  message: timeStr,
                  preferBelow: false,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth:
                          MediaQuery.of(context).size.width * 0.68,
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 9),
                    decoration: BoxDecoration(
                      color: bubbleBg,
                      borderRadius: _bubbleRadius(),
                    ),
                    child: Text(
                      message.content,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (isMe) const SizedBox(width: 4),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Bottom input bar
// ─────────────────────────────────────────────
class _BottomInputBar extends StatelessWidget {
  final TextEditingController controller;
  final bool hasText;
  final VoidCallback onSend;

  const _BottomInputBar({
    required this.controller,
    required this.hasText,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Left icons
            if (!hasText) ...[
              _InputIcon(icon: Icons.add_circle_outline, onTap: () {}),
              _InputIcon(icon: Icons.camera_alt_outlined, onTap: () {}),
              _InputIcon(icon: Icons.image_outlined, onTap: () {}),
              _InputIcon(icon: Icons.mic_none, onTap: () {}),
            ] else ...[
              _InputIcon(icon: Icons.add_circle_outline, onTap: () {}),
            ],

            const SizedBox(width: 4),

            // Text field
            Expanded(
              child: Container(
                constraints: const BoxConstraints(maxHeight: 120),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F2F5),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        maxLines: null,
                        textCapitalization:
                            TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          hintText: 'Aa',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 14, vertical: 9),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4, right: 4),
                      child: GestureDetector(
                        onTap: () {},
                        child: const Icon(
                          Icons.emoji_emotions_outlined,
                          color: Color(0xFF0084FF),
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 6),

            // Send / thumbs up
            GestureDetector(
              onTap: hasText ? onSend : () {},
              child: Icon(
                hasText ? Icons.send_rounded : Icons.thumb_up_outlined,
                color: const Color(0xFF0084FF),
                size: 26,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InputIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _InputIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 4),
        child: Icon(icon, color: const Color(0xFF0084FF), size: 26),
      ),
    );
  }
}

class _AppBarIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _AppBarIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin:
            const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
        width: 34,
        height: 34,
        decoration: const BoxDecoration(
          color: Color(0xFFF0F2F5),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: Colors.black),
      ),
    );
  }
}
