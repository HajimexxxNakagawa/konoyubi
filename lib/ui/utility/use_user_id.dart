import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:konoyubi/auth/user.dart';

String? useUserId() {
  final currentUser = useProvider(firebaseAuthProvider);
  final userId = currentUser.data?.value?.uid;

  return userId;
}
