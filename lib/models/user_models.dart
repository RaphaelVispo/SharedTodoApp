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
  String? birthday;
  List? receivedFriendRequest;
  List? sentFriendRequest;
  List? friends;
  List? location;
  List? todo;
  List? sharedTodo;

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
      this.sharedTodo});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    print(json);
    UserModel user = UserModel(
        id: json['id'],
        email: json['email'],
        firstName: json['firstName'],
        lastName: json['lastName'],
//        birthday: json['birthday'],
//        location: json['location'],
        receivedFriendRequest: json['receivedFriendRequest'],
        sentFriendRequest: json['sentFriendRequest'],
        friends: json['friends'],
        todo: json['todo'],
        sharedTodo: json['sharedTodo']);
    print(user.friends);
    return user;
  }
}
