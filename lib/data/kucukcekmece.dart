class Ilce {
  final String ad;
  final List<Mahalle> mahalleler;

  Ilce({required this.ad, required this.mahalleler});
}

List<Ilce> ilceler = [
  Ilce(ad: "Küçükçekmece", mahalleler: mahalleler),
  // Diğer ilçeler ve mahalleleri
];

class Mahalle {
  final String ad;
  final double lat;
  final double lng;
  final int cokAgirHasarli;
  final int agirHasarli;
  final int ortaHasarli;
  final int hafifHasarli;

  Mahalle(
      {required this.ad,
      required this.lat,
      required this.lng,
      required this.cokAgirHasarli,
      required this.agirHasarli,
      required this.ortaHasarli,
      required this.hafifHasarli});
}

List<Mahalle> mahalleler = [
  Mahalle(
      ad: 'ATAKENT',
      lat: 41.055389,
      lng: 28.785318,
      cokAgirHasarli: 8,
      agirHasarli: 25,
      ortaHasarli: 118,
      hafifHasarli: 356),
  Mahalle(
      ad: 'ATATÜRK',
      lat: 41.052823,
      lng: 28.795572,
      cokAgirHasarli: 32,
      agirHasarli: 97,
      ortaHasarli: 473,
      hafifHasarli: 985),
  Mahalle(
      ad: 'BEŞYOL',
      lat: 40.991869,
      lng: 28.795866,
      cokAgirHasarli: 7,
      agirHasarli: 17,
      ortaHasarli: 55,
      hafifHasarli: 88),
  Mahalle(
      ad: 'CENNET',
      lat: 40.990388,
      lng: 28.781197,
      cokAgirHasarli: 88,
      agirHasarli: 134,
      ortaHasarli: 325,
      hafifHasarli: 415),
  Mahalle(
      ad: 'CUMHURİYET',
      lat: 41.001912,
      lng: 28.777992,
      cokAgirHasarli: 109,
      agirHasarli: 209,
      ortaHasarli: 626,
      hafifHasarli: 803),
  Mahalle(
      ad: 'FATİH',
      lat: 40.985748,
      lng: 28.770697,
      cokAgirHasarli: 54,
      agirHasarli: 74,
      ortaHasarli: 168,
      hafifHasarli: 184),
  Mahalle(
      ad: 'FEVZİ ÇAKMAK',
      lat: 41.006558,
      lng: 28.790472,
      cokAgirHasarli: 84,
      agirHasarli: 155,
      ortaHasarli: 477,
      hafifHasarli: 603),
  Mahalle(
      ad: 'GÜLTEPE',
      lat: 40.994351,
      lng: 28.791311,
      cokAgirHasarli: 52,
      agirHasarli: 116,
      ortaHasarli: 391,
      hafifHasarli: 591),
  Mahalle(
      ad: 'HALKALI MERKEZ',
      lat: 41.035518,
      lng: 28.788805,
      cokAgirHasarli: 57,
      agirHasarli: 163,
      ortaHasarli: 709,
      hafifHasarli: 1315),
  Mahalle(
      ad: 'İNÖNÜ',
      lat: 41.024492,
      lng: 28.796379,
      cokAgirHasarli: 95,
      agirHasarli: 243,
      ortaHasarli: 924,
      hafifHasarli: 1399),
  Mahalle(
      ad: 'İSTASYON',
      lat: 41.021208,
      lng: 28.777582,
      cokAgirHasarli: 46,
      agirHasarli: 116,
      ortaHasarli: 452,
      hafifHasarli: 751),
  Mahalle(
      ad: 'KANARYA',
      lat: 41.009601,
      lng: 28.778815,
      cokAgirHasarli: 116,
      agirHasarli: 235,
      ortaHasarli: 802,
      hafifHasarli: 1210),
  Mahalle(
      ad: 'KARTALTEPE',
      lat: 41.002406,
      lng: 28.804166,
      cokAgirHasarli: 62,
      agirHasarli: 112,
      ortaHasarli: 313,
      hafifHasarli: 374),
  Mahalle(
      ad: 'KEMALPAŞA',
      lat: 41.002310,
      lng: 28.795334,
      cokAgirHasarli: 34,
      agirHasarli: 65,
      ortaHasarli: 219,
      hafifHasarli: 316),
  Mahalle(
      ad: 'MEHMET AKİF',
      lat: 41.056203,
      lng: 28.805930,
      cokAgirHasarli: 21,
      agirHasarli: 75,
      ortaHasarli: 435,
      hafifHasarli: 991),
  Mahalle(
      ad: 'SÖĞÜTLÜ ÇEŞME',
      lat: 41.020385,
      lng: 28.787547,
      cokAgirHasarli: 82,
      agirHasarli: 181,
      ortaHasarli: 645,
      hafifHasarli: 892),
  Mahalle(
      ad: 'SULTAN MURAT',
      lat: 41.001206,
      lng: 28.787044,
      cokAgirHasarli: 42,
      agirHasarli: 85,
      ortaHasarli: 262,
      hafifHasarli: 329),
  Mahalle(
      ad: 'TEVFİKBEY',
      lat: 41.010902,
      lng: 28.800224,
      cokAgirHasarli: 87,
      agirHasarli: 171,
      ortaHasarli: 533,
      hafifHasarli: 722),
  Mahalle(
      ad: 'YARIMBURGAZ',
      lat: 41.051296,
      lng: 28.750010,
      cokAgirHasarli: 11,
      agirHasarli: 45,
      ortaHasarli: 204,
      hafifHasarli: 362),
  Mahalle(
      ad: 'YENİ MAHALLE',
      lat: 40.996618,
      lng: 28.778647,
      cokAgirHasarli: 67,
      agirHasarli: 118,
      ortaHasarli: 327,
      hafifHasarli: 437),
  Mahalle(
      ad: 'YEŞİLOVA',
      lat: 40.989745,
      lng: 28.787057,
      cokAgirHasarli: 86,
      agirHasarli: 180,
      ortaHasarli: 520,
      hafifHasarli: 676),
];
