import 'package:shared_preferences/shared_preferences.dart';

class AchievementsService {
  static const _racesRunKey = 'races_run';
  static const _pixelsTravelledKey = 'pixels_travelled';

  AchievementsService._privateConstructor();
  static final AchievementsService instance =
      AchievementsService._privateConstructor();

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<int> getRacesRun() async {
    return _prefs.getInt(_racesRunKey) ?? 0;
  }

  Future<void> incrementRacesRun() async {
    final currentRaces = await getRacesRun();
    await _prefs.setInt(_racesRunKey, currentRaces + 1);
  }

  Future<double> getPixelsTravelled() async {
    return _prefs.getDouble(_pixelsTravelledKey) ?? 0.0;
  }

  Future<void> addPixelsTravelled(double pixels) async {
    final currentPixels = await getPixelsTravelled();
    await _prefs.setDouble(_pixelsTravelledKey, currentPixels + pixels);
  }
}
