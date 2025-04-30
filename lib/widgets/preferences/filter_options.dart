import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class FilterButtonWidget extends StatefulWidget {
  final List<String> selectedOptions;
  final List<String> options;
  final ValueChanged<List<String>> onSelectionChanged;

  const FilterButtonWidget({
    Key? key,
    required this.selectedOptions,
    required this.options,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  _FilterButtonWidgetState createState() => _FilterButtonWidgetState();
}

class _FilterButtonWidgetState extends State<FilterButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: widget.options.map((option) {
        bool isSelected = widget.selectedOptions.contains(option);
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                if (isSelected) {
                  widget.selectedOptions.remove(option);
                } else {
                  widget.selectedOptions.add(option);
                }
              });
              widget.onSelectionChanged(widget.selectedOptions);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isSelected ? AppTheme.primaryColor : AppTheme.cinzaClaro,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(option, style: TextStyle(color: isSelected ? Colors.white : Colors.black)),
          ),
        );
      }).toList(),
    );
  }
}
