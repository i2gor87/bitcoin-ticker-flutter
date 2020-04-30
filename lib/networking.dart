import 'dart:convert';

import 'package:bitcoin_ticker/constants.dart';
import 'package:http/http.dart' as http;

class CoinExchange {
  Future<Map<String, double>> getRate(String cur2) async {
    String BTCurl = kCoinURL + 'BTC/$cur2?apikey=$kCoinAPIKey';
    String ETHurl = kCoinURL + 'ETH/$cur2?apikey=$kCoinAPIKey';
    String LTCurl = kCoinURL + 'LTC/$cur2?apikey=$kCoinAPIKey';
    var BTCdata = await http.get(BTCurl);
    var ETHdata = await http.get(ETHurl);
    var LTCdata = await http.get(LTCurl);

    double b_rate = jsonDecode(BTCdata.body)['rate'];
    double e_rate = jsonDecode(ETHdata.body)['rate'];
    double l_rate = jsonDecode(LTCdata.body)['rate'];

    Map<String, double> result = {'BTC': b_rate, 'ETH': e_rate, 'LTC': l_rate};

    return result;
  }
}
