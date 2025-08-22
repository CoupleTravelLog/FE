class TravelLog {
  final String id;
  final String title;
  final DateTime date;
  final String description;
  final List<String> imageUrls;

  TravelLog({
    required this.id,
    required this.title,
    required this.date,
    required this.description,
    required this.imageUrls,
  });
}