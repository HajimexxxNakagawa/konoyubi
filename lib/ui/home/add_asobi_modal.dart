import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AddAsobiModal extends HookWidget {
  const AddAsobiModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _current = useState(0);
    CollectionReference asobiList =
        FirebaseFirestore.instance.collection('asobiList');
    final user = FirebaseAuth.instance.currentUser;

    // mock
    Future<void> addAsobi() {
      return asobiList.add({
        'title': '遊ぶ！',
        'owner': user!.uid,
        'description': 'とにかく遊ぶ',
        'position': const GeoPoint(35, 143)
      }).catchError((error) => print("Failed to add asobi: $error"));
    }

    _onCancel() {
      if (_current.value > 0) {
        _current.value -= 1;
      }
    }

    _onContinue() {
      if (_current.value <= 2) {
        _current.value += 1;
      }
    }

    _onStepTapped(int index) {
      _current.value = index;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('アソビを作る', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Stepper(
          currentStep: _current.value,
          onStepCancel: _onCancel,
          onStepContinue: _onContinue,
          onStepTapped: _onStepTapped,
          steps: <Step>[
            Step(
              title: const Text('ナマエを付ける'),
              isActive: _current.value == 0,
              content: Container(
                alignment: Alignment.centerLeft,
                child: const Text('Content for Step 1'),
              ),
            ),
            Step(
              title: const Text('セツメイを書く'),
              isActive: _current.value == 1,
              content: Container(
                alignment: Alignment.centerLeft,
                child: const Text('Content for Step 1'),
              ),
            ),
            Step(
              title: const Text('バショを決める'),
              isActive: _current.value == 2,
              content: Container(
                alignment: Alignment.centerLeft,
                child: const Text('Content for Step 1'),
              ),
            ),
            Step(
              title: const Text('ジカンを決める'),
              isActive: _current.value == 3,
              content: Container(
                alignment: Alignment.centerLeft,
                child: const Text('Content for Step 1'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
