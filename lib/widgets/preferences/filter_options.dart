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

class SingleSelectToggle extends StatelessWidget {
  final String label;
  final String? selectedOption;
  final List<String> options;
  final ValueChanged<String> onSelectionChanged;

  const SingleSelectToggle({
    Key? key,
    required this.label,
    required this.selectedOption,
    required this.options,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(label)),
          Wrap(
            spacing: 8,
            children: options.map((option) {
              final isSelected = selectedOption == option;
              return ElevatedButton(
                onPressed: () => onSelectionChanged(option),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSelected ? AppTheme.primaryColor : AppTheme.cinzaClaro,
                  foregroundColor: isSelected ? Colors.white : Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: Text(option),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}


class YesNoToggle extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const YesNoToggle({
    Key? key,
    required this.label,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(label)),
          ElevatedButton(
            onPressed: () => onChanged(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: value ? AppTheme.primaryColor : AppTheme.cinzaClaro,
              foregroundColor: value ? Colors.white : Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text('Sim'),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => onChanged(false),
            style: ElevatedButton.styleFrom(
              backgroundColor: !value ? AppTheme.primaryColor : AppTheme.cinzaClaro,
              foregroundColor: !value ? Colors.white : Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text('Não'),
          ),
        ],
      ),
    );
  }
}
