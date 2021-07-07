class Constants {
  static const EMPTY_STRING = "";
  static const DEFAULT_GOAL_OF_TASKS_IN_DAY = 5;
  static const GOAL_TASKS_DAY_MAX = 100;
  static const GOAL_TASKS_DAY_MIN = 1;

}

class Profile {
  static const String UUID_KEY = 'uuid_key';
}

class CalendarCards {
  static const EXTEND_AFTER_ON_MONTHS = 2;
  static const EXTEND_BEFORE_ON_WEEKS = 1;

  static const EXTEND_AFTER_ON_YEARS = 5;
}

class Repo {
  static const String TASK = 'task_box';
  static const String DAY = 'day_box';
  static const String TASK_REGULAR = 'task_regular_box';
  static const String STATISTICS = 'statistics_box';
  static const String SETTINGS = 'settings_box';
}

class Models {
  static const int TASK_ID = 0;
  static const int CHECK_ITEM_ID = 1;
  static const int DAY_ID = 2;
  static const int TASK_REGULAR_ID = 3;
  static const int STATISTICS_ID = 4;
  static const int DAY_STATS_ID = 5;
  static const int SETTINGS = 6;
}

class Status {
  static const bool COMPLETED = true;
  static const bool INCOMPLETE = false;
}

class Repeat {
  static const int DAILY = 0;
  static const int WEEKLY = 1;
  static const int MONTHLY = 2;
  static const int ANNUALLY = 3;
  static const int WEEKDAYS = 4;
  static const int WEEKENDS = 5;
  static const int CUSTOM = 6;
}

class Themes {
  static const int LIGHT = 0;
  static const int DARK = 1;
  static const int DEVICE = 2;
}

class NotificationsLayout {
  static const int NONE = 0;
  static const int LIGHT = 1;
  static const int MEDIUM = 2;
  static const int HARD = 3;
  static const int DOOM = 4;
}

class LocalesSupported {
  static const String en_US = "en_US";
  static const String ru_RU = "ru_RU";
  static const String uk_UA = "uk_UA";
  static const String DEVICE = "device";
}

class CollectionName {
  static const String DEV_INFO = "dev_info";
  static const String USER_INFO = "user_info";
  static const String DEV_SETTINGS = "dev_settings";
}

class DocumentName {
  static const String MAIN_DEV = "main_dev";
  static const String SETTINGS = "settings";
}

class DevInfoFields {
  static const String EMAIL = "email";
  static const String NAME = "name";
  static const String PHOTO_PATH = "photo_path";
  static const String SOCIAL_NETWORKS = "social_networks";
}

class UserInfoFields {
  static const String EMAIL = "email";
  static const String NAME = "name";
  static const String PHOTO_URL = "photo_path";
  static const String ID = "social_networks";
}

class DevSettingsFields {
  static const String EMPTY_PHOTO_URL = "empty_photo_url";
}