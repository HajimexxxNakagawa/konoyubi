import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:konoyubi/ui/theme/constants.dart';
import 'package:konoyubi/ui/theme/height_width.dart';

final nameControllerProvider =
    StateProvider<TextEditingController?>((ref) => TextEditingController());
final twitterControllerProvider =
    StateProvider<TextEditingController?>((ref) => TextEditingController());
final facebookControllerProvider =
    StateProvider<TextEditingController?>((ref) => TextEditingController());

class EditProfileScreen extends HookWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = useWidth();
    final nameController = useProvider(nameControllerProvider);
    final twitterController = useProvider(twitterControllerProvider);
    final facebookController = useProvider(facebookControllerProvider);
    useEffect(() {
      nameController.state?.text = "baka";
      return () {
        print("Update FireStore");
      };
    },
        // [keys]は空配列でも問題ない
        const []);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: bodyColor),
      ),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: width * 0.9,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.person,
                    color: bodyColor,
                    size: 40,
                  ),
                  title: ProfileForm(
                    hintText: "Your Name",
                    controller: nameController.state,
                  ),
                ),
                ListTile(
                  leading: const FaIcon(
                    FontAwesomeIcons.twitter,
                    color: Colors.lightBlue,
                    size: 36,
                  ),
                  title: ProfileForm(
                    hintText: "@abcd",
                    controller: twitterController.state,
                  ),
                ),
                ListTile(
                  leading: const FaIcon(
                    FontAwesomeIcons.facebook,
                    color: Colors.blue,
                    size: 36,
                  ),
                  title: ProfileForm(
                    hintText: "@abcd",
                    controller: facebookController.state,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileForm extends StatelessWidget {
  const ProfileForm({Key? key, this.hintText, this.controller})
      : super(key: key);

  final String? hintText;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFE3E8EE),
            width: 2,
          ),
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFE3E8EE),
            width: 2,
          ),
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        fillColor: const Color(0xFFF7FAFC),
        filled: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      ),
      cursorColor: bodyColor,
    );
  }
}
