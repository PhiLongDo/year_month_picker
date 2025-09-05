import 'package:flutter/material.dart';

class Dropdown<T> extends StatefulWidget {
  Dropdown({
    required this.items,
    required this.itemBuilder,
    required this.selectedItemBuilder,
    this.value,
    this.onChanged,
    this.menuMaxHeight,
    this.itemHeight = kMinInteractiveDimension,
    super.key,
  }) {
    assert(items.isNotEmpty, 'The items list must not be empty.');
    assert(
      value == null || items.contains(value!),
      'If provided, the value must be one of the items.',
    );
  }

  final T? value;
  final List<T> items;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final Widget Function(BuildContext) selectedItemBuilder;
  final ValueChanged<T?>? onChanged;
  final double? menuMaxHeight;
  final double itemHeight;

  @override
  State<Dropdown<T>> createState() => _DropdownState<T>();
}

class _DropdownState<T> extends State<Dropdown<T>> {
  OverlayEntry? overlayEntry;
  int? selectedIndex;
  GlobalKey globalKey = GlobalKey();

  @override
  void initState() {
    if (widget.value != null && widget.items.isNotEmpty) {
      selectedIndex = widget.items.indexOf(widget.value as T);
    }
    super.initState();
  }

  void createOverlay({
    required Offset position,
    required Size size,
  }) {
    // Remove the existing OverlayEntry.
    removeHighlightOverlay();

    assert(overlayEntry == null);

    final scrollController = ScrollController(
      initialScrollOffset: (selectedIndex ?? 0) * widget.itemHeight,
    );

    overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                // Remove the overlay when tapping outside.
                removeHighlightOverlay();
              },
              behavior: HitTestBehavior.translucent,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.transparent,
              ),
            ),
            Positioned(
              left: position.dx,
              top: position.dy,
              width: size.width,
              height: size.height *
                  (widget.items.length > 5 ? 5 : widget.items.length),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                controller: scrollController,
                itemBuilder: (BuildContext context, int index) {
                  return Material(
                    color: Colors.transparent,
                    child: Center(
                      child: InkWell(
                        onTap: () {
                          selectedIndex = index;
                          widget.onChanged?.call(widget.items[index]);
                          // Remove the overlay after selection.
                          removeHighlightOverlay();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                          ),
                          height: widget.itemHeight,
                          child: index == selectedIndex
                              ? widget.selectedItemBuilder(context)
                              : widget.itemBuilder(context, index),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: widget.items.length,
              ),
            ),
          ],
        );
      },
    );

    // Add the OverlayEntry to the Overlay.
    Overlay.of(context, debugRequiredFor: widget).insert(overlayEntry!);
  }

  // Remove the OverlayEntry.
  void removeHighlightOverlay() {
    overlayEntry?.remove();
    overlayEntry?.dispose();
    overlayEntry = null;
  }

  @override
  void dispose() {
    // Make sure to remove OverlayEntry when the widget is disposed.
    removeHighlightOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context).dropdownMenuTheme.textStyle;
    return InkWell(
      onTap: () {
        if (globalKey.currentContext != null) {
          final RenderBox renderBox =
              globalKey.currentContext!.findRenderObject() as RenderBox;
          final Size size = renderBox.size;
          final Offset offset = renderBox.localToGlobal(Offset.zero);
          createOverlay(position: offset, size: size);
        }
      },
      child: SizedBox(
        height: widget.itemHeight,
        child: Text(
          key: globalKey,
          widget.value == null ? '' : widget.value.toString(),
          style: Theme.of(context).dropdownMenuTheme.textStyle,
        ),
      ),
    );
  }
}
