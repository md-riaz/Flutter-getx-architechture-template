enum AppFeature {
  sms,
  fax,
  voice,
  todos,
}

class User {
  final String id;
  final String name;
  final String email;
  final Set<AppFeature> enabledFeatures;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.enabledFeatures,
  });

  bool canAccess(AppFeature feature) => enabledFeatures.contains(feature);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          email == other.email &&
          enabledFeatures.length == other.enabledFeatures.length &&
          enabledFeatures.containsAll(other.enabledFeatures);

  @override
  int get hashCode => Object.hash(id, name, email, enabledFeatures);
}
