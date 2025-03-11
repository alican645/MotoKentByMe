import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/App/app_theme.dart';
import 'package:moto_kent/components/custom_button_22.dart';
import 'package:moto_kent/components/my_textfile.dart';
import 'package:moto_kent/constants/app_routes.dart';
import 'package:moto_kent/models/register_model.dart';
import 'package:intl/intl.dart' show DateFormat;

class RegisterUserProfileView extends StatefulWidget {
  const RegisterUserProfileView({super.key});

  @override
  RegisterUserProfileViewState createState() => RegisterUserProfileViewState();
}

class RegisterUserProfileViewState extends State<RegisterUserProfileView> {
  final fullNameController = TextEditingController();
  final _dateController = TextEditingController();
  DateTime? birthDay;
  bool? gender;

  @override
  void initState() {
    super.initState();
  }

  void goToRegisterPage() {
    var registerModel = RegisterModel(
        fullName: fullNameController.text,
        birthDate: birthDay,
        gender: gender);

    context.push(AppRoutes.registerPage, extra: registerModel);
  }

  Future<void> _showDateTimePicker() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('tr', 'TR'), // Türkçe dil desteği
    );

    if (pickedDate != null) {
      // Tarihi istediğiniz formatta düzenleyin (ör. "dd-MM-yyyy")
      birthDay = pickedDate;
      final String formattedDate =
          DateFormat('dd-MM-yyyy', 'tr_TR').format(pickedDate);
      setState(() {
        _dateController.text = formattedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppTheme.themeData.primaryColor,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                const Icon(
                  Icons.person_add,
                  size: 100,
                ),
                Text(
                  "Yeni bir hesap oluşturun",
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 25),
                Container(
                  height: MediaQuery.sizeOf(context).height,
                  width: MediaQuery.sizeOf(context).width,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      MyTextField(
                        controller: fullNameController,
                        hintText: 'Ad Soyad',
                        obscureText: false,
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: TextField(
                          readOnly: true,
                          controller: _dateController,
                          onTap: () {
                            _showDateTimePicker();
                          },
                          decoration: InputDecoration(
                            hintText: "Doğum Tarihini Giriniz",
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            fillColor: Colors.grey.shade200,
                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey[500]),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButtonFormField2<bool>(
                            hint: const Text("Cinsiyetinizi Seçiniz"),
                            decoration: InputDecoration(
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              fillColor: Colors.grey.shade200,
                              filled: true,
                              hintStyle: TextStyle(color: Colors.grey[500]),
                            ),
                            items: const [
                              DropdownMenuItem<bool>(
                                value: false,
                                child: Text("Kadın"),
                              ),
                              DropdownMenuItem<bool>(
                                value: true,
                                child: Text("Erkek"),
                              ),
                            ],
                            onChanged: (value) {
                              gender = value;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      CustomButton22(
                        color: Colors.black,
                        splashColor: Colors.grey,
                        onPressed: () async {
                          if (birthDay == null ||
                              gender == null ||
                              fullNameController.text == "") {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(
                                        "Lütfen ilgili alanları boş bırakmayın")));
                            return;
                          }
                          goToRegisterPage();
                        },
                        text: "Devam Et",
                      ),
                    ],
                  ),
                ),
                // Ad soyad textfield
              ],
            ),
          ),
        ),
      ),
    );
  }
}
