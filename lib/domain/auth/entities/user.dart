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
}
