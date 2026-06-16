import 'package:facebook_clone/features/call/cubit/call_cubit.dart';
import 'package:facebook_clone/features/call/cubit/call_state.dart';
import 'package:facebook_clone/features/call/models/call_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class CallScreen extends StatelessWidget {
  const CallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CallCubit, CallState>(
      listener: (context, state) {
        if (state is CallEnded || state is CallIdle) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        final cubit = context.read<CallCubit>();
        final isVideo = _isVideoCall(state);

        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            fit: StackFit.expand,
            children: [
              // ── Remote video (background) ──────────────────────────────────
              if (isVideo && state is CallActive)
                RTCVideoView(
                  cubit.remoteRenderer,
                  objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                )
              else
                _AudioBackground(state: state),

              // ── Local video (picture-in-picture) ───────────────────────────
              if (isVideo)
                Positioned(
                  top: 56,
                  right: 12,
                  width: 104,
                  height: 156,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: RTCVideoView(
                      cubit.localRenderer,
                      mirror: true,
                      objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                    ),
                  ),
                ),

              // ── Controls ──────────────────────────────────────────────────
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _Controls(state: state, cubit: cubit, isVideo: isVideo),
              ),
            ],
          ),
        );
      },
    );
  }

  bool _isVideoCall(CallState state) {
    if (state is CallOutgoing) return state.callType == CallType.video;
    if (state is CallConnecting) return state.callType == CallType.video;
    if (state is CallActive) return state.callType == CallType.video;
    return false;
  }
}

// ── Audio / waiting background ────────────────────────────────────────────────
class _AudioBackground extends StatelessWidget {
  final CallState state;

  const _AudioBackground({required this.state});

  @override
  Widget build(BuildContext context) {
    String statusText = '';
    String? calleeName;

    if (state is CallOutgoing) {
      calleeName = (state as CallOutgoing).calleeName;
      statusText = 'Đang gọi...';
    } else if (state is CallConnecting) {
      statusText = 'Đang kết nối...';
    } else if (state is CallActive) {
      statusText = 'Đang trong cuộc gọi';
    }

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1C1C2E), Color(0xFF2D2D44)],
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (calleeName != null) ...[
              CircleAvatar(
                radius: 52,
                backgroundColor: const Color(0xFF0084FF),
                child: Text(
                  calleeName.isNotEmpty ? calleeName[0].toUpperCase() : '?',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                calleeName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
            ],
            Text(
              statusText,
              style: const TextStyle(color: Colors.white54, fontSize: 15),
            ),
            if (state is CallOutgoing || state is CallConnecting) ...[
              const SizedBox(height: 24),
              const SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  color: Colors.white54,
                  strokeWidth: 2,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Call controls bar ─────────────────────────────────────────────────────────
class _Controls extends StatelessWidget {
  final CallState state;
  final CallCubit cubit;
  final bool isVideo;

  const _Controls({
    required this.state,
    required this.cubit,
    required this.isVideo,
  });

  @override
  Widget build(BuildContext context) {
    final active = state is CallActive ? state as CallActive : null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Mute toggle
            _ControlBtn(
              icon: (active?.isMuted ?? false) ? Icons.mic_off : Icons.mic,
              label: (active?.isMuted ?? false) ? 'Bật mic' : 'Tắt mic',
              active: active?.isMuted ?? false,
              onTap: active != null ? cubit.toggleMute : null,
            ),

            // Camera toggle (video only)
            if (isVideo) ...[
              _ControlBtn(
                icon: (active?.isCameraOff ?? false)
                    ? Icons.videocam_off
                    : Icons.videocam,
                label: (active?.isCameraOff ?? false) ? 'Bật camera' : 'Tắt camera',
                active: active?.isCameraOff ?? false,
                onTap: active != null ? cubit.toggleCamera : null,
              ),
              _ControlBtn(
                icon: Icons.flip_camera_ios,
                label: 'Đảo camera',
                onTap: active != null ? cubit.switchCamera : null,
              ),
            ],

            // End call
            _ControlBtn(
              icon: Icons.call_end,
              label: 'Kết thúc',
              color: Colors.red,
              onTap: cubit.endCall,
            ),
          ],
        ),
      ),
    );
  }
}

class _ControlBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final bool active;
  final VoidCallback? onTap;

  const _ControlBtn({
    required this.icon,
    required this.label,
    this.color,
    this.active = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = color ?? (active ? Colors.white24 : Colors.white12);
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: onTap != null ? 1.0 : 0.4,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
              child: Icon(icon, color: Colors.white, size: 26),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 11),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
