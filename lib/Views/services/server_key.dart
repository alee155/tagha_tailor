import 'package:googleapis_auth/auth_io.dart';

class GetServerKey {
  Future<String> getServerKeyToken() async {
    final accountCredentials = ServiceAccountCredentials.fromJson(r'''
{
  "type": "service_account",
  "project_id": "tagha-dd20c",
  "private_key_id": "7d0cc6e37d3fb7bae4d2ce9f63ef91e26020d89d",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCocOOw9nsnP61N\nVCW+ji64dezPWEBUrCPmFXGM2m37by5qBnwc2x3KzNPLIIp06GbVLOU/0NKwdvWH\nV6nu9gh5KeNeocgvsIaUwt7EwA/v39uTsS+lvcujm1nCakwJPHHyY8XwhPf/OgP3\nWKeaZaK4PpDByDdCOJFmanCIFQJ3pz/U/vyJzNjvcln/QkiVsfBC9882cdXlt9wE\nd+cycAcWNe/1VEbTFASn8lm7MQlHiwUWGNHVpVHDHijmuwDbarjUqXY/s7N/cTzp\nNc+4V675W56iunYU/rKLUOsejPwcSLapqAeHbwXouojwHMlQU0Ao243zDp5JriW5\nUDYlpv79AgMBAAECggEAA2k10y0BegLaGZJ/hJpZorai6eEixYHlwDUJ0Q0+v8a5\ndi3ncF9MIbiktMExXt+N7rBYDmehmArwqMZnr/v66s3I7BOqDdiat/ENuT2wJzet\nlKRdD4FPkPTh1U0wC0fWXJg5N1qHsNaV7ELt6M7LOsUQb6nftuGVzee0wD8BPhJ0\nRFqgTkDzlmrWQBaVk/+dVDGe5dETn/Ux8V+YUQ2bfvN+DOVtQFJPpkv6bqkS3NAD\nXFDwofNo3TP88pXWTGdcRKMG3CG2t3SUAj8J15QNfEorgBDWahv8LkzHI2o0NJLv\n56JEA9INEvDXV9DiV/bu6g4zoC6xjKI6rwX+Cr0SKQKBgQDafKvKvkJL7UBoeCud\nijhVv49kWsgYEH9OfmHRCQVtZuP4YpiJeSSNaY35dYEzX16SIgDNmHLcSvfxqcMk\nAR2C+K64FiQRYRBvUq96J9Y9GIEx5v+FYdHsTnf1tabdLGtteqVeTQTRUdfAC793\nBiO/cahuKxGz//rc73ET+Al0ewKBgQDFXIGxYJmSee3OIcuO71uWJCedSObqHAxf\nEGYdiDm4KjJqIiDJ2vv7ZdCIU493TMBWyEat+w2myZt3nBt16QcIOer3pGhW4mLH\nwJgsfxw3qwTm+9EO4nCeHZQs+0u2WQUmhINOt0nKsPh/5+cu9sYRQG+zImwFCYlP\nRU37EoFs5wKBgQC0cDnAWpiN9AY5QOVkWf5kcquNiZuupBE/VgiahgTBcTPcsjCf\neDjDwOTLnEtzjdOghAx9vuU9IXzbTAQo+/LPc2l4BnELGUplZbgd/kBkfJRWDhwA\nn+Sqb7OKbNa92i1uYNeppZnQ9PJlXE5nkd58APXE5jTcnw8i32xXvYSxeQKBgCdh\ndwuCwAIHTFlGSwzhXAAQhMsQoery39EUP5wC86l42ghteOduR7t5LGwXaFggu3xV\niCztHGM8dUYfoyca8WlFzUnOx3cWwykil/rA/ktpV5gThTqYGmqick+rcQcYqjtu\nU5kgX5wPRfaXunyXhxwoJGG1K6KxrXFg3deMcMDfAoGAH9W3w1nEao0paJXrehET\nVACkIBWb0GYoSZtZjyXNM0kfht1Ko32OdLSxWwUXurLRZZjtfOoerJwf3mfxOEaQ\npF4+hyjLZ7e32SVFjeq8i10diafdDZGoKsA0TWqqJ+x+pkmu8Rarvpyx2+bPLjdb\nXrY7PuiWoed9GB9vF2sgP0M=\n-----END PRIVATE KEY-----\n",
  "client_email": "firebase-adminsdk-1vjha@tagha-dd20c.iam.gserviceaccount.com",
  "client_id": "103265039176236449022",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-1vjha%40tagha-dd20c.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}


''');

    final scopes = [
      'https://www.googleapis.com/auth/firebase.messaging',
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
    ];

    final client = await clientViaServiceAccount(accountCredentials, scopes);
    return client.credentials.accessToken.data;
  }
}
