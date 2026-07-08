/// A local business that advertises its products in the app.
///
/// v1 listings are admin-managed; the data model is shaped so a future
/// self-serve submission flow (with a moderation/approval step) can reuse it
/// without a rewrite.
class Contributor {
  const Contributor({
    required this.id,
    required this.businessName,
    required this.category,
    required this.description,
    required this.contactPhone,
    this.productImageUrls = const [],
  });

  final String id;
  final String businessName;
  final String category;
  final String description;
  final String contactPhone;
  final List<String> productImageUrls;
}
