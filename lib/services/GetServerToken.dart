import 'package:googleapis_auth/auth_io.dart';

class GetServerToken {
  Future<String> getServerKeyToken() async {
    final scopes = [
      'http://www.googleapis.com/auth/userinfo.email',
      'http://www.googleapis.com/auth/firebase.databasse',
      'http://www.googleapis.com/auth/firebase.messaging',
    ];

    final client = await clientViaServiceAccount(ServiceAccountCredentials.fromJson({
        "type": "service_account",
        "project_id": "motokent-notification",
        "private_key_id": "401a1fc6b2802a19e8ea9c0bbdc35a3730d2ae29",
        "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCu5+45FGQ6v2Ar\nuSyHQfjDlHeBKCllhcL1PjuEuo1ZVv++RqWBkUiLGE0zfbONH2rSocUdFbL6m5zp\nuYq8LFSRx9w+yMa6AqxYPV9+WY+0unpPjLxD70Yf4lhTnr4beq6wmSQv/dYb0yQI\nmZYD9OWnJZU69XejpJGeycAcYdULJeclwM9LNGo7mwMVCbLln9R/qvPAJk9K3YNU\nmjz4FTgib647piWPQ3DGqBb+DJ/fYht1wBfn0/MclEtD83KfcrXe8/C3/44qb0Dm\nDkJrj13CkH0N45fJDWalzDGKwWeZVqW3Tg0bPUKVwP00b5bh+MkuZGeMo/eOEd15\n13gYe6bXAgMBAAECgf8rCuiVI2+HBZGlMOzEXHfbqa2/GyMU2NYhhC8hesdONRq6\nuKgCOr6ffFuDUGvfTtv6+dSIU8633ZO/8OkzZbVqKsUIrmA5Zm8DSBc4ANJcp4dy\nDDBIh5m6Pvl9mpMuMALNcuJ07QLD1jIH68P/NUVO3PDckYvfuaAcc4nTcj/7fe+Y\nCXsk8WKFm/se0tYinaIgVTSRwZde5JHABt4wN4qCVlgRx7tmwHEMqd8ccu+hYZQS\n9VxRRQrQo3Opa+3ek8W9qkXT3J4Lnx2UaMUSg1W8Da6UcNKi5n4gySRagL/6IG4S\n9U+k9gnRAK86taxYoxV8yl6grUEW2d93Yms9mkECgYEA7Jg8VCEzRS9WCXMIDlUZ\nTTHpB9bTedV7EeLjWsAyqOKmNqJEH+9fZkzkzx1g3EOHGG7xAdXxIBLy/lsIdcjG\nXYB7xVtAopvOhHwYCWT7XNY6IGPPKhknyX6K45HmyKPGiUg+Cc9cK8ea3nCpFEMq\nt+qcureJiR7LJA33pteZUqECgYEAvUBry7JwxbLleLMOAjE6Q0XEoyp+4SIlvAm0\nX0/ryUBICDtq9KH9D1jT2xQxqufF2Iq5AKGcSIjlS7CLIDoz5Uxv/Klnx1zlKU9y\nxUqCGExIeplTzuXY5i5ANQZ8vYRJYLKQesCdTIjnIeKuhnTow41u2+UrKk5XIchJ\n7zirfncCgYEAxswH7PzUkq56kYgJXdmdX+KvFnooyXdaaKYHOSrDpmqDFOb1bQv6\nUgAMRgc+avWGnz4g3dUBPV0OtjCRhD6Ghuw9k4/gWIGoXmPS4pnqJ5CN2Mdku8/V\nQZZFZ4Ahtbb/TDzae+2zWcnnVD6/oxno3A6TUMSFGSU5tXrS+2qvFuECgYAYPUoR\nOvequrEddoGS0k9OEn+PDoBVwZPns66AjrH6gts3ArU+RAkvkAcChmGeLDVw+MOd\nSxXDTJVhzmjjZdEDy3iEegYqyMEpO13N2y8ygYK/ASh01YekY8QhhoUvmOP1GKnc\nrxL2nIpOEsSbwBmYAmNykrWmo4YRc5/UngOJHQKBgQDMiRkGMUrkISBGChAs/0TH\njevjIZmedxCwLcjcgzLNLr3XLxfQmZhr8bFvKzzVjmQx1O0y72SVV+dx3a7SyrcU\nMrcZvtiL9+mm9wywbmNFySJ4dnC8uWl/0amhvrinrrl5IoUa1VIVmjSSjNUGZo0j\nKptmjCnsoWdP21VgDeYZPw==\n-----END PRIVATE KEY-----\n",
        "client_email": "firebase-adminsdk-nwvy6@motokent-notification.iam.gserviceaccount.com",
        "client_id": "110304712720196375381",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-nwvy6%40motokent-notification.iam.gserviceaccount.com",
        "universe_domain": "googleapis.com"
    }
    ), scopes);

    final accessServerKey=client.credentials.accessToken.data;
    return accessServerKey;
  }
}
