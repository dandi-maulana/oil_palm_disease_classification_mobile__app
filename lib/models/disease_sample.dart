// lib/models/disease_sample.dart
class DiseaseSample {
  final String id;
  final String name;
  final String imagePath;
  final String description;
  final String solution;

  DiseaseSample({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.description,
    required this.solution,
  });

  // Dummy data (akan digunakan di Home Screen)
  static List<DiseaseSample> dummySamples = [
    DiseaseSample(
      id: 'sehat',
      name: 'Daun Sehat',
      imagePath: 'assets/images/daun_sehat.jpg',
      description: 'Daun kelapa sawit dalam kondisi sehat, menunjukkan warna hijau cerah dan tidak ada tanda-tanda kerusakan fisik atau serangan patogen.',
      solution: 'Pertahankan praktik agronomi yang baik, pemupukan teratur, dan pemantauan rutin untuk mencegah serangan hama dan penyakit.',
    ),
    DiseaseSample(
      id: 'kuning',
      name: 'Daun Kuning',
      imagePath: 'assets/images/daun_kuning.jpg',
      description: 'Gejala daun menguning seringkali disebabkan oleh kekurangan nutrisi (terutama Nitrogen dan Magnesium), drainase yang buruk, atau serangan penyakit tertentu.',
      solution: 'Lakukan analisis tanah dan daun untuk mengidentifikasi defisiensi nutrisi. Berikan pupuk yang sesuai. Pastikan sistem drainase perkebunan berfungsi dengan baik.',
    ),
    DiseaseSample(
      id: 'bercak',
      name: 'Daun Bercak',
      imagePath: 'assets/images/daun_bercak.jpg',
      description: 'Ditandai dengan munculnya bercak-bercak coklat atau hitam pada permukaan daun, seringkali akibat infeksi jamur seperti *Pestalotiopsis* atau *Curvularia*.',
      solution: 'Identifikasi jenis jamur penyebab. Lakukan pemangkasan daun yang terinfeksi dan bakar. Aplikasi fungisida yang tepat dapat membantu mengendalikan penyebaran.',
    ),
    DiseaseSample(
      id: 'busuk',
      name: 'Daun Busuk',
      imagePath: 'assets/images/daun_busuk.jpg',
      description: 'Kondisi daun yang membusuk, seringkali lunak dan berbau tidak sedap, disebabkan oleh infeksi bakteri atau jamur parah yang merusak jaringan daun.',
      solution: 'Buang dan musnahkan bagian tanaman yang busuk untuk mencegah penyebaran. Gunakan fungisida atau bakterisida yang direkomendasikan dan tingkatkan kebersihan perkebunan.',
    ),
  ];
}