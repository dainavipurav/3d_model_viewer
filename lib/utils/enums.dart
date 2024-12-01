enum FilePickerError {
  fileNotFound,
  pathNotFound,
  unSupportedFile;

  String get displayName {
    return switch (this) {
      fileNotFound => 'No file selected',
      pathNotFound => 'No file path exist',
      unSupportedFile => 'Unsupported file '
    };
  }
}
