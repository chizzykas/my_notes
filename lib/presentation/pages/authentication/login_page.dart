import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_notes/presentation/widgets/snackbar_messages.dart';
import 'package:my_notes/services/auth/auth_exceptions.dart';
import 'package:my_notes/services/auth/bloc/auth_bloc.dart';
import 'package:my_notes/services/auth/bloc/auth_event.dart';
import 'package:my_notes/services/auth/bloc/auth_state.dart';
import 'package:my_notes/utils/router/base_navigator.dart';
import 'package:my_notes/utils/functions.dart';
import 'package:my_notes/presentation/widgets/google_button.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static const routeName = 'login_page';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _userEmail;

  late final TextEditingController _userPassword;

  bool obscurePassword = true;

  Icon passwordVisibilityIcon = const Icon(Icons.visibility);

  bool _isLoading = false;

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  final _formKey = GlobalKey<FormState>();

  final loaderKey = GlobalKey();
  @override
  void initState() {
    _userEmail = TextEditingController();
    _userPassword = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _userEmail.dispose();
    _userPassword.dispose();
    _passwordFocus.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthStateLoggedOut) {
          setState(() {
            _isLoading = state.isLoading;
          });
          if (state.exception is UserNotFoundAuthException) {
            final snackBar = MySnackBar('User does not exist').build();

            ScaffoldMessenger.of(BaseNavigator.key.currentContext!)
                .showSnackBar(snackBar);

            setState(() {
              _isLoading = state.isLoading;
            });
          } else if (state.exception is WrongPasswordAuthException) {
            final snackBar = MySnackBar("Wrong username or password").build();
            ScaffoldMessenger.of(BaseNavigator.key.currentContext!)
                .showSnackBar(snackBar);
            setState(() {
              _isLoading = state.isLoading;
            });
          } else if (state.exception is GenericAuthException) {
            final snackBar = MySnackBar("An error occurred").build();
            ScaffoldMessenger.of(BaseNavigator.key.currentContext!)
                .showSnackBar(snackBar);
            setState(() {
              _isLoading = state.isLoading;
            });
          }
          setState(() {
            _isLoading = state.isLoading;
          });
        }
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "Login",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
              ),
              backgroundColor: Theme.of(context).colorScheme.background,
              elevation: 0.5,
            ),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0.0),
              child: SingleChildScrollView(
                key: _formKey,
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SizedBox(height: 100.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome 👋!!!',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        const SizedBox(height: 12.0),
                        Text(
                          'Fill in your credentials below and hit the login button to continue',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 30.0),
                    TextFormField(
                      focusNode: _emailFocus,
                      onEditingComplete: () {
                        _passwordFocus.requestFocus();
                      },
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      controller: _userEmail,
                      onTapOutside: (_) {
                        FocusScope.of(context).unfocus();
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter your email";
                        }
                        if (!validateEmail(email: value)) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'example@whatevermail.com',
                        prefixIcon: const Icon(Icons.mail),
                        prefixIconColor:
                            Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    TextFormField(
                      focusNode: _passwordFocus,
                      obscureText: obscurePassword,
                      enableSuggestions: false,
                      autocorrect: false,
                      controller: _userPassword,
                      onTapOutside: (event) {
                        FocusScope.of(context).unfocus();
                      },
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        prefixIconColor:
                            Theme.of(context).colorScheme.onBackground,
                        suffixIconColor:
                            Theme.of(context).colorScheme.onBackground,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              final toggleVisibility = setPasswordVisibility(
                                  obscureText: obscurePassword);
                              obscurePassword = !obscurePassword;
                              final newIconData = toggleVisibility();
                              passwordVisibilityIcon = Icon(newIconData);
                            });
                          },
                          icon: passwordVisibilityIcon,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final email = _userEmail.text;
                        final password = _userPassword.text;
                        final auth = AuthFunctions();

                        await auth.signInWithEmailAndPassword(
                            context, email, password);
                      },
                      child: const Text('Login'),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            height: 15.0,
                            thickness: 2.0,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          'OR',
                          style: TextStyle(
                              fontSize: 12.0,
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        Expanded(
                          child: Divider(
                            height: 15.0,
                            thickness: 2.0,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    GoogleButton(),
                    const SizedBox(
                      height: 24.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?"),
                        const SizedBox(
                          width: 5.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            // BaseNavigator.pushNamed(SignupPage.routeName);
                            context
                                .read<AuthBloc>()
                                .add(const AuthEventShouldRegister());
                          },
                          child: Text(
                            "Sign up Here",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 100.0,
                    )
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            visible: _isLoading,
            child: Center(
              child: Opacity(
                opacity: 0.5,
                child: Container(
                  color: Colors.lightBlue[50],
                  height: MediaQuery.maybeSizeOf(context)!.height,
                  width: MediaQuery.maybeSizeOf(context)!.width,
                  child: SpinKitFoldingCube(
                    color: Theme.of(context).colorScheme.primary,
                    size: 100,
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: _isLoading,
            child: SpinKitFoldingCube(
              color: Theme.of(context).colorScheme.primary,
              size: 100,
            ),
          ),
        ],
      ),
    );
  }
}
