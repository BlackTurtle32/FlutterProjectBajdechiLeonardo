import 'package:flutterproiecttest1/CarComponent/car_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutterproiecttest1/CarComponent/constants.dart';
import 'package:flutterproiecttest1/CarComponent/data.dart';
import 'package:flutterproiecttest1/CarComponent/carDetailPage.dart';
import 'package:flutterproiecttest1/LoginComponent/login.dart';
import 'package:provider/provider.dart';

class RentedCars extends StatefulWidget {
  @override
  _RentedCars createState() => _RentedCars();
}

class _RentedCars extends State<RentedCars> {
  List<Filter> filters = getFilterList();
  late Filter selectedFilter;
  List<Car> cars = [];

  void fetchData(String clientId) async {
    List<Car> carList = await getRentedCarList(clientId);

    setState(() {
      cars = carList;
    });
  }

  void sortCars() {
    setState(() {
      if (selectedFilter == filters[0]) {
        cars.sort((a, b) => b.price.compareTo(a.price));
      } else if (selectedFilter == filters[1]) {
        cars.sort((a, b) => a.price.compareTo(b.price));
      } else if (selectedFilter == filters[2]) {
        cars.sort((a, b) => a.brand.compareTo(b.brand));
      } else if (selectedFilter == filters[3]) {
        cars.sort((a, b) => a.seat.compareTo(b.seat));
      } else if (selectedFilter == filters[4]) {
        cars.sort((a, b) => a.engineCapacity.compareTo(b.engineCapacity));
      } else if (selectedFilter == filters[5]) {
        cars.sort((a, b) => a.nrOfKm.compareTo(b.nrOfKm));
      }
    });
  }

  @override
  void initState() {
    super.initState();

    final CustomerIdProvider currentCustomer =
        Provider.of<CustomerIdProvider>(context, listen: false);
    String? clientId = currentCustomer.customerId;

    fetchData(clientId!);
    setState(() {
      selectedFilter = filters[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
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
              const SizedBox(
                height: 16,
              ),
              Text(
                "Rented cars (${cars.length})",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Expanded(
                child: GridView.count(
                  physics: const BouncingScrollPhysics(),
                  childAspectRatio: 1 / 1.55,
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  children: cars.map((item) {
                    return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BookCar(car: item)),
                          );
                        },
                        child: buildCar(item, 0));
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 90,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              buildFilterIcon(),
              Row(
                children: buildFilters(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFilterIcon() {
    return Container(
      width: 50,
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: kPrimaryColorShadow,
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.filter_list,
          color: Colors.yellow,
          size: 24,
        ),
      ),
    );
  }

  List<Widget> buildFilters() {
    List<Widget> list = [];
    for (var i = 0; i < filters.length; i++) {
      list.add(buildFilter(filters[i]));
    }
    return list;
  }

  Widget buildFilter(Filter filter) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = filter;
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Text(
          filter.name,
          style: TextStyle(
            color: selectedFilter == filter ? kPrimaryColor : Colors.grey[600],
            fontSize: 16,
            fontWeight:
                selectedFilter == filter ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
