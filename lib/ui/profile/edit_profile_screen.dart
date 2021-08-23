import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:konoyubi/auth/user.dart';
import 'package:konoyubi/data/model/user.dart';
import 'package:konoyubi/ui/components/typography.dart';
import 'package:konoyubi/ui/profile/validation.dart';
import 'package:konoyubi/ui/theme/constants.dart';
import 'package:konoyubi/ui/theme/height_width.dart';
import 'package:konoyubi/ui/utility/upload_image.dart';
import 'package:konoyubi/ui/utility/use_l10n.dart';

final nameControllerProvider =
    StateProvider<TextEditingController?>((ref) => TextEditingController());
final twitterControllerProvider =
    StateProvider<TextEditingController?>((ref) => TextEditingController());
final facebookControllerProvider =
    StateProvider<TextEditingController?>((ref) => TextEditingController());
final biographyControllerProvider =
    StateProvider<TextEditingController?>((ref) => TextEditingController());
final avatarURLControllerProvider = StateProvider<String>((ref) => '');

class EditProfileScreen extends HookWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = useL10n(context);
    final width = useWidth();
    final nameController = useProvider(nameControllerProvider);
    final twitterController = useProvider(twitterControllerProvider);
    final facebookController = useProvider(facebookControllerProvider);
    final biographyController = useProvider(biographyControllerProvider);
    final avatarURLController = useProvider(avatarURLControllerProvider);
    final auth = useProvider(firebaseAuthProvider);
    final currentUser = useProvider(currentUserProvider);
    final bottomSpace = MediaQuery.of(context).viewInsets.bottom;
    final height = useHeight();

    Future<void> updateUser() {
      CollectionReference userList =
          FirebaseFirestore.instance.collection('userList');

      return userList.doc(auth.data?.value?.uid).update(
        {
          'name': nameController.state?.text,
          'avatarURL': avatarURLController.state,
          'description': biographyController.state!.text,
          'twitter': twitterController.state!.text,
          'facebook': facebookController.state!.text,
        },
      );
    }

    Future<void> updateCurrentUserState() async {
      final newName = nameController.state!.text;
      currentUser.state = User(
        name: newName,
        avatarURL: avatarURLController.state,
        description: biographyController.state!.text,
        twitter: twitterController.state!.text,
        facebook: facebookController.state!.text,
      );
    }

    useEffect(() {
      nameController.state?.text = currentUser.state.name;
      twitterController.state?.text = currentUser.state.twitter;
      facebookController.state?.text = currentUser.state.facebook;
      biographyController.state?.text = currentUser.state.description;
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        avatarURLController.state = currentUser.state.avatarURL;
      });

      return () async {
        await updateUser();
        await updateCurrentUserState();
      };
    }, const []);

    return WillPopScope(
      onWillPop: () async {
        final name = nameController.state?.text;
        final biography = biographyController.state!.text;
        final isNameValid = nameValidation(
          name: name,
          context: context,
          l10n: l10n,
        );
        final isBiographyValid = biographyValidation(
          biography: biography,
          context: context,
          l10n: l10n,
        );

        return isNameValid && isBiographyValid;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: bodyColor),
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              reverse: true,
              child: Padding(
                padding: EdgeInsets.only(bottom: bottomSpace),
                child: SizedBox(
                  width: width * 0.8,
                  height: height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(flex: 2),
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Container(
                            width: 150,
                            height: 150,
                            child: avatarURLController.state == ''
                                ? const SizedBox()
                                : CachedNetworkImage(
                                    imageUrl: avatarURLController.state,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                            clipBehavior: Clip.antiAlias,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                            ),
                          ),
                          Align(
                            alignment: const Alignment(0.32, 1),
                            child: ElevatedButton(
                              child: const Icon(
                                Icons.camera_alt,
                                color: bodyColor,
                              ),
                              onPressed: () {
                                uploadImage(
                                  uploadTo: "profileImage",
                                  context: context,
                                  uid: auth.data!.value!.uid,
                                  avatarURLController: avatarURLController,
                                  l10n: l10n,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(12),
                                primary: Colors.grey[350],
                              ),
                            ),
                          )
                        ],
                      ),
                      const Spacer(flex: 2),
                      ProfileField(
                        hintText: "Name",
                        controller: nameController.state,
                        icon: const Icon(
                          Icons.person,
                          color: bodyColor,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ProfileField(
                        hintText: l10n.atUnnecessary,
                        controller: twitterController.state,
                        icon: const FaIcon(
                          FontAwesomeIcons.twitter,
                          color: Colors.lightBlue,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ProfileField(
                        hintText: l10n.userName,
                        controller: facebookController.state,
                        icon: const FaIcon(
                          FontAwesomeIcons.facebook,
                          color: Colors.blue,
                          size: 40,
                        ),
                      ),
                      const Spacer(),
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Body1("Biography"),
                      ),
                      ProfileField(
                        hintText: "Tell us about you!",
                        maxLines: 10,
                        controller: biographyController.state,
                      ),
                      const Spacer(flex: 3),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileField extends StatelessWidget {
  const ProfileField({
    Key? key,
    this.hintText,
    this.controller,
    this.icon,
    this.maxLines = 1,
  }) : super(key: key);

  final String? hintText;
  final TextEditingController? controller;
  final Widget? icon;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        icon: icon,
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
        contentPadding: const EdgeInsets.all(12),
      ),
      cursorColor: bodyColor,
    );
  }
}
