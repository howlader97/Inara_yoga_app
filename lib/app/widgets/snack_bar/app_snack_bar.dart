import 'package:flutter/material.dart';
import '../../data/app_colors.dart';
import 'package:get/get.dart';

class AppSnackBar {
  // Keep messengerKey to avoid breaking any structural configuration references,
  // but we do not use it for showing top notifications.
  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static OverlayEntry? _currentOverlay;

  static void _showOverlay({
    required Widget child,
    required Duration duration,
  }) {
    final context = Get.overlayContext ?? Get.context;
    if (context == null) return;

    final overlayState = Navigator.of(context).overlay;
    if (overlayState == null) return;

    // Dismiss current overlay if any
    _currentOverlay?.remove();
    _currentOverlay = null;

    final entry = OverlayEntry(
      builder: (context) => _TopSnackBarWidget(
        duration: duration,
        onDismiss: () {
          _currentOverlay?.remove();
          _currentOverlay = null;
        },
        child: child,
      ),
    );

    _currentOverlay = entry;
    overlayState.insert(entry);
  }

  static void error(
    String parameterValue, {
    SnackPosition? snackPosition,
    SnackBarAction? action,
  }) {
    _showOverlay(
      duration: const Duration(seconds: 4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.errorColor.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                "Error: $parameterValue",
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (action != null) ...[
              const SizedBox(width: 8),
              TextButton(
                onPressed: () {
                  _currentOverlay?.remove();
                  _currentOverlay = null;
                  action.onPressed();
                },
                child: Text(
                  action.label,
                  style: TextStyle(
                    color: action.textColor ?? Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  static void success(
    String parameterValue, {
    SnackPosition? snackPosition,
    Duration? duration,
    SnackBarAction? action,
  }) {
    _showOverlay(
      duration: duration ?? const Duration(seconds: 3),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.success,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                "Success: $parameterValue",
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (action != null) ...[
              const SizedBox(width: 8),
              TextButton(
                onPressed: () {
                  _currentOverlay?.remove();
                  _currentOverlay = null;
                  action.onPressed();
                },
                child: Text(
                  action.label,
                  style: TextStyle(
                    color: action.textColor ?? Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  static void message(
    String parameterValue, {
    Color? backgroundColor,
    Color? color,
    SnackPosition? snackPosition,
    SnackBarAction? action,
  }) {
    _showOverlay(
      duration: const Duration(seconds: 3),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.dark300,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              Icons.notifications_none,
              color: color ?? Colors.white,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                "Notification: $parameterValue",
                style: TextStyle(
                  fontSize: 15,
                  color: color ?? Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (action != null) ...[
              const SizedBox(width: 8),
              TextButton(
                onPressed: () {
                  _currentOverlay?.remove();
                  _currentOverlay = null;
                  action.onPressed();
                },
                child: Text(
                  action.label,
                  style: TextStyle(
                    color: action.textColor ?? Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TopSnackBarWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final VoidCallback onDismiss;

  const _TopSnackBarWidget({
    required this.child,
    required this.duration,
    required this.onDismiss,
  });

  @override
  State<_TopSnackBarWidget> createState() => _TopSnackBarWidgetState();
}

class _TopSnackBarWidgetState extends State<_TopSnackBarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _fadeAnimation;
  bool _dismissing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();

    // Auto dismiss after duration
    Future.delayed(widget.duration, () {
      if (mounted && !_dismissing) {
        _dismiss();
      }
    });
  }

  void _dismiss() {
    if (_dismissing) return;
    setState(() {
      _dismissing = true;
    });
    _controller.reverse().then((_) {
      widget.onDismiss();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;

    return Positioned(
      top: topPadding + 12,
      left: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: SlideTransition(
          position: _offsetAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.primaryDelta! < -5) {
                  _dismiss();
                }
              },
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
