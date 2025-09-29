// lib/screens/history_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../config.dart';
import 'history_detail_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // ... (kode initState dan dispose tetap sama persis)
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  Future<void>? _debounce;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<AppProvider>(context, listen: false);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 &&
          !provider.isHistoryLoading && provider.hasMoreHistory) {
        provider.fetchHistory();
      }
    });
    _searchController.addListener(() {
      if (_debounce?.runtimeType != Null) {
        _debounce = null;
      }
      _debounce = Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
           provider.searchHistory(_searchController.text);
        }
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Deteksi')),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              // --- Kolom Pencarian ---
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Cari berdasarkan hasil, file, atau penguji...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
              ),

              // --- Daftar Riwayat ---
              Expanded(
                child: provider.isHistoryLoading && provider.history.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : provider.history.isEmpty
                        ? const Center(child: Text('Tidak ada riwayat yang cocok.'))
                        : RefreshIndicator(
                            onRefresh: () => provider.fetchHistory(isNewSearch: true),
                            child: ListView.builder(
                              controller: _scrollController,
                              itemCount: provider.history.length + (provider.isHistoryLoading && provider.hasMoreHistory ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index == provider.history.length) {
                                  return const Center(child: Padding(padding: EdgeInsets.all(16.0), child: CircularProgressIndicator()));
                                }
                                final item = provider.history[index];
                                final imageUrl = 'http://$API_IP:8000/storage/${item.gambarUrl}';

                                return Card(
                                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                  elevation: 3,
                                  color: Colors.blue[50],
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HistoryDetailScreen(historyId: item.id),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Image.network(imageUrl, width: 80, height: 80, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(width: 80, height: 80, color: Colors.grey[200], child: Icon(Icons.image_not_supported, color: Colors.grey[400]))),
                                          ),
                                          const SizedBox(width: 15),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(item.hasilPrediksi, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: item.hasilPrediksi == 'Daun Sehat' ? Colors.green[800] : Colors.red[800])),
                                                const SizedBox(height: 4),
                                                Text('Diuji oleh: ${item.namaPenguji}', style: TextStyle(fontSize: 14, color: Colors.grey[800])),
                                                const SizedBox(height: 4),
                                                Text(formatDateTime(item.waktu), style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                              ],
                                            ),
                                          ),
                                          const Icon(Icons.arrow_forward_ios, color: Colors.blue, size: 18),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
              ),
            ],
          );
        },
      ),
    );
  }

  String formatDateTime(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString).toLocal();
      const monthNames = ["Jan", "Feb", "Mar", "Apr", "Mei", "Jun", "Jul", "Agu", "Sep", "Okt", "Nov", "Des"];
      return '${dateTime.day} ${monthNames[dateTime.month - 1]} ${dateTime.year}, ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateTimeString;
    }
  }
}