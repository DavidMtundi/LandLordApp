String? geterror(String? controller) {
  final text = controller!.toString();
  if (text.isEmpty) {
    return "Field cannot be empty";
  }

  return null;
}
