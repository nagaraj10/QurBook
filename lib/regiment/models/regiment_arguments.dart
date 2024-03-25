class RegimentArguments {
  String? eventId;
  /// Whether this RegimentArguments was created from Settings.
  bool? isFromSettings;

  RegimentArguments({
    this.eventId,
    /// Default it's false
    this.isFromSettings = false,
  });
}
