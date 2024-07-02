import 'package:flutter/material.dart';

/// A widget that allows users to input and manage a collection of text items.
class CollectionBox extends StatefulWidget {
  /// Callback function triggered when the collection changes.
  final Function(List<String>) onCollectionChanged;

  /// Padding around the entire widget.
  final double outsidePadding;

  /// Padding inside the main container.
  final double insidePadding;

  /// Initial collection of items.
  final List<String>? collection;

  /// Custom input decoration for the text field.
  final InputDecoration? inputDecoration;

  /// Maximum number of items allowed in the collection.
  final int limit;

  /// Color of the border around the widget.
  final Color? borderColor;

  const CollectionBox({
    required this.onCollectionChanged,
    this.outsidePadding = 10,
    this.insidePadding = 10,
    this.collection,
    this.inputDecoration,
    this.limit = 10,
    this.borderColor,
    super.key,
  });

  @override
  State<CollectionBox> createState() => _CollectionBoxState();
}

class _CollectionBoxState extends State<CollectionBox> {
  // Controller for the input text field
  final TextEditingController _controller = TextEditingController();

  // List to store the collection items
  List<String> collection = [];

  @override
  void initState() {
    super.initState();

    // Initialize collection with provided items, if any
    if (widget.collection != null) {
      collection = widget.collection!.toSet().toList();
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed
    _controller.dispose();
    super.dispose();
  }

  /// Adds the current text input to the collection
  _addToCollection() {
    if (!collection.contains(_controller.text)) {
      final String text = _controller.text.trim();
      if (text.isNotEmpty && widget.limit > collection.length) {
        widget.onCollectionChanged(collection);
        setState(() {
          collection.add(text);
        });
      } else {
        debugPrint("Limit reached");
        return;
      }

      _controller.clear();
    }
  }

  /// Removes a specific item from the collection
  _removeFromCollection(String skill) {
    setState(() {
      collection.remove(skill);
    });
    widget.onCollectionChanged(collection);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(widget.outsidePadding),
      child: SizedBox(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
                color: widget.borderColor ?? Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: EdgeInsets.all(widget.insidePadding),
            child: Column(
              children: [
                // Text input field for adding new items
                TextField(
                  controller: _controller,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  decoration: widget.inputDecoration ??
                      InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color.fromARGB(66, 0, 0, 0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color.fromARGB(66, 0, 0, 0)),
                        ),
                        hintText: "Skills",
                        hintStyle: Theme.of(context).textTheme.bodyLarge,
                        suffixIcon: IconButton(
                          splashRadius: 5,
                          onPressed: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            _addToCollection();
                          },
                          icon: const Icon(Icons.add),
                        ),
                      ),
                ),
                const SizedBox(height: 20),
                // Display collection items or a message if empty
                collection.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child:
                            Text("Please add at least one item to the section"),
                      )
                    : SizedBox(
                        width: double.infinity,
                        child: Wrap(
                          spacing: 10,
                          children: List.generate(collection.length, (index) {
                            final String skill = collection[index];
                            return Chip(
                              label: Text(skill),
                              shape: const StadiumBorder(
                                  side: BorderSide(width: 0.5)),
                              side: const BorderSide(
                                  color: Color.fromARGB(66, 0, 0, 0)),
                              onDeleted: () {
                                _removeFromCollection(skill);
                              },
                              clipBehavior: Clip.hardEdge,
                            );
                          }),
                        ),
                      ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
