import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unibook/components/button.dart';
import 'package:unibook/components/text_field.dart';
import 'package:unibook/helper/store_helper.dart';
import 'package:unibook/model/user_model.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterState();
}

class _RegisterState extends State<RegisterPage> {
  final userNameTextController = TextEditingController();
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock, size: 100),
                const SizedBox(height: 20),
                Text(
                  "Bir hesap oluştur",
                  style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                const SizedBox(height: 32),
                MyTextField(
                    controller: userNameTextController,
                    hintText: 'Kullanıcı Adı',
                    obscureText: false),
                const SizedBox(height: 12),
                MyTextField(
                    controller: emailTextController,
                    hintText: 'Mail Adresi',
                    obscureText: false),
                const SizedBox(height: 12),
                MyTextField(
                    controller: passwordTextController,
                    hintText: 'Şifre gir',
                    obscureText: false),
                const SizedBox(height: 12),
                MyTextField(
                    controller: confirmPasswordTextController,
                    hintText: 'Şifreyi yeniden gir',
                    obscureText: false),
                const SizedBox(height: 12),
                MyButton(
                    onClicked: () {
                      signUp(context);
                    },
                    btnText: "Hesap Oluştur"),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Hesabiniz varsa",
                        style: TextStyle(color: Colors.grey[700])),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: const Text(
                        "Giriş yapin",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void signUp(BuildContext context) async {
    BuildContext? dialogContext;
    showDialog(
        context: context,
        builder: (ctx) {
          dialogContext = ctx;
          return const Center(child: CircularProgressIndicator());
        });

    if (userNameTextController.text.isEmpty) {
      if (dialogContext != null && dialogContext!.mounted) {
        Navigator.pop(dialogContext!);
      }
      displayMessage("Kullanıcı adı boş olamaz!");
      return;
    }

    if (emailTextController.text.isEmpty) {
      if (dialogContext != null && dialogContext!.mounted) {
        Navigator.pop(dialogContext!);
      }
      displayMessage("Mail adresi boş olamaz!");
      return;
    }

    if (passwordTextController.text.isEmpty ||
        passwordTextController.text.length < 6) {
      if (dialogContext != null && dialogContext!.mounted) {
        Navigator.pop(dialogContext!);
      }
      displayMessage("Şifre uzunluğu 6'dan küçük olamaz!");
      return;
    }

    if (passwordTextController.text != confirmPasswordTextController.text) {
      if (dialogContext != null && dialogContext!.mounted) {
        Navigator.pop(dialogContext!);
      }
      displayMessage("Şifreler birbiriyle uyuşmuyor!");
      return;
    }

    String mailAddress = emailTextController.text;
    if (!EmailValidator.validate(mailAddress)) {
      if (dialogContext != null && dialogContext!.mounted) {
        Navigator.pop(dialogContext!);
      }
      displayMessage("Lütfen geçerli bir mail adressi giriniz!");
      return;
    }

    if (!mailAddress.contains("thk.edu.tr")) {
      if (dialogContext != null && dialogContext!.mounted) {
        Navigator.pop(dialogContext!);
      }
      displayMessage("Lütfen geçerli bir mail adressi giriniz!");
      return;
    }

    int type = 0;
    if(mailAddress.contains("@ceng")){
        type = 1;
    }else if(mailAddress.contains("@stu")){
        type = 0;
    }

    try {
      final credentials = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailTextController.text,
              password: passwordTextController.text);

      final userId = credentials.user?.uid ?? "";
      await FireStoreHelper().uploadUser(UserModel(
          id: userId,
          name: userNameTextController.text,
          email: emailTextController.text,
          image: "",
          docId: "",
          type: type));
      if (dialogContext != null && dialogContext!.mounted) {
        Navigator.pop(dialogContext!);
      }
      if (context.mounted) Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      if (dialogContext != null && dialogContext!.mounted) {
        Navigator.pop(dialogContext!);
      }
      displayMessage(e.code);
    }
  }

  void displayMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(Icons.error),
          backgroundColor: Colors.grey.shade200,
          title: const Center(
            child: Text(
              "Hata",
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
          content: Text(
            message,
            style: const TextStyle(color: Colors.black54, fontSize: 14),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Tamam'),
              child: const Text('Tamam'),
            ),
          ],
        );
      },
    );
  }
}
