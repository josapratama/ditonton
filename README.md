# Ditonton — Flutter Expert Final Submission

[![CI](https://github.com/josapratama/ditonton/actions/workflows/ci.yml/badge.svg)](https://github.com/josapratama/ditonton/actions/workflows/ci.yml)

> **Catatan:** Repository: [https://github.com/josapratama/ditonton](https://github.com/josapratama/ditonton)

Repository ini merupakan proyek submission akhir kelas **Flutter Expert** Dicoding Indonesia — _Membuat Aplikasi Siap Rilis_.

---

## Fitur yang Diimplementasikan

### ✅ Kriteria Wajib

#### 1. Continuous Integration (GitHub Actions)

- Workflow otomatis berjalan setiap ada `push` atau `pull_request` ke branch `main`/`master`
- Menjalankan `flutter analyze` dan `flutter test --coverage`
- Membangun APK debug secara otomatis
- Konfigurasi: `.github/workflows/ci.yml`

#### 2. Migrasi State Management: Provider → BLoC

- Seluruh state management dimigrasi dari `Provider`/`ChangeNotifier` ke `flutter_bloc`
- BLoC yang diimplementasikan:
  - **Movie:** `NowPlayingMoviesBloc`, `PopularMoviesBloc`, `TopRatedMoviesBloc`, `MovieDetailBloc`, `MovieSearchBloc`, `WatchlistMovieBloc`
  - **TV Series:** `OnAirTVSeriesBloc`, `PopularTVSeriesBloc`, `TopRatedTVSeriesBloc`, `TVSeriesDetailBloc`, `TVSeriesSearchBloc`, `WatchlistTVSeriesBloc`

#### 3. SSL Pinning

- Sertifikat `*.themoviedb.org` di-pin menggunakan `SecurityContext` + `IOClient`
- Sertifikat disimpan di `assets/themoviedb.cer`
- Implementasi: `lib/common/ssl_pinning.dart`

#### 4. Firebase Analytics & Crashlytics

- **Firebase Analytics**: Mencatat navigasi pengguna secara otomatis via `FirebaseAnalyticsObserver`
- **Firebase Crashlytics**: Menangkap Flutter errors (`FlutterError.onError`) dan async platform errors (`PlatformDispatcher.instance.onError`)
- Konfigurasi Android: `android/app/google-services.json`

---

## Arsitektur

Project menggunakan **Clean Architecture** dengan tiga lapisan:

```
lib/
├── common/          # Constants, utils, SSL pinning
├── data/            # Models, repositories impl, data sources
├── domain/          # Entities, use cases, repository interfaces
└── presentation/
    ├── bloc/        # BLoC (events, states, blocs)
    ├── pages/       # UI pages
    └── widgets/     # Reusable widgets
```

---

## Cara Menjalankan

### Prasyarat

- Flutter 3.47.2 (stable)
- Android Studio / VS Code
- File `google-services.json` dari Firebase Console (untuk fitur Analytics & Crashlytics)

### Setup Firebase

1. Buat project baru di [Firebase Console](https://console.firebase.google.com/)
2. Daftarkan Android app dengan package name `com.dicoding.ditonton`
3. Download `google-services.json` dan letakkan di `android/app/`
4. Aktifkan **Analytics** dan **Crashlytics** di Firebase Console

### Menjalankan Aplikasi

```bash
flutter pub get
flutter run
```

### Menjalankan Tests

```bash
flutter test --coverage
```

---

## Tips Submission

Pastikan untuk memeriksa kembali seluruh hasil testing pada submissionmu sebelum dikirimkan.

### Menjalankan test dengan coverage report

#### Linux

```bash
sudo apt-get install lcov -y
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

#### Mac

```bash
brew install lcov
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

#### Windows (via Chocolatey)

```powershell
choco install lcov
flutter test --coverage
```

Jika menggunakan modularisasi, jalankan `test.sh` di terminal:

```bash
./test.sh
```
