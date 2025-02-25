// utils/dialogs/complaint_dialog.dart
import 'package:flutter/material.dart';
import 'package:moto_kent/models/complaint_reason_model.dart';

class ComplaintDialog {
  static Future<int?> show({
    required BuildContext context,
    required List<ComplaintReasonModel> reasons,
    int otherOptionId = 9,
    String title = 'Şikayet Nedenini Seçin',
   
  }) async {
    int? selectedReasonId;
    TextEditingController customReasonController = TextEditingController();

    return showDialog<int>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Column(
              children: [
                ...reasons.map((reason) => RadioListTile<int>(
                  title: Text(reason.complaintReasonContent!),
                  value: reason.id!,
                  groupValue: selectedReasonId,
                  onChanged: (value) => setState(() => selectedReasonId = value),
                )),
                if (selectedReasonId == otherOptionId)
                  TextField(
                    controller: customReasonController,
                    decoration: const InputDecoration(
                      labelText: "Nedeninizi Yazın",
                      border: OutlineInputBorder(),
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, selectedReasonId),
              child: const Text('Tamam'),
            ),
          ],
        ),
      ),
    );
  }
}