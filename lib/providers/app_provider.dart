// lib/providers/app_provider.dart

import 'dart:io';
import 'package:flutter/material.dart';
import '../api/api_service.dart';
import '../models/prediction_result.dart';

class AppProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  PredictionResult? _predictionResult;
  String? _errorMessage;
  File? _selectedImage;

  bool get isLoading => _isLoading;
  PredictionResult? get predictionResult => _predictionResult;
  String? get errorMessage => _errorMessage;
  File? get selectedImage => _selectedImage;

  void setSelectedImage(File? image) {
    _selectedImage = image;
    _predictionResult = null; // Reset hasil jika gambar baru dipilih
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> getPrediction() async {
    if (_selectedImage == null) {
      _errorMessage = "Pilih gambar terlebih dahulu.";
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    _predictionResult = null;
    notifyListeners();

    try {
      _predictionResult = await _apiService.uploadImage(_selectedImage!);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}