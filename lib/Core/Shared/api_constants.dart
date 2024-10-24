class ApiConstants {
  // Base API URL
  static String baseUrl = 'https://fit-pro-app.glitch.me';

  // Authentication
  static String apiRegister = "/auth/register";
  static String apiLogin = "/auth/login";
  static String apiToken = "/api/token";

  // Profile
  static String apiGetProfile = "/api/profile";
  static String apiEditProfile(String profileId) {
    return "/api/profile/$profileId";
  }

  // Exercises and Workout Categories
  static String apiExercise = "/api/exercises/";
  static String apiWorkoutCategories = "/api/categories";

  // Foods and Drinks
  static String apiFoods = "/api/foods";
  static String apiDrinks = "/api/drinks";
  static String gemini = "/api/gemini";
  static String apiFavorite(String dietItemId) {
    return "/api/favorites/$dietItemId";
  }

  // calender 
  static String apiCalender(String profileId) {
    return "/api/calendar/$profileId";
  }
}
