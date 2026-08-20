import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/note.dart';

class NoteTile extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onTogglePin;

  const NoteTile({
    super.key,
    required this.note,
    required this.onTap,
    required this.onDelete,
    required this.onTogglePin,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('HH:mm  dd-MM-yyyy').format(note.updatedAt);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 34,
              height: 34,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                color: note.type.color,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(note.type.icon, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.title.isEmpty ? '(Tanpa judul)' : note.title,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (note.pinned || note.hasAlarm || note.locked) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (note.pinned)
                          const Padding(
                            padding: EdgeInsets.only(right: 6),
                            child: Icon(Icons.push_pin, size: 14, color: Colors.grey),
                          ),
                        if (note.hasAlarm)
                          const Padding(
                            padding: EdgeInsets.only(right: 6),
                            child: Icon(Icons.alarm, size: 14, color: Colors.grey),
                          ),
                        if (note.locked)
                          const Padding(
                            padding: EdgeInsets.only(right: 6),
                            child: Icon(Icons.lock, size: 14, color: Colors.grey),
                          ),
                        if (note.hasAlarm && note.alarmTime != null)
                          Text(
                            DateFormat('HH:mm dd-MM-yyyy').format(note.alarmTime!),
                            style: const TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(dateStr, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.more_vert, color: Colors.grey),
                  onSelected: (v) {
                    if (v == 'delete') onDelete();
                    if (v == 'pin') onTogglePin();
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(value: 'pin', child: Text(note.pinned ? 'Lepas pin' : 'Pin')),
                    const PopupMenuItem(value: 'delete', child: Text('Hapus')),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
