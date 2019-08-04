part of 'home.dart';

Home HomeFromJson(Map<String, dynamic> json) {
  return Home(
    json['page'] != null ? json['page'] as int : 0,
    json['per_page'] != null ? json['per_page'] as int : 0,
    json['total'] != null ? json['total'] as int : 0,
    json['total_pages'] != null ? json['total_pages'] as int : 0,
    (json['data'] as List)
        ?.map(
            (e) => e == null ? null : User.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}
