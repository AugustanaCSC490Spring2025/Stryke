import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerDropdown extends StatelessWidget {
  final DateTime? selectedDate;
  final Function(DateTime) onDatePicked;
  final String labelText;


  const DatePickerDropdown({super.key, 
    required this.selectedDate, 
    required this.onDatePicked, 
    this.labelText = "Select a date"
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()async{
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2025), 
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: ThemeData.dark().copyWith(
                colorScheme: ColorScheme.dark(
                  primary: Color(0xFFB7FF00),
                  onSurface: Colors.white,
                ),
                dialogBackgroundColor: Color(0xFF2A2A2A),
              ), 
              child: child!
            );
          },
        );
        if(pickedDate != null){
          onDatePicked(pickedDate);
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

