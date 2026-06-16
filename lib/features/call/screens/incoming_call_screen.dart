import 'package:facebook_clone/features/call/cubit/call_cubit.dart';
import 'package:facebook_clone/features/call/cubit/call_state.dart';
import 'package:facebook_clone/features/call/models/call_models.dart';
import 'package:facebook_clone/features/call/screens/call_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IncomingCallScreen extends StatelessWidget {
  const IncomingCallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CallCubit, CallState>(
      listener: (context, state) {
        if (state is CallConnecting || state is CallActive) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<CallCubit>(),
                child: const CallScreen(),
              ),
            ),
          );
        } else if (state is CallIdle || state is CallEnded) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        if (state is! CallIncoming) return const SizedBox.shrink();
        final isVideo = state.callType == CallType.video;

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF1C1C2E), Color(0xFF2D2D44)],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  Text(
                    isVideo ? 'Cuộc gọi video' : 'Cuộc gọi thoại',
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 32),
                  _Avatar(
                    avatarUrl: state.callerAvatar,
                    name: state.callerName,
                    radius: 56,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    state.callerName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Đang gọi...',
                    style: TextStyle(color: Colors.white54, fontSize: 15),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 48),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _CallButton(
                          icon: Icons.call_end,
                          color: Colors.red,
                          label: 'Từ chối',
                          onTap: () => context
                              .read<CallCubit>()
                              .rejectCall(callLogId: state.callLogId),
                        ),
                        _CallButton(
                          icon: isVideo ? Icons.videocam : Icons.call,
                          color: const Color(0xFF31A24C),
                          label: 'Chấp nhận',
                          onTap: () => context.read<CallCubit>().acceptCall(
                                callLogId: state.callLogId,
                                remoteUserId: state.remoteUserId,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Avatar extends StatelessWidget {
  final String? avatarUrl;
  final String name;
  final double radius;

  const _Avatar({required this.avatarUrl, required this.name, required this.radius});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: const Color(0xFF0084FF),
      backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
      child: avatarUrl == null
          ? Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: TextStyle(
                color: Colors.white,
                fontSize: radius * 0.7,
                fontWeight: FontWeight.bold,
              ),
            )
          : null,
    );
  }
}

class _CallButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  const _CallButton({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(icon, color: Colors.white, size: 30),
          ),
        ),
        const SizedBox(height: 10),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)),
      ],
    );
  }
}
