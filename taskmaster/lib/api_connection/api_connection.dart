class API {
  static const hostConnect = "http://192.168.0.12/taskmaster_api";
  static const hostConnectUser = "$hostConnect/user";
  static const hostConnectTask = "$hostConnect/task";
  static const hostConnectSubscription = "$hostConnect/subscription";
  static const hostConnectCategory = "$hostConnect/category";

  //SIGNUP user
  static const signUp = "$hostConnectUser/signup.php";
  static const validateEmail = "$hostConnectUser/validate_email.php";
  static const login = "$hostConnectUser/login.php";

  //CREATE USER
  static const createUser = "$hostConnectUser/createUser.php";
  //DELETE USER
  static const deleteUser = "$hostConnectUser/deleteUser.php";

  //RETURN USERS BY OWNER ID
  static const returnUsersByOwnerId = "$hostConnectUser/returnUsersByOwnerId.php";

  //RETURN NUMBER OF USERS CREATED
  static const returnNumberOfUsersCreated = "$hostConnectUser/returnNumberOfUsersCreated.php";

  //UPDATE USERS SUBSCRIPTION
  static const updateUserSubscription = "$hostConnectUser/updateUserSubscription.php";

  //RETURN USERS CURRENT SUBSCRIPTION
  static const returnCurrentSubscription = "$hostConnectUser/returnCurrentSubscription.php";

  //CRUD TASK
  static const createTask = "$hostConnectTask/createTask.php";
  static const retrunCreatorTasks = "$hostConnectTask/returnCreatorTasks.php";
  static const returnAssignedTasks = "$hostConnectTask/returnAssignedTasks.php";
  static const updateTask = "$hostConnectTask/updateTask.php";
  static const deleteTask = "$hostConnectTask/deleteTask.php";

  //RETURN LATEST TASK
  static const returnLastTask = "$hostConnectTask/returnLastTask.php";

  //ASSIGN USER TO TASK
  static const assignUserToTask = "$hostConnectTask/assignUserToTask.php";

  //RU SUBSCRIPTION
  static const returnSubscription = "$hostConnectSubscription/returnSubscription.php";
  static const updateSubscription = "$hostConnectSubscription/updateSubscription.php";

  //R CATEGORIES
  static const returnCategories = "$hostConnectCategory/returnCategories.php";
  static const getCategoriesByTaskId = "$hostConnectCategory/getCategoriesByTaskId.php";
  //ASSIGN CATEGORY TO TASK
  static const assignCategoryToTask = "$hostConnectCategory/assignCategoryToTask.php";
  

 
}
