import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimePickerDropdown extends StatelessWidget {
  final DateTime? selectedDate;
  final Function(DateTime) onDatePicked;
  final String labelText;

  const DateTimePickerDropdown({super.key, 
    required this.selectedDate, 
    required this.onDatePicked, 
    this.labelText = "Select date"
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async{
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2025), 
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: ThemeData.dark().copyWith(
                colorScheme: const ColorScheme.dark(
                  primary: Color(0xFFB7FF00),
                  onSurface: Colors.white,
                ),
                dialogTheme: const DialogTheme(
                  backgroundColor: Color(0xFF303030),
                ),
                canvasColor: Color(0xFF303030), // Ensures consistent background
              ),
              child: child!,
            );
          },
        );
        if (pickedDate != null) {
          // Wait until the dialog fully closes before opening the next
          Future.delayed(Duration.zero, () async {
            final pickedTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.fromDateTime(
                selectedDate ?? DateTime.now(),
              ),
              
              builder: (context, child) {
                return Theme(
                  data: ThemeData.dark().copyWith(
                    colorScheme: const ColorScheme.dark(
                      primary: Color(0xFFB7FF00),
                      onSurface: Colors.white,
                    ),
                    dialogTheme: const DialogTheme(
                      backgroundColor: Color(0xFF303030),
                    ),
                  ),
                  child: child!,
                );
              },
            );

            if (pickedTime != null) {
              final fullDateTime = DateTime(
                pickedDate.year,
                pickedDate.month,
                pickedDate.day,
                pickedTime.hour,
                pickedTime.minute,
              );
              if(fullDateTime.isAfter(DateTime.now())){
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Times in the future are invalid."),
                    backgroundColor: Colors.red,
                  ),
                );
              }else{
                onDatePicked(fullDateTime);
              }
            }
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedDate != null
                ? DateFormat('MM/dd/yyyy').format(selectedDate!)
                : labelText,
              style: TextStyle(color: Colors.white),
            ),
            Icon(Icons.arrow_drop_down, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

