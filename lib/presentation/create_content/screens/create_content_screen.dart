// lib/presentation/create_content/screens/create_travel_log_screen.dart

import 'package:flutter/material.dart';
import 'package:couple_log/core/constants/app_colors.dart';
import 'package:couple_log/core/constants/app_text_styles.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart'; // 이미지 선택을 위해 필요
import 'dart:io'; // File 클래스를 위해 필요

// 콘텐츠 블록 타입을 정의하는 Enum
enum ContentBlockType { text, image }

// 각 콘텐츠 블록의 데이터를 담을 클래스
class ContentBlock {
  ContentBlockType type;
  String? textContent; // 텍스트 블록용
  List<XFile>? imageFiles; // 이미지 블록용 (여러 장 가능)

  ContentBlock({required this.type, this.textContent, this.imageFiles});
}

class CreateTravelLogScreen extends StatefulWidget {
  const CreateTravelLogScreen({super.key});

  @override
  State<CreateTravelLogScreen> createState() => _CreateTravelLogScreenState();
}

class _CreateTravelLogScreenState extends State<CreateTravelLogScreen> {
  final TextEditingController _titleController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  final ImagePicker _picker = ImagePicker();

  // 콘텐츠 블록들을 담을 리스트
  final List<ContentBlock> _contentBlocks = [];

  @override
  void initState() {
    super.initState();
    // 초기에는 빈 텍스트 블록 하나를 추가하여 사용자가 바로 글을 쓸 수 있게 함
    _contentBlocks.add(ContentBlock(type: ContentBlockType.text, textContent: ''));
  }

  @override
  void dispose() {
    _titleController.dispose();
    for (var block in _contentBlocks) {
      if (block.type == ContentBlockType.text) {
        // 텍스트 컨트롤러가 있다면 여기서 dispose 해주어야 하지만,
        // 현재는 블록 내에서 TextFormFeild가 자체적으로 관리하므로 필요 없음.
      }
    }
    super.dispose();
  }

  // 날짜 선택기 띄우기
  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.warmRosePink, // 헤더 색상
              onPrimary: AppColors.white, // 헤더 텍스트 색상
              onSurface: AppColors.urbanGrey, // 날짜 텍스트 색상
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.warmRosePink, // 버튼 텍스트 색상
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && (picked.start != _startDate || picked.end != _endDate)) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  // 텍스트 블록 추가
  void _addTextBlock() {
    setState(() {
      _contentBlocks.add(ContentBlock(type: ContentBlockType.text, textContent: ''));
    });
    // 스크롤 맨 아래로 이동 (새 블록이 추가된 후 보일 수 있도록)
    _scrollToEnd();
  }

  // 이미지 블록 추가
  Future<void> _addImageBlock() async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        _contentBlocks.add(ContentBlock(type: ContentBlockType.image, imageFiles: pickedFiles));
      });
      _scrollToEnd();
    }
  }

  // 블록 삭제
  void _removeBlock(int index) {
    setState(() {
      _contentBlocks.removeAt(index);
    });
  }

  // 스크롤 맨 아래로 이동
  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  final ScrollController _scrollController = ScrollController(); // 스크롤 컨트롤러

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softCreamBeige,
      appBar: AppBar(
        title: Text(
          '새 여행 기록 작성',
          style: AppTextStyles.headerTitle.copyWith(fontSize: 22),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              // TODO: 여행 기록 저장 로직
              if (_titleController.text.isEmpty || _startDate == null || _endDate == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('제목과 여행 기간을 입력해주세요.')),
                );
                return;
              }
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('여행 기록 저장 (TODO)')),
              );
              Navigator.pop(context); // 저장 후 이전 화면으로 돌아가기
            },
            child: Text(
              '저장',
              style: AppTextStyles.buttonText.copyWith(color: AppColors.warmRosePink),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController, // 스크롤 컨트롤러 연결
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 여행 제목 입력 필드
                  Text(
                    '여행 제목',
                    style: AppTextStyles.inputLabel,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _titleController,
                    style: AppTextStyles.regularText,
                    decoration: InputDecoration(
                      hintText: '기억에 남을 여행의 제목을 입력해주세요',
                      hintStyle: AppTextStyles.smallText.copyWith(color: AppColors.lightGrey),
                      filled: true,
                      fillColor: AppColors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    maxLines: 1,
                  ),
                  const SizedBox(height: 25),

                  // 여행 기간 선택 필드
                  Text(
                    '여행 기간',
                    style: AppTextStyles.inputLabel,
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _selectDateRange(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.urbanGrey),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, size: 20, color: AppColors.lightGrey),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _startDate == null || _endDate == null
                                  ? '여행 시작일 ~ 여행 종료일'
                                  : '${_startDate!.toLocal().toString().split(' ')[0]} ~ ${_endDate!.toLocal().toString().split(' ')[0]}',
                              style: _startDate == null
                                  ? AppTextStyles.smallText.copyWith(color: AppColors.lightGrey)
                                  : AppTextStyles.regularText,
                            ),
                          ),
                          const Icon(Icons.arrow_drop_down, color: AppColors.lightGrey),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  Text(
                    '여행 기록',
                    style: AppTextStyles.inputLabel,
                  ),
                  const SizedBox(height: 15),

                  // 콘텐츠 블록 리스트
                  ListView.builder(
                    shrinkWrap: true, // 부모 Column의 크기에 맞춰 자식 리스트뷰 크기 조절
                    physics: const NeverScrollableScrollPhysics(), // 외부 SingleChildScrollView가 스크롤 관리
                    itemCount: _contentBlocks.length,
                    itemBuilder: (context, index) {
                      final block = _contentBlocks[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: _buildContentBlock(block, index),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          // 콘텐츠 추가 버튼 (하단 고정)
          _buildAddContentBar(context),
        ],
      ),
    );
  }

  Widget _buildContentBlock(ContentBlock block, int index) {
    Widget blockWidget;
    if (block.type == ContentBlockType.text) {
      blockWidget = _buildTextBlock(block, index);
    } else {
      blockWidget = _buildImageBlock(block, index);
    }

    return Stack(
      children: [
        blockWidget,
        // 삭제 버튼
        Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: () => _removeBlock(index),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(2),
              child: const Icon(Icons.close, color: AppColors.white, size: 18),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextBlock(ContentBlock block, int index) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.urbanGrey),
      ),
      child: TextFormField(
        initialValue: block.textContent, // 초기값 설정
        onChanged: (text) {
          block.textContent = text; // 블록 데이터 업데이트
        },
        style: AppTextStyles.regularText,
        decoration: InputDecoration(
          hintText: '여기에 글을 작성해주세요. (예: \'제주도에 도착했어요!\')',
          hintStyle: AppTextStyles.smallText.copyWith(color: AppColors.lightGrey),
          border: InputBorder.none, // 기본 밑줄 제거
          contentPadding: EdgeInsets.zero, // 내부 패딩 제거
          isDense: true, // 높이 조절
        ),
        keyboardType: TextInputType.multiline,
        maxLines: null, // 여러 줄 입력 가능
        minLines: 3, // 최소 3줄
      ),
    );
  }

  Widget _buildImageBlock(ContentBlock block, int index) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.urbanGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 선택된 이미지들 미리보기
          if (block.imageFiles != null && block.imageFiles!.isNotEmpty)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 한 줄에 3개 이미지
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: block.imageFiles!.length,
              itemBuilder: (context, imgIndex) {
                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(block.imageFiles![imgIndex].path),
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            block.imageFiles!.removeAt(imgIndex);
                            if (block.imageFiles!.isEmpty) {
                              _removeBlock(index); // 이미지가 없으면 블록 자체 삭제
                            }
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(2),
                          child: const Icon(Icons.delete_forever, color: AppColors.white, size: 16),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          if (block.imageFiles == null || block.imageFiles!.isEmpty)
            Center(
              child: Text(
                '사진이 없습니다.',
                style: AppTextStyles.smallText.copyWith(color: AppColors.lightGrey),
              ),
            ),
          const SizedBox(height: 10),
          // 새 사진 추가 버튼 (이 블록에 더 추가)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () async {
                final List<XFile>? pickedFiles = await _picker.pickMultiImage();
                if (pickedFiles != null && pickedFiles.isNotEmpty) {
                  setState(() {
                    block.imageFiles = (block.imageFiles ?? []) + pickedFiles;
                  });
                }
              },
              icon: const Icon(Icons.add_photo_alternate_outlined, size: 20, color: AppColors.mellowLavender),
              label: Text(
                '사진 추가',
                style: AppTextStyles.smallText.copyWith(color: AppColors.mellowLavender),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 하단 콘텐츠 추가 바
  Widget _buildAddContentBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea( // 하단 노치 영역 침범 방지
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildAddOptionButton(
              context,
              icon: Icons.notes,
              label: '텍스트',
              onTap: _addTextBlock,
            ),
            _buildAddOptionButton(
              context,
              icon: Icons.image,
              label: '사진',
              onTap: _addImageBlock,
            ),
            // TODO: 추후 위치 추가 기능이 필요하면 여기에 추가
            // _buildAddOptionButton(
            //   context,
            //   icon: Icons.location_on_outlined,
            //   label: '위치',
            //   onTap: () {
            //     ScaffoldMessenger.of(context).showSnackBar(
            //       const SnackBar(content: Text('위치 추가 (TODO)')),
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddOptionButton(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.warmRosePink, size: 28),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.smallText.copyWith(color: AppColors.warmRosePink, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}