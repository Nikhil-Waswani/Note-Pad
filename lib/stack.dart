import 'package:easyo/main.dart';

class Node {
  String data;
  int size;
  Node? next;

  Node(this.data, this.size);
}

class StackUndo {
  Node? top;

  void push(String data, int size) {
    Node newNode = Node(data, size);

    newNode.next = top;
    top = newNode;
  }

  String pop() {
    try {
      String? str = top!.data;
      int tempsize = top!.size;
      top = top!.next;
      previousString = controller.text.substring(0, tempsize) +
          str +
          controller.text.substring(tempsize);

      return str;
    } catch (e) {
      return "";
    }
  }

  String undo() {
    int tempsize = initialStack.top!.size;
    stackundo.push(initialStack.pop(), tempsize);
    previousString = controller.text.substring(0, stackundo.top!.size) +
        controller.text
            .substring(stackundo.top!.size + stackundo.top!.data.length);

    return previousString;
  }

  String redo() {
    int tempsize = stackundo.top!.size;
    initialStack.push(stackundo.pop(), tempsize);
    previousString = controller.text.substring(0, tempsize) +
        initialStack.top!.data +
        controller.text.substring(tempsize);

    return previousString;
  }
}
