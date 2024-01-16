import 'package:flutterproiecttest1/AppConstants/AndroidEmulatorServerIpAddress.dart';

// Stoc.API Endpoints

const String getAllCarsAndroidEmulatorApiEndpoint =
    "http://$androidEmulatorServerIpAddress:5017/api/DateStoc";

// ConturiClienti.API Endpoints

const String getFavCarsAndroidEmulatorApiEndpoint =
    "http://$androidEmulatorServerIpAddress:5199/api/DateClienti/GetFavCarsForCustomer";

const String getRentedCarsAndroidEmulatorApiEndpoint =
    "http://$androidEmulatorServerIpAddress:5199/api/DateClienti/GetRentedCarsForCustomer";

const String getBoughtCarsAndroidEmulatorApiEndpoint =
    "http://$androidEmulatorServerIpAddress:5199/api/DateClienti/GetBoughtCarsForCustomer";

const String getBookedCarsAndroidEmulatorApiEndpoint =
    "http://$androidEmulatorServerIpAddress:5199/api/DateClienti/GetBookedCarsForCustomer";

const String getCustomerDataAndroidEmulatorApiEndpoint =
    "http://$androidEmulatorServerIpAddress:5199/api/DateClienti/PreluareDateClient";

const String verifyIfVehicleIsFavouriteAndroidEmulatorApiEndpoint =
    "http://$androidEmulatorServerIpAddress:5199/api/DateClienti/VerifiyIfVehicleIsMarkedAsFavourite";

const String verifyIfVehicleIsBookedAndroidEmulatorApiEndpoint =
    "http://$androidEmulatorServerIpAddress:5199/api/DateClienti/VerifiyIfVehicleIsBooked";

const String markVehicleAsFavouriteAndroidEmulatorApiEndpoint =
    "http://$androidEmulatorServerIpAddress:5199/api/DateClienti/MarkVehicleAsFavourite";

const String unmarkVehicleFromFavouriteListAndroidEmulatorApiEndpoint =
    "http://$androidEmulatorServerIpAddress:5199/api/DateClienti/UnmarkFavouriteVehicle";

const String bookVehicleAndroidEmulatorApiEndpoint =
    "http://$androidEmulatorServerIpAddress:5199/api/DateClienti/BookVehicle";

const String unbookVehicleAndroidEmulatorApiEndpoint =
    "http://$androidEmulatorServerIpAddress:5199/api/DateClienti/UnBookVehicle";

const String loginCustomerAndroidEmulatorApiEndpoint =
    "http://$androidEmulatorServerIpAddress:5199/api/LoginCustomer/VerificareDateAutentificareClient";

const String registerCustomerAndroidEmulatorApiEndpoint =
    "http://$androidEmulatorServerIpAddress:5199/api/RegisterConturiClienti";

const String updateCustomerProfileData =
    "http://$androidEmulatorServerIpAddress:5199/api/DateClienti/UpdateDateProfilClienti";

// Furnizori.API Endpoints

const String getDealersAndroidEmulatorApiEndpoint =
    "http://$androidEmulatorServerIpAddress:5294/api/DateCompletePartener/PreluareDatePartener";
