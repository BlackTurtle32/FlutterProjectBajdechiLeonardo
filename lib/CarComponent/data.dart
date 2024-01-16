import 'package:flutter/material.dart';
import 'package:flutterproiecttest1/AppConstants/AndroidEmulatorApiEndpoints.dart';
import 'package:flutterproiecttest1/MyHertzComponents/userProfilePage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NavigationItem {
  IconData iconData;
  VoidCallback? onTap;
  NavigationItem(this.iconData, {this.onTap});
}

List<NavigationItem> getNavigationItemList(BuildContext context) {
  return <NavigationItem>[
    NavigationItem(Icons.home),
    NavigationItem(Icons.person, onTap: () => _navigateToUserProfile(context)),
  ];
}

void _navigateToUserProfile(BuildContext context) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => MyProfilePage()));
}

class Car {
  String id;
  String brand;
  String model;
  String price;
  String condition;
  String color;
  String fuelType;
  String gearbox;
  String seat;
  String engineCapacity;
  String horsePower;
  String nrOfKm;
  String bookFor1Month;
  String bookFor6Months;
  String bookFor12Months;
  List<String> images;

  Car(
      this.id,
      this.brand,
      this.model,
      this.price,
      this.condition,
      this.color,
      this.fuelType,
      this.gearbox,
      this.seat,
      this.engineCapacity,
      this.horsePower,
      this.nrOfKm,
      this.bookFor1Month,
      this.bookFor6Months,
      this.bookFor12Months,
      this.images);

  factory Car.mapCarDataFromJson(Map<String, dynamic> json) {
    return Car(
      json['id'] as String,
      json['marca'] as String,
      json['model'] as String,
      json['pret'] != null ? json['pret'].toString() : '0.0',
      json['tipInchiriere'] as String,
      json['culoare'] as String,
      json['combustibil'] as String,
      json['cutieViteze'] as String,
      json['nrDeLocuri'] as String,
      json['capCilindrica'] as String,
      json['putere'] as String,
      json['nrDeKm'] as String,
      json['pretInchiriere1Luna'] as String,
      json['pretInchiriere6Luni'] as String,
      json['pretInchiriere12Luni'] as String,
      List<String>.from(json['images'] as List),
    );
  }
}

Future<List<Car>> getCarList() async {
  final response =
      await http.get(Uri.parse(getAllCarsAndroidEmulatorApiEndpoint));

  if (response.statusCode == 200) {
    final List<dynamic> jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => Car.mapCarDataFromJson(data)).toList();
  } else {
    throw Exception('Failed to load data from the API');
  }
}

Future<List<Car>> getFavCarList(String clientId) async {
  final response = await http
      .get(Uri.parse("$getFavCarsAndroidEmulatorApiEndpoint/$clientId"));

  if (response.statusCode == 200) {
    final List<dynamic> jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => Car.mapCarDataFromJson(data)).toList();
  } else {
    throw Exception('Failed to load data from the API');
  }
}

Future<List<Car>> getRentedCarList(String clientId) async {
  final response = await http
      .get(Uri.parse("$getRentedCarsAndroidEmulatorApiEndpoint/$clientId"));

  if (response.statusCode == 200) {
    final List<dynamic> jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => Car.mapCarDataFromJson(data)).toList();
  } else {
    throw Exception('Failed to load data from the API');
  }
}

Future<List<Car>> getBoughtCarList(String clientId) async {
  final response = await http
      .get(Uri.parse("$getBoughtCarsAndroidEmulatorApiEndpoint/$clientId"));

  if (response.statusCode == 200) {
    final List<dynamic> jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => Car.mapCarDataFromJson(data)).toList();
  } else {
    throw Exception('Failed to load data from the API');
  }
}

Future<List<Car>> getBookedCarList(String clientId) async {
  final response = await http
      .get(Uri.parse("$getBookedCarsAndroidEmulatorApiEndpoint/$clientId"));

  if (response.statusCode == 200) {
    final List<dynamic> jsonRespons = json.decode(response.body);
    return jsonRespons.map((data) => Car.mapCarDataFromJson(data)).toList();
  } else {
    throw Exception('Failed to load data from the API');
  }
}

class CustomerData {
  String id;
  String nume;
  String prenume;
  String email;
  String dataNasterii;
  String joinedSinceDate;
  String tara;
  String oras;
  List<String> favVehicles;
  List<String> bookedVehicles;
  List<String> rentedVehiclesHistory;
  List<String> boughtVehicleHistory;

  CustomerData(
      this.id,
      this.nume,
      this.prenume,
      this.email,
      this.dataNasterii,
      this.joinedSinceDate,
      this.tara,
      this.oras,
      this.favVehicles,
      this.bookedVehicles,
      this.rentedVehiclesHistory,
      this.boughtVehicleHistory);

  factory CustomerData.mapCustomerDataFromJson(Map<String, dynamic> json) {
    return CustomerData(
        json['id'] as String,
        json['nume'] as String,
        json['prenume'] as String,
        json['email'] as String,
        json['dataNasterii'] as String,
        json['joinedSinceDate'] as String,
        json['tara'] as String,
        json['oras'] as String,
        List<String>.from(json['favVehicles'] as List),
        List<String>.from(json['bookedVehicles'] as List),
        List<String>.from(json['rentedVehiclesHistory'] as List),
        List<String>.from(json['boughtVehicleHistory'] as List));
  }
}

Future<CustomerData> getCustomerData(String clientId) async {
  final response = await http
      .get(Uri.parse("$getCustomerDataAndroidEmulatorApiEndpoint/$clientId"));

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonData = json.decode(response.body);
    return CustomerData.mapCustomerDataFromJson(jsonData);
  } else {
    throw Exception('Failed to load data from the API');
  }
}

class Dealer {
  String name;
  String offers;
  String image;
  String website;

  Dealer(this.name, this.offers, this.image, this.website);

  factory Dealer.mapDealerDataFromJson(Map<String, dynamic> json) {
    return Dealer(json["numePartener"], json["numarOferte"],
        json["imagesParteneri"], json["website"]);
  }
}

Future<List<Dealer>> getDealerList() async {
  final dealerResponse =
      await http.get(Uri.parse(getDealersAndroidEmulatorApiEndpoint));

  if (dealerResponse.statusCode == 200) {
    final List<dynamic> jsonResponse = jsonDecode(dealerResponse.body);
    return jsonResponse
        .map((data) => Dealer.mapDealerDataFromJson(data))
        .toList();
  } else {
    throw Exception('Failed to load data from the API');
  }
}

class Filter {
  String name;

  Filter(this.name);
}

List<Filter> getFilterList() {
  return <Filter>[
    Filter("Highest Price"), //0
    Filter("Lowest Price"), //1
    Filter("A - Z"), //2
    Filter("Number of seats"), //3
    Filter("Engine Capacity"), //4
    Filter("Number of Km."), //5
  ];
}

class Cities {
  List<String> cities;

  Cities(this.cities);

  factory Cities.mapCitiesDataFromJson(Map<String, dynamic> json) {
    return Cities(List<String>.from(json['cities'] as List));
  }
}
