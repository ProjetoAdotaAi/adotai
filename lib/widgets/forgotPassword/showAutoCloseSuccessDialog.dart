import 'package:flutter/material.dart';

Future<void> showAutoCloseSuccessDialog(BuildContext context, String email) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: null,
      content: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 50,
              ),
            ),
            const SizedBox(height: 20),

            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(fontSize: 16, color: Colors.black),
                children: [
                  const TextSpan(text: 'Código será enviado para o e-mail '),
                  TextSpan(
                    text: email,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(text: ' caso ele exista'),
                ],
              ),
            ),

            const SizedBox(height: 35),
         
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.green,
              ),
            ),
          ],
          
        ),
      ),
    ),
  );
  
  await Future.delayed(const Duration(seconds: 4));

  Navigator.of(context, rootNavigator: true).pop(); 
}
