import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CountryStateDropdowns extends StatefulWidget {
  @override
  _CountryStateDropdownsState createState() => _CountryStateDropdownsState();
}

class _CountryStateDropdownsState extends State<CountryStateDropdowns> {
  String? selectedCountry;
  List<CountryModel> countries = [];
  List<String> states = [];
  String? selectedState;

  @override
  void initState() {
    super.initState();
    fetchCountries();
  }

  Future<void> fetchCountries() async {
    var response = await http.get(Uri.parse(
        'http://192.168.88.10:30513/otonomus/common/api/v1/countries?page=0&size=300'));

    var decodedResponse = jsonDecode(response.body);
    var result = decodedResponse['data'] as List;
    final finalResponse =
        result.map((map) => CountryModel.fromJson(map)).toList();
    setState(() {
      countries = finalResponse;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: DropdownButton<String>(
            isExpanded: true,
            value: selectedCountry,
            hint: Text('Select a country'),
            onChanged: (newValue) {
              setState(() {
                selectedCountry = newValue;
                selectedState = null; // Reset the state when country changes

                if (selectedCountry != null) {
                  fetchStatesForCountry(selectedCountry!);
                }
              });
            },
            items: countries.map((country) {
              return DropdownMenuItem<String>(
                value: country.countryId, // Pass the countryId as the value
                child: Text(country.countryName!),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 16.0),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: DropdownButton<String>(
            isExpanded: true,
            value: selectedState,
            hint: Text('Select a state'),
            onChanged: (newValue) {
              setState(() {
                selectedState = newValue;
              });
            },
            items: states.map((state) {
              return DropdownMenuItem<String>(
                value: state,
                child: Text(state),
              );
            }).toList(),
            onTap: selectedCountry == null
                ? () {
                    FocusManager.instance.primaryFocus?.unfocus();
                  }
                : null,
            dropdownColor: selectedCountry == null ? Colors.grey : null,
          ),
        ),
      ],
    );
  }

  Future<void> fetchStatesForCountry(String countryId) async {
    final response = await http.get(Uri.parse(
        'http://192.168.88.10:30513/otonomus/common/api/v1/country/$countryId/states'));
    dynamic decodedResponse = json.decode(response.body);

    if (decodedResponse is List) {
      List<String> stateList =
          decodedResponse.map((item) => item['stateName'].toString()).toList();
      setState(() {
        states = stateList;
      });
    } else if (decodedResponse is Map && decodedResponse.containsKey('data')) {
      var dataList = decodedResponse['data'] as List<dynamic>;
      List<String> stateList =
          dataList.map((item) => item['stateName'].toString()).toList();
      setState(() {
        states = stateList;
      });
    } else {
      setState(() {
        states = []; // Clear the states list if no valid data is received
      });
    }
  }
}

// ... Rest of the code remains unchanged.

class CountryModel {
  final String? countryId;
  final String? countryName;
  final String? countryCode;
  final String? isoCode2;
  final String? isoCode3;

  CountryModel({
    this.countryId,
    this.countryName,
    this.countryCode,
    this.isoCode2,
    this.isoCode3,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) => CountryModel(
        countryId: json["idCountry"],
        countryName: json["countryName"],
        countryCode: json["countryCode"],
        isoCode2: json["isoCode2"],
        isoCode3: json["isoCode3"],
      );

  Map<String, dynamic> toJson() => {
        "countryId": countryId,
        "countryName": countryName,
        "countryCode": countryCode,
        "isoCode2": isoCode2,
        "isoCode3": isoCode3,
      };

  @override
  String toString() {
    return 'CountryModel(countryId: $countryId, name: $countryName, code: $countryCode, isocode2: $isoCode2, isocode3: $isoCode3)';
  }
}

class CountryStateResponse {
  final String? message;
  final List<StateModel> data;
  final String? status;
  final String? timeStamp;

  CountryStateResponse({
    this.message,
    required this.data,
    this.status,
    this.timeStamp,
  });

  factory CountryStateResponse.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List<dynamic>;
    List<StateModel> stateList =
        dataList.map((item) => StateModel.fromJson(item)).toList();

    return CountryStateResponse(
      message: json['message'],
      data: stateList,
      status: json['status'],
      timeStamp: json['timeStamp'],
    );
  }
}

class StateModel {
  final String? idState;
  final String? stateName;
  final String? stateCode;
  final List<CityModel> cityList;

  StateModel({
    this.idState,
    this.stateName,
    this.stateCode,
    required this.cityList,
  });

  factory StateModel.fromJson(Map<String, dynamic> json) {
    var cityDataList = json['cityVOList'] as List<dynamic>;
    List<CityModel> cityList =
        cityDataList.map((item) => CityModel.fromJson(item)).toList();

    return StateModel(
      idState: json['idState'],
      stateName: json['stateName'],
      stateCode: json['stateCode'],
      cityList: cityList,
    );
  }
}

class CityModel {
  final String? idCity;
  final String? cityName;

  CityModel({
    this.idCity,
    this.cityName,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      idCity: json['idCity'],
      cityName: json['cityName'],
    );
  }
}
