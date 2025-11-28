import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_provider.dart';

class GenderScreen extends ConsumerStatefulWidget {
  const GenderScreen({super.key});
  @override
  ConsumerState<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends ConsumerState<GenderScreen> {
  String? _gender;

  @override
  void initState() {
    super.initState();
    final u = ref.read(userProvider);
    _gender = u?.gender ?? 'Male';
  }

  void _save() {
    final u = ref.read(userProvider);
    if (u != null) {
      u.gender = _gender;
      ref.read(userUpdaterProvider).updateProfile(u);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gender')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          DropdownButtonFormField<String>(
            initialValue: _gender,
            items: const [
              DropdownMenuItem(value: 'Male', child: Text('Male')),
              DropdownMenuItem(value: 'Female', child: Text('Female')),
              DropdownMenuItem(value: 'Other', child: Text('Other')),
            ],
            onChanged: (v) => setState(() => _gender = v),
            decoration: const InputDecoration(labelText: 'Choose Gender'),
          ),
          const Spacer(),
          SizedBox(
              width: double.infinity,
              child:
                  ElevatedButton(onPressed: _save, child: const Text('Save')))
        ]),
      ),
    );
  }
}
