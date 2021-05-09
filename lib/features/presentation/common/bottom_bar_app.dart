import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BottomBarAppItem {
  const BottomBarAppItem({
    required this.icon,
  });

  final String icon;
}

class BottomBarApp extends StatefulWidget {
  BottomBarApp({
    required this.items,
    this.height = 60.0,
    this.iconSize = 24.0,
    required this.backgroundColor,
    required this.color,
    required this.selectedColor,
    required this.notchedShape,
    required this.onTabSelected,
    this.selectedIndex = 0,
  });
  final List<BottomBarAppItem> items;
  final double height;
  final double iconSize;
  final Color backgroundColor;
  final Color color;
  final Color selectedColor;
  final NotchedShape notchedShape;
  final ValueChanged<int> onTabSelected;
  final int selectedIndex;

  @override
  State<StatefulWidget> createState() => BottomBarAppState();
}

class BottomBarAppState extends State<BottomBarApp> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(24),
        topLeft: Radius.circular(24),
      ),
      child: BottomAppBar(
        elevation: 5,
        shape: widget.notchedShape,
        notchMargin: 10.0,
        color: widget.backgroundColor,
        child: Container(
          height: 65.0,
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(widget.items.length, (int index) {
              return TabItemBottomBar(
                item: widget.items[index],
                index: index,
                color: widget.selectedIndex == index
                    ? widget.selectedColor
                    : widget.color,
                onPressed: (int index) => widget.onTabSelected(index),
                height: widget.height,
              );
            }),
          ),
        ),
      ),
    );
  }
}

class TabItemBottomBar extends StatelessWidget {
  const TabItemBottomBar({
    Key? key,
    required this.item,
    required this.index,
    required this.onPressed,
    required this.color,
    required this.height,
  }) : super(key: key);

  final BottomBarAppItem item;
  final int index;
  final ValueChanged<int> onPressed;
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: height,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () => onPressed(index),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(item.icon,
                    height: 25, fit: BoxFit.cover, color: color),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
