import 'package:flutter/material.dart';
import 'package:mobile_assignment/main.dart';

class DisplayWidget extends StatefulWidget {
  final List<FibonacciItem> fibonacciList;

  const DisplayWidget({super.key, required this.fibonacciList});

  @override
  _DisplayWidgetState createState() => _DisplayWidgetState();
}

class _DisplayWidgetState extends State<DisplayWidget> {
  List<int> selectedIndices = [];
  int? recentlyAddedIndex;
  int? recentlyRemovedIndex;
  final ScrollController _scrollController = ScrollController();

  IconData _getIcon(int value) {
    if (value % 3 == 0) {
      return Icons.circle;
    } else if (value % 3 == 1) {
      return Icons.square_outlined;
    } else {
      return Icons.close;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<FibonacciItem> filteredList = widget.fibonacciList
        .where((item) => !selectedIndices.any((index) => index == item.index))
        .toList();

    return ListView.builder(
      controller: _scrollController,
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        final currentItem = filteredList[index];
        final bool isRecentAddition = currentItem.index == recentlyAddedIndex;
        final bool isRecentlyRemoved =
            currentItem.index == recentlyRemovedIndex;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: ListTile(
            title: Container(
              color: isRecentAddition
                  ? Colors.red
                  : isRecentlyRemoved
                      ? Colors.red
                      : null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'index ${currentItem.index}, Number: ${currentItem.value}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  Icon(
                    _getIcon(currentItem.value),
                    size: 20,
                  ),
                ],
              ),
            ),
            onTap: () {
              setState(() {
                selectedIndices.add(currentItem.index);
                selectedIndices.sort();
              });
              recentlyAddedIndex = currentItem.index;
              recentlyRemovedIndex = null;

              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    height: 400,
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        if (currentItem.value % 3 == 0)
                          _buildBottomSheetList(Icons.circle)
                        else if (currentItem.value % 3 == 1)
                          _buildBottomSheetList(Icons.square_outlined)
                        else
                          _buildBottomSheetList(Icons.close)
                      ],
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  void _scrollToItem(int index) {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        index * 5,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget _buildBottomSheetList(IconData icon) {
    List<FibonacciItem> items = selectedIndices
        .map((index) => widget.fibonacciList[index])
        .where((item) => _getIcon(item.value) == icon)
        .toList();
    return Expanded(
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final selectedItem = items[index];
          final bool isRecentAddition =
              selectedItem.index == recentlyAddedIndex;
          return ListTile(
            title: Container(
              color: isRecentAddition ? Colors.green : null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Number : ${selectedItem.value}\nIndex : ${selectedItem.index}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  Icon(
                    _getIcon(selectedItem.value),
                    size: 20,
                  ),
                ],
              ),
            ),
            onTap: () {
              setState(() {
                selectedIndices.remove(selectedItem.index);
                selectedIndices.sort();
              });
              recentlyRemovedIndex = selectedItem.index;
              Navigator.pop(context);
              _scrollToItem(index);
            },
          );
        },
      ),
    );
  }
}
