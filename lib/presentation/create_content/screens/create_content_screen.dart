// JSON 인코딩/디코딩 필요 - 블로그 형식
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';

import 'package:couple_log/core/constants/app_colors.dart';
import 'package:couple_log/core/constants/app_text_styles.dart';
import 'package:image_picker/image_picker.dart';

class CreateTravelLogScreen extends StatefulWidget {
  const CreateTravelLogScreen({super.key});

  @override
  State<CreateTravelLogScreen> createState() => _CreateTravelLogScreenState();
}

class _CreateTravelLogScreenState extends State<CreateTravelLogScreen> {
  final QuillController _quillController = QuillController.basic();
  final TextEditingController _titleController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;

  final ImagePicker _picker = ImagePicker();

  // 에디터용 포커스 및 스크롤 노드
  final FocusNode _editorFocusNode = FocusNode();
  final ScrollController _editorScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // 입력/삽입 시 포커스 튐 방지
    _quillController.changes.listen((_) {
      if (!_editorFocusNode.hasFocus) {
        _editorFocusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _quillController.dispose();
    _titleController.dispose();
    _editorFocusNode.dispose();
    _editorScrollController.dispose();
    super.dispose();
  }

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
              primary: AppColors.warmRosePink,
              onPrimary: AppColors.white,
              onSurface: AppColors.urbanGrey,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.warmRosePink,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null &&
        (picked.start != _startDate || picked.end != _endDate)) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  void _saveTravelLog() {
    if (_titleController.text.isEmpty || _startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('제목과 여행 기간을 입력해주세요.')),
      );
      return;
    }

    // 현재는 이미지가 로컬 경로로 저장됩니다.
    final contentAsJson = _quillController.document.toDelta().toJson();
    final String contentString = jsonEncode(contentAsJson);

    print('저장할 여행 제목: ${_titleController.text}');
    print('저장할 여행 기간: $_startDate ~ $_endDate');
    print('백엔드로 전송할(또는 임시 저장할) JSON 데이터:\n$contentString');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('여행 기록 저장 완료! (실제 저장 로직은 TODO)')),
    );
    Navigator.pop(context);
  }

  /// 서버 없이: 갤러리에서 이미지 고르고 "로컬 경로"를 반환
  Future<String?> _pickLocalImagePath() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return null;
    return picked.path; // 예: /storage/emulated/0/...
  }

  Future<bool> _confirmExitIfEdited() async {
    final hasContent = _quillController.document.toPlainText().trim().isNotEmpty ||
        _titleController.text.trim().isNotEmpty;
    if (!hasContent) return true;

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('작성 취소'),
        content: const Text('작성 중인 내용을 취소하고 나갈까요?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('계속 작성')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('나가기')),
        ],
      ),
    );
    return ok ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope<Object?>(
      canPop: false, // 뒤로가기 제스처를 막고 우리가 직접 제어
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return; // 이미 pop 됐으면 아무 것도 안 함

        // 콜백은 sync여서, 비동기 확인 다이얼로그는 microtask로 분리
        Future<void>.microtask(() async {
          if (await _confirmExitIfEdited()) {
            if (context.mounted) Navigator.pop(context); // 확인 시 실제로 pop
          }
        });
      },
      child: Scaffold(
        backgroundColor: AppColors.softCreamBeige,
        appBar: AppBar(
          title: Text(
            '새 여행 기록 작성',
            style: AppTextStyles.headerTitle.copyWith(fontSize: 22),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () async {
              if (await _confirmExitIfEdited()) {
                if (context.mounted) Navigator.pop(context);
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: _saveTravelLog,
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
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('여행 제목', style: AppTextStyles.inputLabel),
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
                        contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                      maxLines: 1,
                    ),
                    const SizedBox(height: 25),
                    Text('여행 기간', style: AppTextStyles.inputLabel),
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
                            const Icon(Icons.calendar_today,
                                size: 20, color: AppColors.lightGrey),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _startDate == null || _endDate == null
                                    ? '여행 시작일 ~ 여행 종료일'
                                    : '${_startDate!.toLocal().toString().split(' ')[0]} ~ ${_endDate!.toLocal().toString().split(' ')[0]}',
                                style: _startDate == null
                                    ? AppTextStyles.smallText
                                    .copyWith(color: AppColors.lightGrey)
                                    : AppTextStyles.regularText,
                              ),
                            ),
                            const Icon(Icons.arrow_drop_down, color: AppColors.lightGrey),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Text('여행 기록', style: AppTextStyles.inputLabel),
                    const SizedBox(height: 15),

                    // ✅ Toolbar: 서버 없이 로컬 경로 삽입 (deprecated 제거/이름 수정 반영)
                    QuillSimpleToolbar(
                      controller: _quillController,
                      config: QuillSimpleToolbarConfig(
                        multiRowsDisplay: true,
                        showFontFamily: false,
                        showFontSize: false,
                        showBoldButton: true,
                        showItalicButton: true,
                        //showUnderlineButton: false, // ← 이름 수정 (showUnderLineButton X)
                        showStrikeThrough: false,
                        showSmallButton: false,
                        showInlineCode: false,
                        showColorButton: false,
                        showBackgroundColorButton: false,
                        showClearFormat: false,
                        showAlignmentButtons: false,
                        showHeaderStyle: false,
                        showListNumbers: false,
                        showListBullets: false,
                        showListCheck: false,
                        showCodeBlock: false,
                        showQuote: false,
                        showIndent: false,
                        showLink: false,
                        showUndo: false,
                        showRedo: false,
                        showSearchButton: false,
                        showSubscript: false,
                        showSuperscript: false,
                        // showClipboardCut/Copy/Paste → 제거 (deprecated/미지원)
                        embedButtons: FlutterQuillEmbeds.toolbarButtons(
                          imageButtonOptions: QuillToolbarImageButtonOptions(
                            imageButtonConfig: QuillToolbarImageConfig(
                              onRequestPickImage: (context) async {
                                final path = await _pickLocalImagePath();
                                return path; // null이면 삽입 취소
                              },
                              onImageInsertCallback: (imagePath, controller) async {
                                if (imagePath.isEmpty) return;

                                // 현재 커서 위치에 이미지 블록 삽입
                                final index = controller.selection.baseOffset;
                                controller.replaceText(
                                  index,
                                  0,
                                  BlockEmbed.image(imagePath),                         // ✅ 새 방식
                                  TextSelection.collapsed(offset: index + 1),          // 커서를 이미지 뒤로 이동
                                );

                                // 포커스 튐 방지
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  _editorFocusNode.requestFocus();
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // ✅ Editor: 로컬 파일 경로도 보이도록 imageProviderBuilder 유지
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.urbanGrey),
                        ),
                        child: QuillEditor(
                          controller: _quillController,
                          focusNode: _editorFocusNode,
                          scrollController: _editorScrollController,
                          config: QuillEditorConfig(
                            placeholder: "여행 내용을 입력하세요 . . .",
                            padding: EdgeInsets.zero,
                            autoFocus: true,
                            embedBuilders: [
                              ...FlutterQuillEmbeds.editorBuilders(
                                imageEmbedConfig: QuillEditorImageEmbedConfig(
                                  imageProviderBuilder: (context, url) {
                                    if (url.startsWith('http')) {
                                      return NetworkImage(url);
                                    }
                                    return FileImage(File(url));
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
