import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:konoyubi/ui/components/typography.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class ImageUpload {
  const ImageUpload(this.source,
      {this.quality = 15, this.minHeight = 300, this.minWidth = 450});

  final ImageSource source;
  final int quality;
  final int minHeight;
  final int minWidth;

  Future<File?> getImageFromDevice() async {
    // 撮影/選択したFileが返ってくる
    final imageFile = await ImagePicker().pickImage(source: source);
    // Androidで撮影せずに閉じた場合はnullになる
    if (imageFile == null) {
      return null;
    }
    final filePath = imageFile.path;
    final lastIndex = filePath.lastIndexOf('.');
    final split = filePath.substring(0, lastIndex);
    final outPath = '${split}_out.jpg';
    final File? compressedFile = await FlutterImageCompress.compressAndGetFile(
      filePath,
      outPath,
      minHeight: minHeight,
      minWidth: minWidth,
      quality: quality,
    );
    return compressedFile;
  }
}

Future<void> uploadImage({
  required String uploadTo,
  required BuildContext context,
  required String uid,
  required StateController<String> avatarURLController,
  required L10n l10n,
}) async {
  showCupertinoModalPopup<int>(
    context: context,
    builder: (BuildContext context) {
      return CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: Body1(l10n.takePicture),
            onPressed: () {
              Navigator.pop(context, 0);
            },
          ),
          CupertinoActionSheetAction(
            child: Body1(l10n.selectPhoto),
            onPressed: () {
              Navigator.pop(context, 1);
            },
          ),
          CupertinoActionSheetAction(
            child: Body1(l10n.cancel),
            onPressed: () {
              Navigator.pop(context, 2);
            },
            isDestructiveAction: true,
            isDefaultAction: true,
          ),
        ],
      );
    },
  ).then((value) async {
    switch (value) {
      case 0:
        return await const ImageUpload(ImageSource.camera).getImageFromDevice();
      case 1:
        return await const ImageUpload(ImageSource.gallery)
            .getImageFromDevice();
      case 2:
        break;
    }
  }).then((value) async {
    if (value == null) {
      return null;
    } else {
      return await FirebaseStorage.instance
          .ref()
          .child('user')
          .child(uid)
          .child(uploadTo)
          .putFile(value);
    }
  }).then((value) async {
    await FirebaseFirestore.instance
        .collection('userList')
        .doc(uid)
        .update({"avatarURL": await value?.ref.getDownloadURL()});
    return value?.ref.getDownloadURL();
  }).then((value) {
    if (value != null) {
      avatarURLController.state = value;
    }
  });
}
