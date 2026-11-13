import 'package:flutter/material.dart';
import '../models/student.dart';
import '../providers/app_provider.dart';
import '../widgets/profile_card.dart';

class ProfileScreen extends StatefulWidget {
  final Student? initialStudent;

  const ProfileScreen({
    super.key,
    this.initialStudent,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Student? _localStudent;

  Student _getCurrentStudent(BuildContext context) {
    final provider = AppProvider.maybeOf(context);
    if (provider != null) {
      return provider.student;
    }
    return _localStudent ??
        widget.initialStudent ??
        const Student(
          name: 'Roy Widyadhana Prastowo',
          nim: '25.11.6571',
          programStudi: 'S1 Informatika',
          email: 'r.widyadhana@students.amikom.ac.id',
        );
  }

  void _showEditProfileDialog(Student currentStudent) {
    final nameController = TextEditingController(text: currentStudent.name);
    final nimController = TextEditingController(text: currentStudent.nim);
    final prodiController = TextEditingController(text: currentStudent.programStudi);
    final emailController = TextEditingController(text: currentStudent.email);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Edit Profil'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Lengkap',
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Nama tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: nimController,
                    decoration: const InputDecoration(
                      labelText: 'NIM',
                      prefixIcon: Icon(Icons.badge),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'NIM tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: prodiController,
                    decoration: const InputDecoration(
                      labelText: 'Program Studi',
                      prefixIcon: Icon(Icons.school),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Program studi tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Email tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  final updatedStudent = currentStudent.copyWith(
                    name: nameController.text.trim(),
                    nim: nimController.text.trim(),
                    programStudi: prodiController.text.trim(),
                    email: emailController.text.trim(),
                  );

                  final provider = AppProvider.maybeOf(context);
                  if (provider != null) {
                    provider.updateStudent(updatedStudent);
                  } else {
                    setState(() {
                      _localStudent = updatedStudent;
                    });
                  }

                  Navigator.of(dialogContext).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profil berhasil diperbarui'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final student = _getCurrentStudent(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Mahasiswa'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ProfileCard(student: student),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _showEditProfileDialog(student),
              icon: const Icon(Icons.edit),
              label: const Text('Edit Profil'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
