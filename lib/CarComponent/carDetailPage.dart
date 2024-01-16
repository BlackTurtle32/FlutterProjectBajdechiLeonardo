import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutterproiecttest1/AppConstants/AndroidEmulatorApiEndpoints.dart';
import 'package:flutterproiecttest1/CarComponent/constants.dart';
import 'package:flutterproiecttest1/CarComponent/data.dart';
import 'package:flutterproiecttest1/FirebaseAPI/firebaseApi.dart';
import 'package:flutterproiecttest1/LoginComponent/login.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

// Add to favourites code
class FavoriteProvider extends ChangeNotifier {
  final Map<String, bool> _favoriteStatusMap = {};

  bool isFavorite(String vehicleId) {
    return _favoriteStatusMap[vehicleId] ?? false;
  }

  Future<void> checkAndUpdateFavoriteStatus(
      String clientId, String vehicleId) async {
    final isCurrentlyFavorite =
        await checkIfVehicleIsFavorite(clientId, vehicleId);
    toggleFavorite(vehicleId, isCurrentlyFavorite);
  }

  void toggleFavorite(String vehicleId, bool isCurrentlyFavorite) {
    _favoriteStatusMap[vehicleId] = isCurrentlyFavorite;
    notifyListeners();
  }

  Future<bool> checkIfVehicleIsFavorite(
      String clientId, String vehicleId) async {
    try {
      final response = await http.get(Uri.parse(
          "$verifyIfVehicleIsFavouriteAndroidEmulatorApiEndpoint/$clientId/$vehicleId"));

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      print("Error: $error");
      return false;
    }
  }
}

//Book vehicle
class BookedProvider extends ChangeNotifier {
  final Map<String, bool> _bookedStatusMap = {};

  bool isBooked(String vehicleId) {
    return _bookedStatusMap[vehicleId] ?? false;
  }

  Future<void> checkAndUpdateVehicleBookedStatus(
      String clientId, String vehicleId) async {
    final isCurrentlyBooked = await checkIfVehicleIsBooked(clientId, vehicleId);
    toogleBooked(vehicleId, isCurrentlyBooked);
  }

  void toogleBooked(String vehicleId, bool isCurrentlyBooked) {
    _bookedStatusMap[vehicleId] = isCurrentlyBooked;
    notifyListeners();
  }

  Future<bool> checkIfVehicleIsBooked(String clientId, String vehicleId) async {
    try {
      final response = await http.get(Uri.parse(
          "$verifyIfVehicleIsBookedAndroidEmulatorApiEndpoint/$clientId/$vehicleId"));

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      print("Error: $error");
      return false;
    }
  }
}

class BookCar extends StatefulWidget {
  final Car car;

  BookCar({super.key, required this.car});

  @override
  _BookCarState createState() => _BookCarState();
}

class _BookCarState extends State<BookCar> {
  int _currentImage = 0;
  bool isFavourite = false;
  bool isBooked = false;

  List<Widget> buildPageIndicator() {
    List<Widget> list = [];
    for (var i = 0; i < widget.car.images.length; i++) {
      list.add(buildIndicator(i == _currentImage));
    }
    return list;
  }

  // Fav car
  Future<void> toggleFavouriteStatus(BuildContext context) async {
    final CustomerIdProvider customerIdProvider =
        Provider.of<CustomerIdProvider>(context, listen: false);

    final FavoriteProvider favoriteProvider =
        Provider.of<FavoriteProvider>(context, listen: false);

    final String? clientId = customerIdProvider.customerId;

    if (clientId == null) {
      print("Customer ID is not available.");
      return;
    }

    final String vehicleId = widget.car.id;

    // ignore: unnecessary_null_comparison
    if (clientId != null) {
      await favoriteProvider.checkAndUpdateFavoriteStatus(clientId, vehicleId);
    }

    final bool isCurrentlyFavorite = favoriteProvider.isFavorite(vehicleId);

    final String apiUrl =
        "$markVehicleAsFavouriteAndroidEmulatorApiEndpoint/$clientId/$vehicleId";

    final String deleteApiUrl =
        "$unmarkVehicleFromFavouriteListAndroidEmulatorApiEndpoint/$clientId/$vehicleId";

    if (isCurrentlyFavorite) {
      try {
        final unmarkResponse = await http.delete(Uri.parse(deleteApiUrl));

        if (unmarkResponse.statusCode == 200) {
          print("Vehicle unmarked");
          setState(() {
            favoriteProvider.toggleFavorite(vehicleId, false);
          });
        } else {
          print("Error unmarking vehicle: ${unmarkResponse.statusCode}");
        }
      } catch (error) {
        print("Error: $error");
      }
    } else {
      try {
        final response = await http.put(Uri.parse(apiUrl));

        if (response.statusCode == 200) {
          setState(() {
            favoriteProvider.toggleFavorite(vehicleId, true);
          });
          print("Vehicle marked as favorite successfully.");
        } else {
          print("Error marking vehicle as favorite: ${response.statusCode}");
        }
      } catch (error) {
        print("Error: $error");
      }
    }
  }

  //Book car
  Future<void> toggleBookedStatus(BuildContext context) async {
    final CustomerIdProvider customerIdProvider =
        Provider.of<CustomerIdProvider>(context, listen: false);

    final BookedProvider bookedProvider =
        Provider.of<BookedProvider>(context, listen: false);

    final String? clientId = customerIdProvider.customerId;

    FirebaseApi firebaseApi = FirebaseApi();

    if (clientId == null) {
      print("Customer ID is not available.");
      return;
    }

    final String vehicleId = widget.car.id;

    // ignore: unnecessary_null_comparison
    if (clientId != null) {
      await bookedProvider.checkAndUpdateVehicleBookedStatus(
          clientId, vehicleId);
    }

    final bool isCurrentlyBooked = bookedProvider.isBooked(vehicleId);

    final String apiUrl =
        "$bookVehicleAndroidEmulatorApiEndpoint/$clientId/$vehicleId";

    final String deleteApiUrl =
        "$unbookVehicleAndroidEmulatorApiEndpoint/$clientId/$vehicleId";

    if (isCurrentlyBooked) {
      try {
        final unmarkResponse = await http.delete(Uri.parse(deleteApiUrl));

        if (unmarkResponse.statusCode == 200) {
          print("Vehicle unbooked");
          setState(() {
            bookedProvider.toogleBooked(vehicleId, false);
          });

          // Display local notification when unbooking
          firebaseApi.displayLocalNotification(RemoteMessage(
            notification: RemoteNotification(
              title: 'Vehicle Unbooked',
              body:
                  'You have unbooked a "${widget.car.brand} ${widget.car.model}".',
            ),
          ));
        } else {
          print("Error unbooking vehicle: ${unmarkResponse.statusCode}");
        }
      } catch (error) {
        print("Error: $error");
      }
    } else {
      try {
        final response = await http.put(Uri.parse(apiUrl));

        if (response.statusCode == 200) {
          setState(() {
            bookedProvider.toogleBooked(vehicleId, true);
          });

          // Display local notification when booking
          firebaseApi.displayLocalNotification(RemoteMessage(
            notification: RemoteNotification(
              title: 'Vehicle Booked',
              body:
                  'You have booked a "${widget.car.brand} ${widget.car.model}". Thank you!',
            ),
          ));
        } else {
          print("Error marking vehicle as favorite: ${response.statusCode}");
        }
      } catch (error) {
        print("Error: $error");
      }
    }
  }

  Widget buildIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 6),
      height: 8,
      width: isActive ? 20 : 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.black : Colors.grey[400],
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                  width: 45,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                    border: Border.all(
                                      color: Colors.grey[300]!,
                                      width: 1,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.keyboard_arrow_left,
                                    color: Colors.black,
                                    size: 28,
                                  )),
                            ),
                            Row(
                              children: [
                                Consumer<FavoriteProvider>(
                                    builder: (context, favoriteProvider, _) =>
                                        GestureDetector(
                                            onTap: () {
                                              toggleFavouriteStatus(context);
                                            },
                                            child: Container(
                                                width: 45,
                                                height: 45,
                                                decoration: BoxDecoration(
                                                  color: favoriteProvider
                                                          .isFavorite(
                                                              widget.car.id)
                                                      ? Colors.yellow
                                                      : kPrimaryColorShadow,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(15),
                                                  ),
                                                ),
                                                child: Icon(
                                                  Icons.bookmark_border,
                                                  color: favoriteProvider
                                                          .isFavorite(
                                                              widget.car.id)
                                                      ? Colors.black
                                                      : Colors.yellow,
                                                  size: 22,
                                                )))),
                                const SizedBox(
                                  width: 16,
                                ),
                                Container(
                                    width: 45,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                      border: Border.all(
                                        color: Colors.grey[300]!,
                                        width: 1,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.share,
                                      color: Colors.black,
                                      size: 22,
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          widget.car.model,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          widget.car.brand,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Expanded(
                        child: Container(
                          child: PageView(
                            physics: const BouncingScrollPhysics(),
                            onPageChanged: (int page) {
                              setState(() {
                                _currentImage = page;
                              });
                            },
                            children: widget.car.images.map((path) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Hero(
                                  tag: widget.car.model,
                                  child: Image.asset(
                                    path,
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      widget.car.images.length > 1
                          ? Container(
                              margin: const EdgeInsets.symmetric(vertical: 16),
                              height: 30,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: buildPageIndicator(),
                              ),
                            )
                          : Container(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buildPricePerPeriod(
                              "12",
                              widget.car.bookFor12Months,
                              true,
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            buildPricePerPeriod(
                              "6",
                              widget.car.bookFor6Months,
                              false,
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            buildPricePerPeriod(
                              "1",
                              widget.car.bookFor1Month,
                              false,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 16, left: 16, right: 16),
                      child: Text(
                        "SPECIFICATIONS",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
                    Container(
                      height: 80,
                      padding: const EdgeInsets.only(
                        top: 8,
                        left: 16,
                      ),
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        children: [
                          buildSpecificationCar("Color", widget.car.color),
                          buildSpecificationCar("Gearbox", widget.car.gearbox),
                          buildSpecificationCar("Seat", widget.car.seat),
                          buildSpecificationCar(
                              "Engine", widget.car.engineCapacity),
                          buildSpecificationCar("Power", widget.car.horsePower),
                          buildSpecificationCar(
                              "Fuel Type", widget.car.fuelType),
                          buildSpecificationCar(
                              "Number of Km.", widget.car.nrOfKm),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 90,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Full Price",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Row(
                  children: [
                    Text(
                      "EUR ${widget.car.price}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    const Text(
                      "TVA Included",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
                height: 50,
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                child: Consumer<BookedProvider>(
                  builder: (context, bookedProvider, _) => GestureDetector(
                    onTap: () {
                      toggleBookedStatus(context);
                    },
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          bookedProvider.isBooked(widget.car.id)
                              ? "Car booked"
                              : "Book this car",
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget buildPricePerPeriod(String months, String price, bool selected) {
    return Expanded(
      child: Container(
        height: 110,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? kPrimaryColor : Colors.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          ),
          border: Border.all(
            color: Colors.grey[300]!,
            width: selected ? 0 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$months Month",
              style: TextStyle(
                color: selected ? Colors.black : Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Container(),
            ),
            Text(
              price,
              style: TextStyle(
                color: selected ? Colors.black : Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "EUR",
              style: TextStyle(
                color: selected ? Colors.black : Colors.black,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSpecificationCar(String title, String data) {
    return Container(
      width: 130,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            data,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
