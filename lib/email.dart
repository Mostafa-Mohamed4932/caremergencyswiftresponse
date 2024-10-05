import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

Future<void> sendEmail(String toEmail, String subject, String body) async {
  // Replace with your Gmail credentials
  final String username = 'your_gmail@gmail.com';
  final String password = 'your_password_or_app_password'; // Use App Password if 2FA is enabled

  // Create an SMTP server instance
  final smtpServer = gmail(username, password);

  // Create the email message
  final message = Message()
    ..from = Address(username, 'Your App Name')
    ..recipients.add(toEmail) // recipient's email
    ..subject = subject
    ..text = body; // plain text content

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Message not sent. Error: $e');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }
}
