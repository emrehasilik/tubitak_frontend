import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // Importu unutma
import '../../theme/app_colors.dart';

class HomeTabScreen extends StatefulWidget {
  const HomeTabScreen({super.key});

  @override
  State<HomeTabScreen> createState() => _HomeTabScreenState();
}

class _HomeTabScreenState extends State<HomeTabScreen> {
  String userName = ""; // Çekilen isim buraya gelecek
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    try {
      // 1. Önce hafızaya kaydettiğimiz ID'yi okuyoruz
      final prefs = await SharedPreferences.getInstance();
      final String? userId = prefs.getString('userId');

      // Eğer ID yoksa (Giriş yapılmamışsa) işlemi durdur
      if (userId == null) {
        debugPrint("Hata: Kullanıcı ID'si bulunamadı.");
        setState(() {
          userName = "Misafir";
          isLoading = false;
        });
        return;
      }

      // 2. URL'i dinamik olarak oluşturuyoruz (ID sona ekleniyor)
      final String url = "http://10.0.2.2:5188/api/UserControllers/get-by-id/$userId";
      
      debugPrint("İstek atılan URL: $url"); // Konsoldan kontrol et

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['isSuccess'] == true) {
          setState(() {
            // API'den dönen 'name' verisini alıyoruz
            String rawName = data['result']['name'].toString();
            
            // Baş harfini büyütüp ekrana yazdırıyoruz
            userName = rawName.isNotEmpty 
                ? '${rawName[0].toUpperCase()}${rawName.substring(1)}' 
                : rawName;
            
            isLoading = false;
          });
        }
      } else {
        debugPrint("API Hatası: ${response.statusCode}");
        setState(() => isLoading = false);
      }
    } catch (e) {
      debugPrint("Hata oluştu: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // --- MOCK VERİLER (SİLMEDİM) ---
    const lastWateredGardenName = "2. Bahçe";
    const lastWateredDaysAgo = 3;
    const riskyGardenName = "3. Bahçe";
    const riskLabel = "Riskli durum";

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          "Anasayfa",
          style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w700),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
          children: [
            // İSİM ALANI
            isLoading
                ? const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      ),
                    ),
                  )
                : Text(
                    "Merhaba, $userName 👋",
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
            
            const SizedBox(height: 6),
            Text(
              "Bugün bahçelerinin durumuna göz atalım.",
              style: TextStyle(
                fontSize: 13.5,
                color: AppColors.textDark.withOpacity(0.75),
              ),
            ),

            const SizedBox(height: 18),

            // KARTLAR (AYNI KALDI)
            _InfoCard(
              title: "Son sulama",
              subtitle: "$lastWateredGardenName’ni $lastWateredDaysAgo gün önce suladın",
              leadingIcon: Icons.water_drop,
              trailing: const Icon(Icons.chevron_right, size: 26),
              onTap: () {},
            ),

            const SizedBox(height: 12),

            _AlertCard(
              title: "$riskyGardenName'nde $riskLabel",
              subtitle: "Çözüm önerilerini incele!",
              buttonText: "Önerileri Gör",
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

// --- Alt Widgetlar (Değişmedi) ---
class _InfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData leadingIcon;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _InfoCard({
    required this.title,
    required this.subtitle,
    required this.leadingIcon,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(leadingIcon, color: AppColors.secondary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: TextStyle(fontSize: 13, height: 1.3, color: AppColors.textDark.withOpacity(0.75))),
                  ],
                ),
              ),
              if (trailing != null) ...[const SizedBox(width: 8), IconTheme(data: IconThemeData(color: AppColors.textDark.withOpacity(0.6)), child: trailing!)],
            ],
          ),
        ),
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback onPressed;

  const _AlertCard({required this.title, required this.subtitle, required this.buttonText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.accent.withOpacity(0.65), width: 1.2)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Container(height: 44, width: 44, decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.18), borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.warning_amber_rounded, color: AppColors.primary)),
              const SizedBox(width: 12),
              Expanded(child: Text(title, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800, color: AppColors.textDark))),
            ]),
            const SizedBox(height: 10),
            Text(subtitle, style: TextStyle(fontSize: 13.5, color: AppColors.textDark.withOpacity(0.8))),
            const SizedBox(height: 12),
            SizedBox(width: double.infinity, height: 46, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))), onPressed: onPressed, child: Text(buttonText, style: const TextStyle(fontWeight: FontWeight.w700)))),
          ],
        ),
      ),
    );
  }
}
class _MiniStatsRow extends StatelessWidget {
  final String leftTitle, leftValue, rightTitle, rightValue;
  const _MiniStatsRow({required this.leftTitle, required this.leftValue, required this.rightTitle, required this.rightValue});
  @override
  Widget build(BuildContext context) {
    Widget statCard(String title, String value) => Expanded(child: Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: TextStyle(fontSize: 12.5, color: AppColors.textDark.withOpacity(0.7), fontWeight: FontWeight.w600)), const SizedBox(height: 6), Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.textDark))])));
    return Row(children: [statCard(leftTitle, leftValue), const SizedBox(width: 12), statCard(rightTitle, rightValue)]);
  }
}