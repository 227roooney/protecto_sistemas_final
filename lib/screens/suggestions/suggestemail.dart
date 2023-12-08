import 'package:firebase_auth/firebase_auth.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

void sendEmail(String suggestion) async {
  String username = 'nna6000452@est.univalle.edu';
  String password = '79067130Aq';

  final smtpServer = SmtpServer('smtp-mail.outlook.com',
      username: username, password: password);

  final message = Message()
    ..from = Address(username)
    ..recipients.add('nna6000452@est.univalle.edu')
    ..subject = 'Nueva sugerencia'
    ..text = 'Sugerencia: $suggestion';

  try {
    final sendReport = await send(message, smtpServer);
    print('Mensaje enviado: ${sendReport.toString()}');
  } catch (e) {
    print('No se pudo enviar el mensaje: $e');
  }
}
