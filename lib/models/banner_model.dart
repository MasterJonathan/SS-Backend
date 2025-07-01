// lib/models/banner_model.dart

class BannerTopModel {
  final String id;
  final String namaBanner;
  final DateTime tanggalAktifMulai;
  final DateTime tanggalAktifSelesai;
  final String bannerImageUrl;
  final bool status;
  final int hits;
  final DateTime tanggalPosting;
  final String dipostingOleh;

  BannerTopModel({
    required this.id,
    required this.namaBanner,
    required this.tanggalAktifMulai,
    required this.tanggalAktifSelesai,
    required this.bannerImageUrl,
    required this.status,
    required this.hits,
    required this.tanggalPosting,
    required this.dipostingOleh,
  });
}