class MyUser {
  late final String uid;
  late String name = '';
  late int age = 99;
  late String aboutMe = '';
  late String email = '';
  MyUser({
    required this.uid,
  });
  toJson() {
    return {
      "UserId": uid,
      "Name": name,
      "Age": age,
      "AboutMe": aboutMe,
      "Email": email,
    };
  }
}
