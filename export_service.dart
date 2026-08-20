import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/note.dart';

/// Mengekspor seluruh catatan menjadi satu file .txt yang bisa
/// disimpan/di-download atau dibagikan pengguna (backup manual).
class ExportService {
  static Future<File> exportNotesToFile(List<Note> notes) async {
    final dir = await getApplicationDocumentsDirectory();
    final fileName = 'notepad_backup_${DateFormat('yyyyMMdd_HHmm').format(DateTime.now())}.txt';
    final file = File('${dir.path}/$fileName');

    final buffer = StringBuffer();
    buffer.writeln('NOTEPAD BACKUP');
    buffer.writeln('Diekspor pada: ${DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now())}');
    buffer.writeln('Total catatan: ${notes.length}');
    buffer.writeln('=' * 40);
    for (final n in notes) {
      buffer.writeln();
      buffer.writeln('[${n.type.label}] ${n.title}');
      buffer.writeln('Dibuat: ${DateFormat('dd-MM-yyyy HH:mm').format(n.createdAt)}');
      if (n.type == NoteType.shopList) {
        for (final item in n.checklist) {
          buffer.writeln('  ${item.checked ? '[x]' : '[ ]'} ${item.text}');
        }
      } else if (n.content.isNotEmpty) {
        buffer.writeln(n.content);
      }
      buffer.writeln('-' * 30);
    }

    await file.writeAsString(buffer.toString());
    return file;
  }

  static Future<void> exportAndShare(List<Note> notes) async {
    final file = await exportNotesToFile(notes);
    await Share.shareXFiles([XFile(file.path)], text: 'Backup catatan Notepad');
  }
}
