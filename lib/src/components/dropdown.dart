import 'package:flutter/material.dart';

/// A customizable dropdown widget.
///
/// Displays a list of items and allows the user to select one.
class Dropdown<T> extends StatefulWidget {
  /// Creates a dropdown widget.
  ///
  /// The [items] list must not be empty.
  /// If [value] is provided, it must be one of the [items].
  Dropdown({
    required this.items,
    this.itemBuilder,
    this.selectedItemBuilder,
    this.value,
    this.onChanged,
    double? menuMaxHeight,
    this.itemHeight = kMinInteractiveDimension,
    super.key,
  }) {
    assert(items.isNotEmpty, 'The items list must not be empty.');
    assert(
      value == null || items.contains(value!),
      'If provided, the value must be one of the items.',
    );

    this.menuMaxHeight =
        menuMaxHeight ?? itemHeight * (items.length > 5 ? 5 : items.length);
  }

  /// The currently selected value.
  ///
  /// If null, no item is initially selected.
  final T? value;

  /// The list of items to display in the dropdown.
  final List<T> items;

  /// A builder function for the items in the dropdown list.
  ///
  /// If null, a default item builder is used which displays the string
  /// representation of each item.
  final Widget Function(BuildContext context, int index)? itemBuilder;

  /// A builder function for the selected item displayed in the dropdown button.
  ///
  /// If null, a default selected item builder is used which displays the string
  /// representation of the selected item.
  final Widget Function(BuildContext)? selectedItemBuilder;

  /// Called when the user selects an item from the dropdown.
  final ValueChanged<T?>? onChanged;

  /// The maximum height of the dropdown menu.
  late final double? menuMaxHeight;

  /// The height of each item in the dropdown menu.
  final double itemHeight;

  @override
  State<Dropdown<T>> createState() => _DropdownState<T>();
}

/// The state for the [Dropdown] widget.
class _DropdownState<T> extends State<Dropdown<T>> {
  OverlayEntry? overlayEntry;
  int? selectedIndex;
  GlobalKey globalKey = GlobalKey();

  /// The item builder for the dropdown list.
  ///
  /// Defaults to [defaultItemBuilder] if not provided in the widget.
  Widget Function(BuildContext, int index) get itemBuilder =>
      widget.itemBuilder ?? defaultItemBuilder;

  /// The selected item builder for the dropdown button.
  ///
  /// Defaults to [defaultSelectedItemBuilder] if not provided in the widget.
  Widget Function(BuildContext) get selectedItemBuilder =>
      widget.selectedItemBuilder ?? defaultSelectedItemBuilder;

  /// The default item builder for the dropdown list.
  ///
  /// Displays the string representation of each item.
  Widget defaultItemBuilder(BuildContext context, int index) {
    return Text(
      '${widget.items[index]}',
      style: Theme.of(context).dropdownMenuTheme.textStyle,
    );
  }

  /// The default selected item builder for the dropdown button.
  ///
  /// Displays the string representation of the selected item.
  Widget defaultSelectedItemBuilder(BuildContext context) {
    assert(selectedIndex != null);
    return Text(
      '${widget.items[selectedIndex!]}',
      style: Theme.of(context).dropdownMenuTheme.textStyle,
    );
  }

  @override
  void initState() {
    if (widget.value != null && widget.items.isNotEmpty) {
      selectedIndex = widget.items.indexOf(widget.value as T);
    }
    super.initState();
  }

  /// Creates and displays the dropdown overlay.
  ///
  /// The [position] and [size] parameters determine the placement and
  /// dimensions of the overlay.
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

    const paddingItem = 8.0;

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
              left: position.dx - paddingItem,
              top: position.dy,
              width: size.width + (paddingItem * 2),
              height: widget.menuMaxHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(boxShadow: kElevationToShadow[4]),
                child: Scrollbar(
                  thumbVisibility: true,
                  interactive: true,
                  controller: scrollController,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    controller: scrollController,
                    itemBuilder: (BuildContext context, int index) {
                      return Material(
                        color: index == selectedIndex
                            ? Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest
                            : Theme.of(context).colorScheme.surface,
                        child: Center(
                          child: InkWell(
                            onTap: () {
                              selectedIndex = index;
                              widget.onChanged?.call(widget.items[index]);
                              // Remove the overlay after selection.
                              removeHighlightOverlay();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(paddingItem),
                              height: widget.itemHeight,
                              alignment: Alignment.center,
                              child: itemBuilder(context, index),
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: widget.items.length,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    // Add the OverlayEntry to the Overlay.
    Overlay.of(context, debugRequiredFor: widget).insert(overlayEntry!);
  }

  /// Removes the dropdown overlay from the screen.
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
      key: globalKey,
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
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: selectedItemBuilder(context),
          ),
        ),
      ),
    );
  }
}
