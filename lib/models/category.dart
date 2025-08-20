class Category {
  final String slug;
  final String name;
  

  Category({required this.slug, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(slug: json['slug'] ?? '', name: json['name'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'slug': slug, 'name': name};
  }

  @override
  String toString() {
    return 'Category(slug: $slug, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Category && other.slug == slug;
  }

  @override
  int get hashCode => slug.hashCode;
}
