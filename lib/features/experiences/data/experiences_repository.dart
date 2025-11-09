import '../../../core/network/dio_client.dart';
import 'experience.dart';

class ExperiencesRepository {
  ExperiencesRepository(this._client);
  final DioClient _client;

  Future<List<Experience>> fetchExperiences() async {
    final rows = await _client.getExperiences();
    return rows
        .map((e) => Experience.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }
}
