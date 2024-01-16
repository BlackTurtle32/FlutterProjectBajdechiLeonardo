import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterproiecttest1/AppConstants/AndroidEmulatorApiEndpoints.dart';
import 'package:flutterproiecttest1/CarComponent/constants.dart';
import 'package:flutterproiecttest1/CarComponent/data.dart';
import 'package:flutterproiecttest1/MyHertzComponents/bookedCarsPage.dart';
import 'package:flutterproiecttest1/MyHertzComponents/myPurchasedCarsPage.dart';
import 'package:flutterproiecttest1/MyHertzComponents/rentedCarsPage.dart';
import 'package:flutterproiecttest1/LoginComponent/login.dart';
import 'package:flutterproiecttest1/MyHertzComponents/favouriteCars.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class MyProfilePage extends StatefulWidget {
  MyProfilePage({super.key});

  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

DateTime selectedDate = DateTime.now();
late String profileImagePath;
final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

Future<void> _selectDate(
  BuildContext context,
  Function(DateTime) updateSelectedDate,
) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: selectedDate,
    firstDate: DateTime(2000),
    lastDate: DateTime(2101),
  );
  if (picked != null && picked != selectedDate) {
    updateSelectedDate(picked);
  }
}

Future<CustomerData> fetchCustomerData(BuildContext context) async {
  final CustomerIdProvider customerIdProvider =
      Provider.of<CustomerIdProvider>(context, listen: false);

  String? clientId = customerIdProvider.customerId;
  CustomerData customerData = await getCustomerData(clientId!);

  return customerData;
}

List<String> cities = [];

Future<void> fetchCities(Function setStateCallback) async {
  String jsonString = await rootBundle.loadString('assets/images/cities.json');
  Map<String, dynamic> jsonMap = json.decode(jsonString);
  Cities citiesData = Cities.mapCitiesDataFromJson(jsonMap);

  if (cities.isEmpty) {
    setStateCallback(() {
      cities = citiesData.cities;
    });
  }
}

class _MyProfilePageState extends State<MyProfilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  String? selectedCity;
  DateTime selectedDate = DateTime.now();

  void fetchInitialData() {
    fetchCustomerData(context).then((customerData) {
      nameController.text = customerData.nume;
      surnameController.text = customerData.prenume;
      emailController.text = customerData.email;
      countryController.text = customerData.tara;
      cityController.text = customerData.oras;
      final DateFormat dateFormat = DateFormat('yyyy-mm-dd');
      setState(() {
        selectedDate = dateFormat.parse(customerData.dataNasterii);
        selectedCity = customerData.oras;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    fetchCities(setState);
    fetchInitialData();
  }

  Future<void> updateUserDetails(
      BuildContext context,
      String updateName,
      String updateSurname,
      String updateEmail,
      String updateCountry,
      String updateCity,
      String updateDateOfBirth) async {
    final CustomerIdProvider customerIdProvider =
        Provider.of<CustomerIdProvider>(context, listen: false);

    String? clientId = customerIdProvider.customerId;

    final updateAPIEndpoint = "$updateCustomerProfileData/$clientId";

    final updateRequestData = {
      "nume": updateName,
      "prenume": updateSurname,
      "email": updateEmail,
      "dataNasterii": updateDateOfBirth,
      "tara": updateCountry,
      "oras": updateCity,
    };

    final response = await http.put(Uri.parse(updateAPIEndpoint),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(updateRequestData));

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Profile details updated successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 7,
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          textColor: Colors.white,
          fontSize: 16.0);

      fetchInitialData();
    }
  }

  //UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  colors: [Colors.yellow, Colors.yellow.shade400])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 80,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FadeInUp(
                      duration: const Duration(milliseconds: 1000),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "My Hertz",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 40,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    FadeInUp(
                        duration: const Duration(milliseconds: 1300),
                        child: Text(
                          "${nameController.text} ${surnameController.text}",
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 28,
                              fontStyle: FontStyle.italic),
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60)),
                    border: Border.all(color: Colors.black, width: 2)),
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 40,
                      ),
                      FadeInUp(
                          duration: const Duration(milliseconds: 1400),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Color.fromRGBO(225, 95, 27, .3),
                                      blurRadius: 20,
                                      offset: Offset(0, 10))
                                ]),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey.shade200))),
                                  child: TextField(
                                    controller: nameController,
                                    decoration: const InputDecoration(
                                        hintText: "Nume",
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        border: InputBorder.none),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey.shade200))),
                                  child: TextField(
                                    obscureText: false,
                                    controller: surnameController,
                                    decoration: const InputDecoration(
                                        hintText: "Prenume",
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        border: InputBorder.none),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey.shade200))),
                                  child: TextField(
                                    controller: emailController,
                                    decoration: const InputDecoration(
                                        hintText: "Email",
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        border: InputBorder.none),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey.shade200))),
                                  child: TextField(
                                    controller: countryController,
                                    decoration: const InputDecoration(
                                        hintText: "Tara",
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        border: InputBorder.none),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey.shade200,
                                      ),
                                    ),
                                  ),
                                  child: DropdownButtonFormField<String>(
                                    value: selectedCity,
                                    decoration: const InputDecoration(
                                      hintText: "Judet",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                    ),
                                    items: cities.map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (String? value) {
                                      setState(() {
                                        selectedCity = value;
                                      });
                                    },
                                    // You can set an initial value if needed
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    _selectDate(context, (DateTime picked) {
                                      setState(() {
                                        selectedDate = picked;
                                      });
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: kPrimaryColor,
                                  ),
                                  child: Text(
                                      'Day of birth: ${DateFormat('dd-mm-yyyy').format(selectedDate)}',
                                      style: const TextStyle(
                                        color: Colors.black,
                                      )),
                                ),
                              ],
                            ),
                          )),
                      const SizedBox(
                        height: 40,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      FadeInUp(
                          duration: const Duration(milliseconds: 1600),
                          child: MaterialButton(
                            onPressed: () => updateUserDetails(
                                context,
                                nameController.text,
                                surnameController.text,
                                emailController.text,
                                countryController.text,
                                selectedCity ?? "",
                                selectedDate.toString()),
                            height: 50,
                            // margin: EdgeInsets.symmetric(horizontal: 50),
                            color: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            // decoration: BoxDecoration(
                            // ),
                            child: const Center(
                              child: Text(
                                "Update my profile details",
                                style: TextStyle(
                                    color: Colors.yellow,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )),
                      const SizedBox(
                        height: 50,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: FadeInUp(
                                duration: const Duration(milliseconds: 1800),
                                child: MaterialButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                FavouriteCars()));
                                  },
                                  height: 50,
                                  color: kPrimaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "Favourite vehicles",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )),
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            child: FadeInUp(
                                duration: const Duration(milliseconds: 1900),
                                child: MaterialButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                BookedCarsPage()));
                                  },
                                  height: 50,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  color: kPrimaryColor,
                                  child: const Center(
                                    child: Text(
                                      "Booked vehicles",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: FadeInUp(
                                duration: const Duration(milliseconds: 1800),
                                child: MaterialButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RentedCars()));
                                  },
                                  height: 50,
                                  color: kPrimaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "Rented vehicles",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )),
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            child: FadeInUp(
                                duration: const Duration(milliseconds: 1900),
                                child: MaterialButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PurchasedCars()));
                                  },
                                  height: 50,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  color: kPrimaryColor,
                                  child: const Center(
                                    child: Text(
                                      "My purchases",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
