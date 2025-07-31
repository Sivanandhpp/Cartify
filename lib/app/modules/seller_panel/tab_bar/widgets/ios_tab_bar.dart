import 'dart:ui';
import 'package:flutter/material.dart';

class TabBarItem {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isSelected;

  TabBarItem({
    required this.icon,
    required this.label,
    this.onTap,
    this.isSelected = false,
  });
}

class EventData {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  EventData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}

class IOSTabBar extends StatefulWidget {
  final List<TabBarItem> items;
  final EventData? currentEvent;
  final ScrollController? scrollController;
  final double bottomPadding;
  final Color backgroundColor;
  final Color selectedColor;
  final Color unselectedColor;
  final bool separateLastItem; // New property to separate last item

  const IOSTabBar({
    super.key,
    required this.items,
    this.currentEvent,
    this.scrollController,
    this.bottomPadding = 0,
    this.backgroundColor = Colors.black,
    this.selectedColor = Colors.blue,
    this.unselectedColor = Colors.grey,
    this.separateLastItem = true, // Default to true for iOS 26 style
  });

  @override
  State<IOSTabBar> createState() => _IOSTabBarState();
}

class _IOSTabBarState extends State<IOSTabBar> with TickerProviderStateMixin {
  late AnimationController _eventAnimationController;
  late AnimationController _scrollAnimationController;
  late Animation<double> _eventAnimation;
  late Animation<double> _scrollAnimation;

  bool _isScrolledDown = false;

  @override
  void initState() {
    super.initState();

    _eventAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scrollAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _eventAnimation = CurvedAnimation(
      parent: _eventAnimationController,
      curve: Curves.easeInOut,
    );

    _scrollAnimation = CurvedAnimation(
      parent: _scrollAnimationController,
      curve: Curves.easeInOut,
    );

    if (widget.currentEvent != null) {
      _eventAnimationController.forward();
    }

    widget.scrollController?.addListener(_handleScroll);
  }

  void _handleScroll() {
    if (widget.scrollController == null) return;

    final scrollOffset = widget.scrollController!.offset;

    if (scrollOffset > 50 && !_isScrolledDown) {
      setState(() => _isScrolledDown = true);
      _scrollAnimationController.forward();
    } else if (scrollOffset <= 50 && _isScrolledDown) {
      setState(() => _isScrolledDown = false);
      _scrollAnimationController.reverse();
    }
  }

  @override
  void didUpdateWidget(IOSTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.currentEvent != null && oldWidget.currentEvent == null) {
      _eventAnimationController.forward();
    } else if (widget.currentEvent == null && oldWidget.currentEvent != null) {
      _eventAnimationController.reverse();
    }
  }

  @override
  void dispose() {
    _eventAnimationController.dispose();
    _scrollAnimationController.dispose();
    widget.scrollController?.removeListener(_handleScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_eventAnimation, _scrollAnimation]),
      builder: (context, child) {
        final eventHeight = widget.currentEvent != null ? 60.0 : 0.0;
        final animatedEventHeight = eventHeight * _eventAnimation.value;
        final minimizedEventHeight = _isScrolledDown
            ? 30.0
            : animatedEventHeight;

        return Positioned(
          left: 20,
          right: 20,
          bottom: widget.bottomPadding + 10,

          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Event Banner
                if (widget.currentEvent != null)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: minimizedEventHeight,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: widget.currentEvent!.color.withValues(
                              alpha: 0.2,
                            ),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2),
                              width: 0.8,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: _buildEventContent(
                            minimizedEventHeight,
                            animatedEventHeight,
                          ),
                        ),
                      ),
                    ),
                  ),

                if (widget.currentEvent != null) const SizedBox(height: 8),

                // Tab Bar
                Row(
                  children: [
                    // Main tab bar with first n-1 items
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          30,
                        ), // iOS 26 corner radius
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            height:
                                60, // Adjusted height for iOS 26 proportions
                            decoration: BoxDecoration(
                              color: widget.backgroundColor.withValues(
                                alpha: 0.15,
                              ),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.2),
                                width: 0.8,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Row(
                              children:
                                  widget.separateLastItem &&
                                      widget.items.isNotEmpty
                                  ? widget.items
                                        .take(widget.items.length - 1)
                                        .map((item) => _buildMainTabItem(item))
                                        .toList()
                                  : widget.items
                                        .map((item) => _buildMainTabItem(item))
                                        .toList(),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Separator space
                    if (widget.separateLastItem && widget.items.isNotEmpty)
                      const SizedBox(width: 12),

                    // Separated last item (circular button)
                    if (widget.separateLastItem && widget.items.isNotEmpty)
                      _buildSeparatedItem(widget.items.last),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEventContent(double currentHeight, double fullHeight) {
    final isMinimized = currentHeight < fullHeight * 0.7;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(
            widget.currentEvent!.icon,
            color: widget.currentEvent!.color,
            size: isMinimized ? 16 : 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.currentEvent!.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isMinimized ? 12 : 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (!isMinimized && widget.currentEvent!.subtitle.isNotEmpty)
                  Text(
                    widget.currentEvent!.subtitle,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          if (!isMinimized)
            Icon(
              Icons.chevron_right,
              color: Colors.white.withValues(alpha: 0.5),
              size: 20,
            ),
        ],
      ),
    );
  }

  Widget _buildMainTabItem(TabBarItem item) {
    return Expanded(
      child: GestureDetector(
        onTap: item.onTap,
        child: Container(
          height: 50, // iOS 26 item height
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          decoration: BoxDecoration(
            color: item.isSelected
                ? Colors.white.withValues(
                    alpha: 0.15,
                  ) // iOS 26 selected background
                : Colors.transparent,
            borderRadius: BorderRadius.circular(25), // iOS 26 inner radius
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                item.icon,
                color: item.isSelected
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.6),
                size: 20, // iOS 26 icon size
              ),
              const SizedBox(height: 4),
              Text(
                item.label,
                style: TextStyle(
                  color: item.isSelected
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.6),
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeparatedItem(TabBarItem item) {
    return GestureDetector(
      onTap: item.onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30), // Perfect circle
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 60, // Perfect circle dimensions
            height: 60,
            decoration: BoxDecoration(
              color: item.isSelected
                  ? widget.selectedColor.withValues(alpha: 0.25)
                  : widget.backgroundColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 0.8,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  color: item.isSelected
                      ? widget.selectedColor
                      : Colors.white.withValues(alpha: 0.8),
                  size: 22, // Slightly larger for the separated button
                ),
                if (item.label.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    item.label,
                    style: TextStyle(
                      color: item.isSelected
                          ? widget.selectedColor
                          : Colors.white.withValues(alpha: 0.8),
                      fontSize: 8,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
