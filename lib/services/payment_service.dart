import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:karaoke_reservation/constants.dart';
import 'package:karaoke_reservation/services/tools/tools.dart';

class PaymentService {
  var _dio = Dio();
  static const _ownerId = 'l73cff20a1133e4f88b2d4917e887d2e10';
  static const _api_secret = 'ebfcbfb78f8946ee8b4108f593343636';
  static const _biller_id = '918801478963426';
  var _baseHeaders = {
    'Content-Type' : "application/json",
    'Content-Length' : "-1",
    'Host' : "api-sandbox.partners.scb",
    'resourceOwnerId':_ownerId,
    'requestUId' : GenId().genUid(),
    'accept-language' :'EN'
  };

  var _basePaymentURL = 'https://api-sandbox.partners.scb/partners/sandbox/v1/';
  oauth()async{
    var body = {
      "applicationKey" : _ownerId,
      "applicationSecret" : _api_secret
    };
    var url = _basePaymentURL + "oauth/token";
    var response = await _dio.post(
      url,
      options: Options(headers:_baseHeaders),
      data: body
    );
    if(response.statusCode == 200) return response.data['data']['accessToken'];
    else return "Failed";
  }

  getQrCodePayment(String accessToken,double amount,String ref)async{
    var url = _basePaymentURL + "payment/qrcode/create";
    _baseHeaders.addAll(
      {"authorization" : 'Bearer $accessToken'}
    );
    var body = {
      "qrType": "PP",
      "amount": "$amount",
      "ppId": _biller_id,
      "ppType": "BILLERID",
      "ref1": ref,
      "ref2": ref,
      "ref3": "SCB"
    };
    
    var response = await _dio.post(
      url,
      options: Options(headers: _baseHeaders),
      data: body
    );
    if(response.statusCode == 200) return response.data['data']['qrImage'];
    else return "Failed";
  }

  getResultPayment(String ref)async{
    String dateNow = DateFormat('yyyy-MM-dd').format(DateTime.now());
    var url = _basePaymentURL + "payment/billpayment/inquiry?eventCode=00300100&billerId=$_biller_id&reference1=$ref&transactionDate=$dateNow";
    try {
      var response = await _dio.get(url,options: Options(headers: _baseHeaders));
      if(response.statusCode == 200) return "Success";
      else return "Failed";
    } catch (e) {
      return "Failed";
    }
  }
}
