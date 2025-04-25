import 'package:flutter/material.dart';

class ExitPopup extends StatefulWidget {
  const ExitPopup({super.key});

  @override
  State<ExitPopup> createState() => _ExitPopupState();
}

class _ExitPopupState extends State<ExitPopup> {

  @override
  Widget build(BuildContext context) {
    // Returns an AlertDialog widget that serves as a popup dialog
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      insetPadding: const EdgeInsets.all(20),
      backgroundColor: Colors.white,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Choose an option'),
          IconButton(onPressed: () => Navigator.pop(context, 'cancel'), icon: const Icon( Icons.cancel))
        ],
      ),
      content: const Text('Would you like to save or delete the data before exiting?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, 'save'); // Closes the dialog and returns 'save'
            Navigator.pop(context); // Additional pop to reach homescreen
          },
          child: const Text('Save'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, 'delete'); // Closes the dialog and returns 'delete'
            Navigator.pop(context); // Additional pop to reach homescreen
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
