// lib/core/constants/app_text_styles.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:couple_log/core/constants/app_colors.dart';

class AppTextStyles {
  static final TextStyle headerTitle = GoogleFonts.notoSansKr(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.urbanGrey,
  );

  static final TextStyle inputLabel = GoogleFonts.notoSansKr(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.urbanGrey,
  );

  static final TextStyle inputPlaceholder = GoogleFonts.notoSansKr(
    fontSize: 16,
    color: AppColors.lightGrey,
  );

  static final TextStyle buttonText = GoogleFonts.notoSansKr(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static final TextStyle linkText = GoogleFonts.notoSansKr(
    fontSize: 16,
    color: AppColors.urbanGrey,
  );

  static final TextStyle errorText = GoogleFonts.notoSansKr(
    fontSize: 14,
    color: Colors.redAccent,
  );

  static final TextStyle smallText = GoogleFonts.notoSansKr(
    fontSize: 14,
    color: AppColors.urbanGrey.withOpacity(0.8),
  );

  static final TextStyle regularText = GoogleFonts.notoSansKr(
    fontSize: 16,
    color: AppColors.urbanGrey,

  );
}