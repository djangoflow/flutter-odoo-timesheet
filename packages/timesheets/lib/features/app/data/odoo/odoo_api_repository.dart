import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/authentication/authentication.dart';
import 'package:xml_rpc/client.dart' as xml_rpc;

///Repository to communicate with odoo external_api using xml_rpc
class OdooRepository {
  // TODO: remove singleton pattern if we don't need it absolutely, rather user RepositoryProvider
  static final OdooRepository _instance = OdooRepository._internal();

  factory OdooRepository() => _instance;
  // If need to use singleton please follow AuthCubit as an example to enable instance getter
  OdooRepository._internal();
  // TODO: Move project specific constants to project specific constants file in configurations folder
  final String baseUrl = 'https://portal.apexive.com/';

  ///This endpoint provides meta-calls which don’t require authentication.
  final String commonEndpoint = 'xmlrpc/2/common';

  ///It is used to call methods of odoo models. Require authentication.
  final String objectEndpoint = 'xmlrpc/2/object';

  final String db = 'wwnet-odoo';

  final String rpcFunction = 'execute_kw';

  Uri getCommonUri() => Uri.parse(baseUrl + commonEndpoint);

  Uri getObjectUri() => Uri.parse(baseUrl + objectEndpoint);

  /// Sends auth request to odoo xml_rpc and fetch user data and returns [User] on success
  Future<User?> connect(String email, String password) async {
    /// Sends auth request to odoo xml_rpc and returns id on success
    /// false value is returned on invalid email/pass
    var id = await xml_rpc.call(getCommonUri(), 'authenticate', [
      db,
      email,
      password,
      [],
    ]).catchError(handleError); // TODO: Handle error using try/catch

    /// Handling response on invalid email/password input
    if (id == false) {
      throw const OdooRepositoryException('Invalid Email/Password');
    }

    Map<String, dynamic> filterableFields =
        buildFilterableFields(['name', 'email']);

    ///Fetch user data
    // TODO: Use `as` keyword instead of `cast` to avoid runtime errors
    // Or declare type of list as List<Map<String, dynamic>>
    List response = await getObject(id, password, 'res.users', 'read', [id],
        optionalParams: filterableFields);

    ///Response is returned as String, using 0th index to get userData
    Map<String, dynamic> userData = response[0];

    ///Adding password as future execute_kw calls require password
    userData['pass'] = password;

    return User.fromJson(userData);
  }

  /// Performs various operations like read, search, update, add, edit data
  /// based on [model], [methods] and parameters
  Future getObject(
    int id,
    String password,
    String model,
    String method,
    List parameters, {
    Map<String, dynamic>? optionalParams,
  }) async {
    var response = await xml_rpc.call(
      getObjectUri(),
      rpcFunction,
      [
        db,
        id,
        password,
        model,
        method,
        parameters,
        optionalParams ?? {},
      ],
    ).catchError(handleError);

    return response;
  }

  ///Handles errors generated due to various operations in [OdooRepository] using [OdooRepositoryException]
  handleError(error) {
    // TODO: Better to use `is` keyword than .runtimeType for comparison
    if (error.runtimeType == xml_rpc.Fault) {
      throw OdooRepositoryException(error.text);
    } else {
      throw const OdooRepositoryException();
    }
  }

  ///Builds filters so that only relevant data is fetched
  Map<String, dynamic> buildFilterableFields(List fields) => {
        'fields': fields,
      };
}
