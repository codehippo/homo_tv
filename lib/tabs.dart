import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum TabNavigationDirection {
  previous,
  following,
}

const double _tabHeight = 32.0;

class KeyboardNavigableTab extends StatefulWidget {
  final List<({IconData? icon, String text})> tabLabels;
  final Function(int) onTabChanged;

  const KeyboardNavigableTab({
    super.key,
    required this.tabLabels,
    required this.onTabChanged,
  });

  @override
  State<KeyboardNavigableTab> createState() => _KeyboardNavigableTabState();
}

class _KeyboardNavigableTabState extends State<KeyboardNavigableTab> {
  int _currentIndex = 0;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.arrowLeft:
          _changeTab(TabNavigationDirection.previous);
          break;
        case LogicalKeyboardKey.arrowRight:
          _changeTab(TabNavigationDirection.following);
          break;
        case LogicalKeyboardKey.keyH:
          _goToHomeTab();
          break;
        default:
        // Do nothing for other keys
      }
    }
  }

  void _changeTab(TabNavigationDirection direction) {
    setState(() {
      switch (direction) {
        case TabNavigationDirection.previous:
          _currentIndex = (_currentIndex - 1) % widget.tabLabels.length;
          if (_currentIndex < 0) _currentIndex = widget.tabLabels.length - 1;
          break;
        case TabNavigationDirection.following:
          _currentIndex = (_currentIndex + 1) % widget.tabLabels.length;
          break;
      }
    });
    widget.onTabChanged(_currentIndex);
  }

  void _goToHomeTab() {
    setState(() => _currentIndex = 0);
    widget.onTabChanged(0);
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: _handleKeyEvent,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Wrap(
            spacing: 6.0,
            runAlignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: List.generate(
              widget.tabLabels.length,
                  (index) => _buildTab(index),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTab(int index) {
    final isSelected = index == _currentIndex;
    return GestureDetector(
      onTap: () {
        setState(() => _currentIndex = index);
        widget.onTabChanged(index);
      },
      child: AnimatedScale(
        scale: isSelected ? 1.125 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOutBack,
        child: SizedBox(
          height: _tabHeight,
          child: Material(
            elevation: isSelected ? 4 : 0,
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(_tabHeight * 0.5),
            child: Padding(
              padding: widget.tabLabels[index].icon != null ? EdgeInsets.fromLTRB(12.0, 6.0, 16.0, 6.0) : EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 6.0,
                children: [
                  Icon(
                    widget.tabLabels[index].icon,
                    color: isSelected? Colors.black87 : Colors.grey,
                    size: 18.0
                  ),
                  Text(
                    widget.tabLabels[index].text,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: isSelected ? Colors.black87 : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}