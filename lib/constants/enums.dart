enum CallForHelpEnum { kazaYardim, sorunYardim, beniBul }

enum PostCategoryEnum {
  etkinlik(0),
  duyuru(1),
  anket(2),
  ilan(3);

  final int categoryId;
  const PostCategoryEnum(this.categoryId);

  String get isim => name.toUpperCaseFirstLetter();
  int get id => categoryId;
  List<String> get valuess => ["Etkinlik", "Duyuru", "Anket", "İlan"];
}

enum TurkeyProvince {
  adana(1, "Adana"),

  adiyaman(2, "Adıyaman"),

  afyonkarahisar(3, "Afyonkarahisar"),

  agri(4, "Ağrı"),

  amasya(5, "Amasya"),

  ankara(6, "Ankara"),

  antalya(7, "Antalya"),

  artvin(8, "Artvin"),

  aydin(9, "Aydın"),

  balikesir(10, "Balıkesir"),

  bilecik(11, "Bilecik"),

  bingol(12, "Bingöl"),

  bitlis(13, "Bitlis"),

  bolu(14, "Bolu"),

  burdur(15, "Burdur"),

  bursa(16, "Bursa"),

  canakkale(17, "Çanakkale"),
  cankiri(18, "Çankırı"),
  corum(19, "Çorum"),
  denizli(20, "Denizli"),
  diyarbakir(21, "Diyarbakır"),
  edirne(22, "Edirne"),
  elazig(23, "Elazığ"),
  erzincan(24, "Erzincan"),
  erzurum(25, "Erzurum"),
  eskisehir(26, "Eskişehir"),
  gaziantep(27, "Gaziantep"),
  giresun(28, "Giresun"),
  gumushane(29, "Gümüşhane"),
  hakkari(30, "Hakkâri"),
  hatay(31, "Hatay"),
  isparta(32, "Isparta"),
  mersin(33, "Mersin"),
  istanbul(34, "İstanbul"),
  izmir(35, "İzmir"),
  kars(36, "Kars"),
  kastamonu(37, "Kastamonu"),
  kayseri(38, "Kayseri"),
  kirklareli(39, "Kırklareli"),
  kirsehir(40, "Kırşehir"),
  kocaeli(41, "Kocaeli"),
  konya(42, "Konya"),
  kutahya(43, "Kütahya"),
  malatya(44, "Malatya"),
  manisa(45, "Manisa"),
  kahramanmaras(46, "Kahramanmaraş"),
  mardin(47, "Mardin"),
  mugla(48, "Muğla"),
  mus(49, "Muş"),
  nevsehir(50, "Nevşehir"),
  nigde(51, "Niğde"),
  ordu(52, "Ordu"),
  rize(53, "Rize"),
  sakarya(54, "Sakarya"),
  samsun(55, "Samsun"),
  siirt(56, "Siirt"),
  sinop(57, "Sinop"),
  sivas(58, "Sivas"),
  tekirdag(59, "Tekirdağ"),
  tokat(60, "Tokat"),
  trabzon(61, "Trabzon"),
  tunceli(62, "Tunceli"),
  sanliurfa(63, "Şanlıurfa"),
  usak(64, "Uşak"),
  van(65, "Van"),
  yozgat(66, "Yozgat"),
  zonguldak(67, "Zonguldak"),
  aksaray(68, "Aksaray"),
  bayburt(69, "Bayburt"),
  karaman(70, "Karaman"),
  kirikkale(71, "Kırıkkale"),
  batman(72, "Batman"),
  sirnak(73, "Şırnak"),
  bartin(74, "Bartın"),
  ardahan(75, "Ardahan"),
  igdir(76, "Iğdır"),
  yalova(77, "Yalova"),
  karabuk(78, "Karabük"),
  kilis(79, "Kilis"),
  osmaniye(80, "Osmaniye"),
  duzce(81, "Düzce"),
  diger(82, "Diğer");

  final int plateCode;
  final String provinceName;

  const TurkeyProvince(this.plateCode, this.provinceName);

  /// Girilen plaka koduna ait şehrin adını döndüren static metot.
  static String getCityNameByPlateCode(int plateCode) {
    try {
      return TurkeyProvince.values
          .firstWhere((province) => province.plateCode == plateCode)
          .provinceName;
    } catch (e) {
      return "Böyle bir il bulunamadı";
    }
  }

  static TurkeyProvince getByCityName(String cityName) {
    return TurkeyProvince.values.firstWhere(
      (province) =>
          province.provinceName.toLowerCase() == cityName.toLowerCase(),
      orElse: () => TurkeyProvince.diger,
    );
  }
}

enum NotificationTypeEnum {
  privateMessage,
  groupChatMessage,
  groupJoinRequest,
  groupJoinRejectMessage,
  groupJoinAcceptMessage,
  postLike,
  postComment,
  groupChatIsClosedMessages,
  userRemoveInGroupByAdmin,
  callForHelp
}

String getProvinceNameByPlateCode(int plateCode) {
  return TurkeyProvince.values
      .firstWhere((element) => element.plateCode == plateCode)
      .provinceName;
}

extension StringExtension on String {
  String toUpperCaseFirstLetter() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
