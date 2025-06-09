class CategoryApiResponse {
  final String status;
  final String message;
  final List<String> categories;

  CategoryApiResponse({
    required this.status,
    required this.message,
    required this.categories,
  });

  factory CategoryApiResponse.fromJson(Map<String, dynamic> json) {
    // Ensure 'categories' key exists and is a List before mapping
    var categoriesList =
        json['categories']
            as List<dynamic>?; // Make nullable to handle missing key gracefully

    List<String> parsedCategories = [];
    if (categoriesList != null) {
      parsedCategories =
          categoriesList
              .map((categoryJson) => categoryJson.toString())
              .toList();
    }

    return CategoryApiResponse(
      status: json['status'] as String,
      message: json['message'] as String,
      categories: parsedCategories,
    );
  }
}
