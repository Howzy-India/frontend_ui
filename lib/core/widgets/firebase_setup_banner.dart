import 'package:flutter/material.dart';

class FirebaseSetupBanner extends StatefulWidget {
  const FirebaseSetupBanner({super.key});

  @override
  State<FirebaseSetupBanner> createState() => _FirebaseSetupBannerState();
}

class _FirebaseSetupBannerState extends State<FirebaseSetupBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _heightFactor;
  bool _dismissed = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
      value: 1.0,
    );
    _heightFactor = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);

    // Auto-dismiss after 6 seconds
    Future.delayed(const Duration(seconds: 6), _dismiss);
  }

  void _dismiss() {
    if (!mounted || _dismissed) return;
    _dismissed = true;
    _ctrl.reverse();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: _heightFactor,
      axisAlignment: -1,
      child: Container(
        color: const Color(0xFFFEF3C7),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              size: 15,
              color: Color(0xFFD97706),
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Firebase not configured — run `flutterfire configure` to enable auth & storage.',
                style: TextStyle(fontSize: 12, color: Color(0xFF92400E)),
              ),
            ),
            GestureDetector(
              onTap: _dismiss,
              child: const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Icon(Icons.close, size: 15, color: Color(0xFF92400E)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
