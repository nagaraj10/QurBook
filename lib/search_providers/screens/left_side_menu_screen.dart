import 'package:flutter/material.dart';

class LeftSideMenuWidget extends StatefulWidget {
  final List<String> menuItems;
  final Function(int, String selectedMenu) selectedOptionChanged;
  final int selectedIndex;
  // final String selectedMenu;

  const LeftSideMenuWidget({
    required this.menuItems,
    // required this.selectedMenu,
    required this.selectedOptionChanged,
    this.selectedIndex = 0,
    Key? key,
  }) : super(key: key);

  @override
  State<LeftSideMenuWidget> createState() => _LeftSideMenuWidgetState();
}

class _LeftSideMenuWidgetState extends State<LeftSideMenuWidget> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.only(top: 16),
        width: MediaQuery.of(context).size.width / 2.5,
        decoration: const BoxDecoration(
          color: Color.fromRGBO(241, 235, 250, 1),
        ),
        child: ListView(
          physics: const ScrollPhysics(),
          children: List.generate(
            widget.menuItems.length,
            (index) => GestureDetector(
              onTap: () {
                if (selectedIndex != index) {
                  widget.selectedOptionChanged(index, widget.menuItems[index]);
                  setState(() {
                    selectedIndex = index;
                  });
                }
              },
              child: Container(
                alignment: Alignment.centerLeft,
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                  color: selectedIndex == index ? Colors.white : Colors.transparent,
                ),
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 5,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    widget.menuItems[index],
                    style: index == selectedIndex
                        ? const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          )
                        : const TextStyle(
                            fontSize: 13,
                          ),
                    semanticsLabel: widget.menuItems[index],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
