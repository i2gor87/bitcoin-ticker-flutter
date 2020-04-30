import 'package:bitcoin_ticker/coin_data.dart';
import 'package:bitcoin_ticker/networking.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  Map<String, double> curMap = {'BTC': 0.0, 'ETH': 0.0, 'LTC': 0.0};

  CoinExchange coin = CoinExchange();

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> d = [];
    for (String currency in currenciesList) {
      d.add(DropdownMenuItem<String>(
        child: Text(currency),
        value: currency,
      ));
    }
    return DropdownButton<String>(
        value: selectedCurrency,
        items: d,
        onChanged: (val) async {
          Map<String, double> newrate = await coin.getRate(val);
          setState(() {
            curMap = newrate;
            selectedCurrency = val;
          });
        });
  }

  CupertinoPicker iOSPicker() {
    List<Widget> d = [];
    for (String currency in currenciesList) {
      d.add(Text(currency));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) async {
        String curr = currenciesList[selectedIndex];
        Map<String, double> newrate = await coin.getRate(curr);
        setState(() {
          curMap = newrate;
          selectedCurrency = curr;
        });
      },
      children: d,
    );
  }

  String selectedCurrency = currenciesList[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            children: <Widget>[
              OneCardWidget(
                rate: curMap['BTC'],
                selectedCurrency: selectedCurrency,
                currency: 'BTC',
              ),
              OneCardWidget(
                rate: curMap['ETH'],
                selectedCurrency: selectedCurrency,
                currency: 'ETH',
              ),
              OneCardWidget(
                rate: curMap['LTC'],
                selectedCurrency: selectedCurrency,
                currency: 'LTC',
              )
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}

class OneCardWidget extends StatelessWidget {
  const OneCardWidget(
      {Key key,
      @required this.rate,
      @required this.selectedCurrency,
      @required this.currency})
      : super(key: key);

  final double rate;
  final String selectedCurrency;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $currency = ${rate.toStringAsFixed(2)} $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
