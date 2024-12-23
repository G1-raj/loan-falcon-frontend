String formatPhoneNumber(String phoneNumber) {
  if (phoneNumber.startsWith('+91')) {
    return phoneNumber;
  } else {
    return '+91$phoneNumber';
  }
}