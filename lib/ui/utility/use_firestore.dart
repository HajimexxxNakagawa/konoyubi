import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:konoyubi/auth/user.dart';

/// currentUserが自ら募集している、締切の過ぎていないアソビを取得する。
/// 未ログインの場合はからのリストが返ってくる。
AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>?> useMyActiveAsobiList() {
  final currentUser = useProvider(firebaseAuthProvider);
  final userId = currentUser.data?.value?.uid;
  final now = Timestamp.now();
  final myActiveAsobiStream = FirebaseFirestore.instance
      .collection('userList')
      .doc(userId)
      .collection('asobiList')
      .where('end', isGreaterThanOrEqualTo: now)
      .snapshots;
  // TODO: アソビの募集締め切りを設定し、フィルターをかける
  final snapshot = useMemoized(myActiveAsobiStream);
  final myActiveAsobiList = useStream(snapshot);

  return myActiveAsobiList;
}

/// 募集締め切りを過ぎていないアソビのリストを取得する
AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>?> useActiveAsobiList() {
  final activeAsobiStream =
      FirebaseFirestore.instance.collection('asobiList').snapshots;
  // TODO: アソビの募集締め切りを設定し、フィルターをかける
  final snapshot = useMemoized(activeAsobiStream);
  final activeAsobiList = useStream(snapshot);

  return activeAsobiList;
}

/// currentUserの情報に関するStreamを取得する
AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>?> useUserInfo() {
  final currentUser = useProvider(firebaseAuthProvider);
  final userId = currentUser.data?.value?.uid;
  final userList =
      FirebaseFirestore.instance.collection('userList').doc(userId).snapshots;
  final snapshots = useMemoized(userList);
  final userInfo = useStream(snapshots);

  return userInfo;
}
