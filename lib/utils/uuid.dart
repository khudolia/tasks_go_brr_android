class UUID {

  static int parseStringUUIDtoInt(String uuid) {
    return int.parse(uuid.replaceAll(RegExp('[^0-9]'), '').substring(0, 9));
  }
}