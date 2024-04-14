import 'package:culinary_craft_wireframe/Services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../Models/reset_password_with_code_model.dart';


class ResetPasswordWithCodeWidget extends StatefulWidget {
  const ResetPasswordWithCodeWidget({super.key});

  @override
  State<ResetPasswordWithCodeWidget> createState() =>
      _ResetPasswordWithCodeWidgetState();
}

class _ResetPasswordWithCodeWidgetState
    extends State<ResetPasswordWithCodeWidget> {
  late ResetPasswordWithCodeModel _model;

  late String enteredCode;

  @override
  void initState() {
    super.initState();
    _model = ResetPasswordWithCodeModel();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0, // Eliminăm umbra AppBar-ului
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushNamed('/forgot_password');
            },
          ),
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,

            children: [
              Expanded(
                child: Align(
                  alignment: const AlignmentDirectional(0, 0),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center, // Centrare text
                      crossAxisAlignment: CrossAxisAlignment.center, // Centrare text
                      children: [
                           const Text(
                            'Enter the code',
                            style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                        const Divider(
                          height: 30,
                          thickness: 1,
                          color: Colors.white,
                        ),
                        PinCodeTextField(
                          autoDisposeControllers: false,
                          appContext: context,
                          length: 4,
                          textStyle: const TextStyle(
                            fontSize: 16,
                          ),
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          enableActiveFill: false,
                          autoFocus: true,
                          enablePinAutofill: false,
                          errorTextSpace: 16,
                          showCursor: true,
                          cursorColor: Colors.blue,
                          obscureText: false,
                          hintCharacter: '●',
                          keyboardType: TextInputType.number,
                          pinTheme: PinTheme(
                            fieldHeight: 44,
                            fieldWidth: 44,
                            borderWidth: 2,
                            borderRadius: BorderRadius.circular(12),
                            shape: PinCodeFieldShape.box,
                            activeColor: Colors.blue,
                            inactiveColor: Colors.grey,
                            selectedColor: Colors.blue,
                            activeFillColor: Colors.blue,
                            inactiveFillColor: Colors.grey,
                            selectedFillColor: Colors.blue,
                          ),
                          controller: _model.pinCodeController,
                          onChanged: (value) {
                            enteredCode = value;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                          child: ElevatedButton(
                            onPressed: () async {
                              // String enteredPin = _model.pinCodeController!.text;
                              AuthService.verifyCode(context, enteredCode);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            child: const Text(
                              'Reset Password',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
