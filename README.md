# Notepad App (Flutter)

Aplikasi catatan mobile bergaya "Notepad" — list catatan, tambah catatan teks & shop list,
pin/alarm/lock, kalender dengan penanda tanggal, pencarian, dan ekspor/backup catatan
ke file `.txt` yang bisa disimpan atau dibagikan (download).

## Fitur
- **Home**: daftar catatan dengan ikon warna per tipe, pencarian real-time, timestamp.
- **New note**: bottom sheet pilih tipe catatan (Note, Picture, Photo, Photo Text, Record, Shop List, From gallery, Video).
- **Text note editor**: tampilan kertas bergaris, judul opsional, tombol Pin / Alarm / Lock.
- **Shop List**: catatan checklist dengan tambah/centang/hapus item.
- **Calendar**: kalender bulanan, titik penanda pada tanggal yang punya catatan, tap tanggal untuk lihat catatannya.
- **Simpan permanen**: semua catatan tersimpan otomatis di SQLite lokal (`sqflite`) — tetap ada walau aplikasi ditutup.
- **Download/backup**: tombol download di bottom bar mengekspor semua catatan ke file `.txt` lalu membuka menu share/save Android (simpan ke penyimpanan, kirim ke WhatsApp/Drive/Email, dll).

## Struktur Proyek
```
lib/
  main.dart                    # entry point
  theme.dart                   # tema warna coklat/krem
  models/note.dart             # model Note + NoteType + ChecklistItem
  services/database_service.dart   # CRUD SQLite
  services/export_service.dart     # ekspor/backup ke .txt + share
  screens/home_screen.dart         # list + search + FAB + bottom nav
  screens/new_note_sheet.dart      # menu "New note"
  screens/note_editor_screen.dart  # editor teks & checklist
  screens/calendar_screen.dart     # kalender + catatan per tanggal
  widgets/note_tile.dart           # item baris pada list
```

## Cara Menjalankan
Butuh Flutter SDK terpasang (flutter.dev) dan device/emulator Android atau iOS.

```bash
flutter pub get
flutter run
```

## Cara Build APK (untuk didownload/dipasang di HP)
```bash
flutter build apk --release
```
File hasil build ada di:
```
build/app/outputs/flutter-apk/app-release.apk
```
Salin/kirim file `.apk` tersebut ke HP Android untuk diinstal.

## Catatan Pengembangan Lanjutan
- Tipe catatan Picture/Photo/Record/Video sudah tersedia di menu dan model data,
  namun saat ini dibuka dengan editor teks sederhana — bisa dikembangkan lagi
  dengan `image_picker` (foto/galeri) dan `record`/`flutter_sound` (rekam suara).
- Untuk fitur lock (kunci catatan) sungguhan bisa ditambahkan `local_auth` (PIN/fingerprint).
- Untuk notifikasi alarm sungguhan bisa ditambahkan `flutter_local_notifications`.
