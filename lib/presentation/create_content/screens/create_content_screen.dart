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

    // ⚠️ 지금은 이미지가 로컬 경로로 저장됩니다.
    // 나중에 서버 업로드를 붙일 땐, Delta를 순회하며 로컬 경로 -> 서버 URL로 치환하면 됩니다.
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
    // 내용이 비어있지 않다면 확인 다이얼로그
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
    return WillPopScope(
      onWillPop: _confirmExitIfEdited,
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
                // 취소(나가기)
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
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                    const Icon(Icons.arrow_drop_down,
                        color: AppColors.lightGrey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
            Text('여행 기록', style: AppTextStyles.inputLabel),
            const SizedBox(height: 15),

            // ✅ Toolbar: 서버 없이 로컬 경로 삽입
            QuillSimpleToolbar(
              config: QuillSimpleToolbarConfig(
                multiRowsDisplay: true,
                showFontFamily: false, // 폰트 패밀리 버튼
                showFontSize: false, // 폰트 크기 버튼
                showBoldButton: true, // 볼드 버튼
                showItalicButton: true, // 이탤릭 버튼
                showUnderLineButton: true, // 밑줄 버튼
                showStrikeThrough: true, // 취소선 버튼
                showSmallButton: false, // 작은 글씨 버튼
                showInlineCode: false, // 인라인 코드 버튼
                showColorButton: true, // 색상 버튼
                showBackgroundColorButton: false, // 배경색 버튼
                showClearFormat: false, // 포맷 지우기 버튼
                showAlignmentButtons: false, // 정렬 버튼
                showHeaderStyle: false, // 헤더 스타일 버튼
                showListNumbers: false, // 숫자 목록 버튼
                showListBullets: false, // 점 목록 버튼
                showListCheck: false, // 체크리스트 버튼
                showCodeBlock: false, // 코드 블록 버튼
                showQuote: false, // 인용문 버튼
                showIndent: false, // 들여쓰기/내어쓰기 버튼
                showLink: false, // 링크 버튼
                showUndo: false, // 실행 취소 버튼
                showRedo: false, // 다시 실행 버튼
                showSearchButton: false, // 검색 버튼
                showSubscript: false, // 아래첨자
                showSuperscript: false, // 위첨자
                showClipboardCut: false, // 잘라내기
                showClipboardCopy: false, // 복사
                showClipboardPaste: false, // 붙여넣기
                embedButtons: FlutterQuillEmbeds.toolbarButtons(
                  imageButtonOptions: QuillToolbarImageButtonOptions(
                    imageButtonConfig: QuillToolbarImageConfig(
                      // 1) 갤러리에서 선택 → "로컬 경로" 반환
                      onRequestPickImage: (context) async {
                        final path = await _pickLocalImagePath();
                        return path; // null이면 삽입 취소
                      },
                      // 2) 반환된 "로컬 경로"를 문서에 삽입
                      onImageInsertCallback: (imagePath, controller) async {
                        if (imagePath.isEmpty) return;
                        controller.insertImageBlock(
                          imageSource: imagePath,
                        );
                        // 삽입 직후 포커스 복구
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _editorFocusNode.requestFocus();
                        });
                      },
                    ),
                  ),
                ),
              ),
              controller: _quillController,
            ),

            const SizedBox(height: 10),

            // ✅ Editor: 로컬 파일 경로도 보이도록 imageProviderBuilder 설정
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
                    // [fix] 이미지 삽입 시 레이아웃 안저성 필요
                    autoFocus: true,
                    scrollable: true,
                    expands: false,
                    embedBuilders: [
                      ...FlutterQuillEmbeds.editorBuilders(
                        imageEmbedConfig: QuillEditorImageEmbedConfig(
                          // 로컬 경로/네트워크 URL 모두 지원
                          imageProviderBuilder: (context, url) {
                            if (url.startsWith('http') || url.startsWith('https')) {
                              return NetworkImage(url);
                            }
                            // file:// 형태가 아니더라도 FileImage에 경로 전달 가능
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
