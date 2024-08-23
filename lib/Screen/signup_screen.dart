import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_prg/Screen/login_screen.dart';
import 'package:my_prg/Widgets/round_gradient_button.dart';
import 'package:my_prg/Widgets/round_text_field.dart';
import 'package:my_prg/utils/app_colors.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _user = FirebaseFirestore.instance.collection("users");

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  bool _isObscure = true;
  bool _isCheck = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: media.height * 0.1),
                SizedBox(
                  width: media.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: media.width * 0.03),
                      const Text(
                        "Hey there",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: media.width * 0.01),
                      const Text(
                        "Create an Account",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: media.width * 0.02),
                RoundTextField(
                  isObsecureText: false,
                  textEditingController: _firstNameController,
                  hintText: "First Name",
                  icon: "assets/icons/user.png",
                  textInputType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your First Name";
                    }
                    return null;
                  },
                ),
                SizedBox(height: media.width * 0.02),
                RoundTextField(
                  isObsecureText: false,
                  textEditingController: _lastNameController,
                  hintText: "Last Name",
                  icon: "assets/icons/user.png",
                  textInputType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your Last Name";
                    }
                    return null;
                  },
                ),
                SizedBox(height: media.width * 0.02),
                RoundTextField(
                  isObsecureText: false,
                  textEditingController: _emailController,
                  hintText: "Email",
                  icon: "assets/icons/message_icon.png",
                  textInputType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your email";
                    }
                    return null;
                  },
                ),
                SizedBox(height: media.width * 0.02),
                RoundTextField(
                  isObsecureText: _isObscure,
                  textEditingController: _passController,
                  hintText: "Password",
                  icon: "assets/icons/hide.png",
                  textInputType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your password";
                    } else if (value.length < 6) {
                      return "Password must be at least 6 characters long";
                    }
                    return null;
                  },
                  rightIcon: TextButton(
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 20,
                      width: 20,
                      child: Image.asset(
                        _isObscure
                            ? "assets/icons/show_pwd.png"
                            : "assets/icons/show.png",
                        width: 20,
                        height: 20,
                        fit: BoxFit.contain,
                        color: AppColors.grayColor,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Handle forgot password
                    },
                    child: Text(
                      "Forgot your Password?",
                      style: TextStyle(
                        color: AppColors.secondary_Color1,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _isCheck = !_isCheck;
                        });
                      },
                      icon: Icon(
                        _isCheck
                            ? Icons.check_box_outlined
                            : Icons.check_box_outline_blank,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "By continuing you accept our Privacy Policy and\nTerms of Use",
                        style: TextStyle(
                          color: AppColors.grayColor,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: media.width * 0.05),
                RoundGradientButton(
                  title: "Create Account",
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (_isCheck) {
                        try {
                          UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
                            email: _emailController.text,
                            password: _passController.text,
                          );

                          String uid = userCredential.user!.uid;
                          await _user.doc(uid).set({
                            'email': _emailController.text,
                            'firstName': _firstNameController.text,
                            'lastName': _lastNameController.text,
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Account Created Successfully")),
                          );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())),
                          );
                        }
                      }
                    }
                  },
                ),
                SizedBox(height: media.width * 0.1),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: AppColors.grayColor.withOpacity(0.5),
                      ),
                    ),
                    Text(
                      "   Or   ",
                      style: TextStyle(
                        color: AppColors.grayColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: AppColors.grayColor.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: media.width * 0.1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Handle Google Sign-In
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppColors.primary_Color1.withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        child: Image.asset(
                          "assets/icons/search.png", // Path for Google sign-in icon
                          height: 20,
                          width: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: media.width * 0.05),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      children: [
                        const TextSpan(text: "Already have an account? "),
                        TextSpan(
                          text: "Login",
                          style: TextStyle(
                            color: AppColors.secondary_Color1,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
