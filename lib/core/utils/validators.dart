class Validators {
  // =========================
  // Full Name
  // =========================
  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter your full name";
    }

    if (value.trim().length < 3) {
      return "Name must be at least 3 characters";
    }

    return null;
  }

  // =========================
  // Email
  // =========================
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter your email";
    }

    if (!RegExp(
      r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(value.trim())) {
      return "Please enter a valid email";
    }

    return null;
  }

  // =========================
  // Password
  // =========================
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your password";
    }

    if (value.length < 8) {
      return "Password must be at least 8 characters";
    }

    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return "Password must contain an uppercase letter";
    }

    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return "Password must contain a lowercase letter";
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return "Password must contain a number";
    }

    return null;
  }

  // =========================
  // Confirm Password
  // =========================
  static String? confirmPassword(
    String? value,
    String password,
  ) {
    if (value == null || value.isEmpty) {
      return "Please confirm your password";
    }

    if (value != password) {
      return "Passwords do not match";
    }

    return null;
  }

  // =========================
  // Required Field
  // =========================
  static String? requiredField(
    String? value, {
    String fieldName = "This field",
  }) {
    if (value == null || value.trim().isEmpty) {
      return "$fieldName is required";
    }

    return null;
  }

  // =========================
  // Phone Number
  // =========================
  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter your phone number";
    }

    if (!RegExp(r'^[0-9]{11}$').hasMatch(value)) {
      return "Please enter a valid phone number";
    }

    return null;
  }
}