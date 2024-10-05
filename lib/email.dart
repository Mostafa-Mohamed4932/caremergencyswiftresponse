import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

void sendEmail() async {
  // SMTP server configuration using the SendGrid details you provided
  String username = 'apikey'; // SendGrid's SMTP username (always 'apikey')
  String password = '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'; // SendGrid API Key

  // Create an SMTP server using SendGrid's SMTP server and credentials
  final smtpServer = SmtpServer(
    'smtp.sendgrid.net',
    port: 587, // Use port 587 for TLS
    username: username,
    password: password,
    ssl: false, // Set to true for SSL connection on port 465 if needed
  );

  // Create email message
  final message = Message()
    ..from = Address('youremail@example.com', 'CareEmergency Swift Response')
    ..recipients.add('recipient@example.com')
    ..subject = 'Test Email from CareEmergency Swift Response App'
    ..text = 'This is a test email sent from the CareEmergency Swift Response App using SendGrid SMTP!';

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Message not sent. ${e.toString()}');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }
}

