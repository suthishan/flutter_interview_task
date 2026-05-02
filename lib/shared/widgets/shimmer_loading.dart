import 'package:flutter/material.dart';

/// A reusable shimmer animation wrapper for skeleton loading screens.
///
/// Wraps any widget and paints a left-to-right highlight sweep over it.
/// Every visible pixel in [child] gets the shimmer — so all placeholder
/// children must use a solid background color (see [ShimmerBox]).

class Shimmer extends StatefulWidget {
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration period;

  const Shimmer({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.period = const Duration(milliseconds: 1400),
  });

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.period)
      ..repeat();
    _animation = Tween<double>(begin: -1.5, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final base = widget.baseColor ??
        (isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE0E0E0));
    final highlight = widget.highlightColor ??
        (isDark ? const Color(0xFF3D3D3D) : const Color(0xFFF8F8F8));

    return AnimatedBuilder(
      animation: _animation,
      child: widget.child,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) => LinearGradient(
            begin: Alignment(_animation.value - 1, 0),
            end: Alignment(_animation.value + 1, 0),
            colors: [base, highlight, base],
            stops: const [0.0, 0.5, 1.0],
          ).createShader(bounds),
          child: child,
        );
      },
    );
  }
}

class ShimmerBox extends StatelessWidget {
  final double height;
  final double? width;
  final double borderRadius;

  const ShimmerBox({
    super.key,
    required this.height,
    this.width,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Must be a solid, non-transparent color for ShaderMask to work.
    final fill =
    isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE0E0E0);

    return Container(
      height: height,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

class ShimmerCircle extends StatelessWidget {
  final double size;

  const ShimmerCircle({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return ShimmerBox(
      height: size,
      width: size,
      borderRadius: size / 2,
    );
  }
}

class ShimmerVisitCard extends StatelessWidget {
  const ShimmerVisitCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg =
    isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final barColor =
    isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE0E0E0);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? const Color(0xFF2C2C2C)
              : const Color(0xFFEEEEEE),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left accent bar
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: barColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
            ),

            // Card content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row 1: title + status chip
                    Row(
                      children: [
                        const Expanded(
                          child: ShimmerBox(height: 13, borderRadius: 6),
                        ),
                        const SizedBox(width: 10),
                        ShimmerBox(
                            height: 22, width: 70, borderRadius: 20),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Row 2: route
                    const ShimmerBox(
                        height: 10, width: 130, borderRadius: 5),

                    const SizedBox(height: 6),

                    // Row 3: time + segment badge
                    Row(
                      children: [
                        const ShimmerBox(
                            height: 10, width: 70, borderRadius: 5),
                        const Spacer(),
                        ShimmerBox(
                            height: 20, width: 60, borderRadius: 20),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Trailing chevron placeholder
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Center(
                child: ShimmerCircle(size: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShimmerVisitList extends StatelessWidget {
  final int count;

  const ShimmerVisitList({super.key, this.count = 6});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.only(top: 10, bottom: 20),
        itemCount: count,
        itemBuilder: (_, _) => const ShimmerVisitCard(),
      ),
    );
  }
}