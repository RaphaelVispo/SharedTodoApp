import 'package:flutter_test/flutter_test.dart';
import 'package:week7_networking_discussion/models/todo_model.dart';

void main() {
  group("Todo Model", () {
    test('Test Todo Model constructor', () {
      final modelInstance =
          Todo(userId: 1, completed: false, title: "Test Todo");
      expect(modelInstance.userId, 1);
      expect(modelInstance.completed, false);
      expect(modelInstance.title, "Test Todo");
    });

    test('Test Todo Model toJson method', () {
      final modelInstance =
          Todo(userId: 1, completed: false, title: "Test Todo");

      // do something
      final converted = modelInstance.toJson(modelInstance);

      //test the actual vs the expected
      expect(
          converted, {"userId": 1, "title": "Test Todo", "completed": false});
    });
  });
}
