/*

Author: Raphael Vispo
Section: D3L
Exercise number: 6
Program Description: View, Add and delete friends

*/

class UserModel {
  String id;
  String? email;
  String? firstName;
  String? lastName;
  DateTime? birthday;
  List? receivedFriendRequest;
  List? sentFriendRequest;
  List? friends;
  Map? location;
  List? todo;
  List? sharedTodo;
  String? bio;

  UserModel(
      {required this.id,
      this.email,
      this.firstName,
      this.lastName,
      this.birthday,
      this.location,
      this.receivedFriendRequest,
      this.sentFriendRequest,
      this.friends,
      this.todo,
      this.sharedTodo,
      this.bio});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    //print(json);
    UserModel user = UserModel(
        id: json['id'],
        email: json['email'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        birthday: DateTime.fromMicrosecondsSinceEpoch(
            json['birthday'].seconds * 1000000),
        location: json['location'],
        receivedFriendRequest: json['receivedFriendRequest'],
        sentFriendRequest: json['sentFriendRequest'],
        friends: json['friends'],
        todo: json['todo'],
        sharedTodo: json['sharedTodo'],
        bio: json['bio']);
    //print(user.friends);
    return user;
  }
}
