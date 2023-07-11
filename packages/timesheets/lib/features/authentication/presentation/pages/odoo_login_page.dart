import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progress_builder/progress_builder.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:timesheets/features/odoo/data/repositories/odoo_information_repository.dart';
import 'package:timesheets/features/odoo/odoo.dart';

@RoutePage()
class OdooLoginPage extends StatelessWidget with AutoRouteWrapper {
  const OdooLoginPage({
    super.key,
    @queryParam this.serverUrl,
    @queryParam this.db,
  });

  final String? serverUrl;
  final String? db;

  FormGroup _formBuilder(BuildContext context) => fb.group(
        {
          emailControlName: FormControl<String>(
            validators: [
              Validators.required,
              Validators.email,
            ],
          ),
          passControlName: FormControl<String>(
            validators: [
              Validators.required,
            ],
          ),
          serverUrlControlName: FormControl<String>(
            validators: [
              Validators.required,
              Validators.pattern(
                  r'((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?')
            ],
            asyncValidators: [
              _ValidServerAsyncValidator(
                  context.read<OdooInformationCubit>().getDbList)
            ],
            asyncValidatorsDebounceTime: 500,
            value: serverUrl ??
                context.read<AuthCubit>().state.odooCredentials?.serverUrl ??
                'https://',
          ),
          dbControlName: FormControl<String>(
            validators: [
              Validators.required,
            ],
            value: db ?? context.read<AuthCubit>().state.odooCredentials?.db,
          ),
        },
      );

  @override
  Widget build(BuildContext context) => DefaultActionController(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Sign in'),
            leading: const AutoLeadingButton(),
          ),
          body: Center(
            child: SingleChildScrollView(
              child: ReactiveFormBuilder(
                form: () => _formBuilder(context),
                builder: (context, form, child) => AutofillGroup(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: kPadding * 2,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AutofillGroup(
                          child: ReactiveTextField<String>(
                            autofocus: true,
                            formControlName: serverUrlControlName,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.url,
                            decoration: const InputDecoration(
                              hintText: 'Server Url',
                              helperText: 'https://www.example.com',
                            ),
                            onChanged: (control) {
                              final value = control.value;
                              if (control.valid) {
                                context
                                    .read<OdooInformationCubit>()
                                    .getDbList(value!);
                              }
                            },
                            autofillHints: const [AutofillHints.url],
                            validationMessages: {
                              ValidationMessage.required: (_) =>
                                  'Server Url is required',
                              ValidationMessage.pattern: (_) =>
                                  'Invalid url format',
                              'invalid_server': (_) => 'Invalid server url',
                            },
                          ),
                        ),
                        ReactiveStatusListenableBuilder(
                          builder: (context, control, child) {
                            if (control.pending) {
                              return const Column(
                                children: [
                                  SizedBox(
                                    height: kPadding * 2,
                                  ),
                                  Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ],
                              );
                            } else if (control.value != null && control.valid) {
                              return Column(
                                children: [
                                  const SizedBox(
                                    height: kPadding * 2,
                                  ),
                                  BlocBuilder<OdooInformationCubit,
                                      OdooInformationState>(
                                    builder: (context, state) =>
                                        AppReactiveDropdown(
                                      itemAsString: (db) => db.toString(),
                                      items: state.dbList,
                                      formControlName: dbControlName,
                                      hintText: 'Select DB',
                                      validationMessages: {
                                        ValidationMessage.required: (_) =>
                                            'Please select DB',
                                      },
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return const Offstage();
                            }
                          },
                          formControlName: serverUrlControlName,
                        ),
                        const SizedBox(
                          height: kPadding * 2,
                        ),
                        ReactiveTextField(
                          formControlName: emailControlName,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: 'Email',
                          ),
                          autofillHints: const [AutofillHints.email],
                          validationMessages: {
                            ValidationMessage.required: (_) =>
                                'Email is required',
                            ValidationMessage.email: (_) => 'Invalid format',
                          },
                        ),
                        const SizedBox(
                          height: kPadding * 2,
                        ),
                        ReactiveTextField(
                          formControlName: passControlName,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: const InputDecoration(
                            hintText: 'Password',
                          ),
                          autofillHints: const [AutofillHints.password],
                          validationMessages: {
                            ValidationMessage.required: (_) =>
                                'Password is required',
                          },
                          obscureText: true,
                          onSubmitted: (_) {
                            if (!form.valid) {
                              form.markAsTouched();
                            } else {
                              DefaultActionController.of(context)
                                  ?.add(ActionType.start);
                            }
                          },
                        ),
                        const SizedBox(
                          height: kPadding * 5,
                        ),
                        LinearProgressBuilder(
                          builder: (context, action, error) => ElevatedButton(
                            onPressed:
                                (ReactiveForm.of(context)?.valid ?? false)
                                    ? action
                                    : null,
                            child: const Center(child: Text('Login')),
                          ),
                          action: (_) => _signIn(context, form),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  Future<void> _signIn(BuildContext context, FormGroup form) async {
    final email = form.control(emailControlName).value as String;
    final pass = form.control(passControlName).value as String;
    String serverUrl = form.control(serverUrlControlName).value as String;
    final db = form.control(dbControlName).value as String;
    if (!serverUrl.endsWith('/')) {
      serverUrl += '/';
    }

    await context.read<AuthCubit>().loginWithOdoo(
          email: email,
          password: pass,
          serverUrl: serverUrl,
          db: db,
        );
  }

  @override
  Widget wrappedRoute(BuildContext context) => BlocProvider(
        create: (context) {
          final cubit = OdooInformationCubit(
            OdooInformationRepository(
              context.read<OdooXmlRpcClient>(),
            ),
          );

          final providedServerUrl = serverUrl ??
              context.read<AuthCubit>().state.odooCredentials?.serverUrl;
          if (providedServerUrl != null) {
            cubit.getDbList(providedServerUrl);
          }
          return cubit;
        },
        child: this,
      );
}

class _ValidServerAsyncValidator extends AsyncValidator<dynamic> {
  final Future<void> Function(String) getDbListMethod;

  _ValidServerAsyncValidator(this.getDbListMethod);
  @override
  Future<Map<String, dynamic>?> validate(
      AbstractControl<dynamic> control) async {
    final error = {'invalid_server': true};

    try {
      final serverUrl = control.value as String;
      await getDbListMethod(
          serverUrl.endsWith('/') ? serverUrl : '$serverUrl/');
      return null;
    } catch (e) {
      control.markAsTouched();
      return error;
    }
  }
}