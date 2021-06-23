class Constants {
  static const EMPTY_STRING = "";
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
}

class Models {
  static const int TASK_ID = 0;
  static const int CHECK_ITEM_ID = 1;
  static const int DAY_ID = 2;
  static const int TASK_REGULAR_ID = 3;
}

class Status {
  static const bool COMPLETED = true;
  static const bool INCOMPLETE = false;
}

class Repeat {
  static const int DAILY = 0;
  static const int WEEKLY = 1;
  static const int MONTHLY = 2;
  static const int YEARLY = 3;
  static const int WEEKDAYS = 4;
  static const int WEEKENDS = 5;
  static const int CUSTOM = 6;
}