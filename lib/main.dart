import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Form Registrasi',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const RegistrasiPage(),
    );
  }
}

class RegistrasiPage extends StatefulWidget {
  const RegistrasiPage({super.key});

  @override
  State<RegistrasiPage> createState() => _RegistrasiPageState();
}

class _RegistrasiPageState extends State<RegistrasiPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _namaFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  String? _jenisKelamin;
  String? _programStudi;
  bool _setuju = false;
  bool _passwordTersembunyi = true;

  final List<String> _daftarProdi = [
    'Informatika',
    'Sistem Informasi',
    'Manajemen',
    'Akuntansi',
    'Pendidikan',
  ];

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _namaFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  // Fungsi tombol Daftar
  void _daftar() {
    FocusScope.of(context).unfocus();

    // Periksa persetujuan terlebih dahulu
    if (!_setuju) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              'Silakan setujui Syarat & Ketentuan terlebih dahulu!',
            ),
            backgroundColor: Colors.red,
          ),
        );
      return;
    }

    // Validasi seluruh field pada Form
    final form = _formKey.currentState;

    if (form == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Form belum siap. Silakan coba lagi.'),
        ),
      );
      return;
    }

    final valid = form.validate();

    // Periksa jenis kelamin
    if (_jenisKelamin == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih jenis kelamin!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Jika semua valid, tampilkan dialog konfirmasi
    if (valid) {
      _tampilkanKonfirmasi();
    }
  }

  // Dialog konfirmasi data
  void _tampilkanKonfirmasi() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Registrasi'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pastikan data yang kamu masukkan sudah benar.',
                ),
                const SizedBox(height: 16),
                _barisData('Nama', _namaController.text),
                _barisData('Email', _emailController.text),
                _barisData('Jenis Kelamin', _jenisKelamin!),
                _barisData('Program Studi', _programStudi!),
                _barisData(
                  'Syarat & Ketentuan',
                  _setuju ? 'Disetujui' : 'Belum disetujui',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Periksa Lagi'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Registrasi berhasil dikonfirmasi!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Konfirmasi'),
            ),
          ],
        );
      },
    );
  }

  Widget _barisData(String judul, String isi) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 125,
            child: Text(
              '$judul:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(isi)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Form Registrasi',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Icon(
                  Icons.app_registration,
                  size: 70,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 12),
              const Center(
                child: Text(
                  'Silakan isi data registrasi',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Nama Lengkap
              const Text(
                'Nama Lengkap',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _namaController,
                focusNode: _namaFocus,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  hintText: 'Masukkan nama lengkap',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_emailFocus);
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama lengkap wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Email
              const Text(
                'Email',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailController,
                focusNode: _emailFocus,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  hintText: 'contoh@email.com',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_passwordFocus);
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email wajib diisi';
                  }

                  if (!value.contains('@') ||
                      !value.contains('.') ||
                      value.startsWith('@')) {
                    return 'Masukkan alamat email yang valid';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Password
              const Text(
                'Password',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _passwordController,
                focusNode: _passwordFocus,
                obscureText: _passwordTersembunyi,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText: 'Minimal 6 karakter',
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordTersembunyi
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordTersembunyi = !_passwordTersembunyi;
                      });
                    },
                  ),
                ),
                onFieldSubmitted: (_) {
                  FocusScope.of(context).unfocus();
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password wajib diisi';
                  }

                  if (value.length < 6) {
                    return 'Password minimal 6 karakter';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Jenis Kelamin
              const Text(
                'Jenis Kelamin',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              RadioGroup<String>(
                groupValue: _jenisKelamin,
                onChanged: (value) {
                  setState(() {
                    _jenisKelamin = value;
                  });
                },
                child: const Column(
                  children: [
                    RadioListTile<String>(
                      title: Text('Laki-laki'),
                      value: 'Laki-laki',
                      contentPadding: EdgeInsets.zero,
                    ),
                    RadioListTile<String>(
                      title: Text('Perempuan'),
                      value: 'Perempuan',
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Program Studi
              const Text(
                'Program Studi',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _programStudi,
                isExpanded: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.school),
                  hintText: 'Pilih program studi',
                ),
                items: _daftarProdi.map((prodi) {
                  return DropdownMenuItem<String>(
                    value: prodi,
                    child: Text(prodi),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _programStudi = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Silakan pilih program studi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Syarat dan Ketentuan
              CheckboxListTile(
                value: _setuju,
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text(
                  'Saya setuju dengan Syarat & Ketentuan',
                ),
                onChanged: (value) {
                  setState(() {
                    _setuju = value ?? false;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Tombol Daftar
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton.icon(
                  onPressed: () {
                    _daftar();
                  },
                  icon: const Icon(Icons.app_registration),
                  label: const Text(
                    'Daftar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}