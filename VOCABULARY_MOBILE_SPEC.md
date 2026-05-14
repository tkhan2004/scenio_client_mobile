# SCENIO MOBILE: VOCABULARY FEATURE SPEC
**Tài liệu Đặc tả Triển khai Frontend (Máy Khách Flutter/GetX)**

Tài liệu này đóng vai trò kim chỉ nam (Blueprint) cho việc code UI và Logic tính năng "Từ vựng theo Ngữ cảnh" (Context-based Decks) trên ứng dụng Scenio Mobile.

---

## 1. MỞ RỘNG KIẾN TRÚC GETX (MODULE ARCHITECTURE)

Feature này sẽ được triển khai như một Module độc lập, có thể cắm trực tiếp thành 1 Tab chính trên trang chủ.

### Cấu trúc Thư mục (Directory Structure):
```text
lib/app/
 ├── data/
 │    ├── models/
 │    │    ├── vocab_deck_model.dart      // Model cho "Cuốn sổ/Session"
 │    │    └── vocab_card_model.dart      // Model cho Từng thẻ chữ
 │    └── providers/
 │         └── vocab_provider.dart        // Chứa HTTP requests tới API API
 ├── domain/
 │    └── repositories/
 │         └── vocab_repository.dart      // Giao tiếp với Provider
 ├── modules/
 │    └── vocabulary/
 │         ├── vocabulary_binding.dart    // Khởi tạo Dependency Injection
 │         ├── vocabulary_viewmodel.dart  // Chứa Logic Quản lý State
 │         ├── vocabulary_view.dart       // Giao diện gốc (Tab Từ Vựng)
 │         └── widgets/
 │              ├── vocab_deck_card.dart  // Khối hộp (Folder) ngoài View chính
 │              └── vocab_flashcard_stage.dart // Màn hình Lật thẻ (Flip Card)
```

---

## 2. TRIỂN KHAI GIAO DIỆN (UI/UX IMPLEMENTATION)

Tính năng này chia làm 2 tầng màn hình chính:

### View 1: Kho Từ Vựng (Vault / My Decks)
**Là gì**: Màn hình khi người dùng ấn vào Tab "Trạm từ vựng" (Tách từ Profile cũ).
**Chi tiết UI**:
- **Header**: Bảng thống kê mini bám dính (Sticky Header) gồm tổng số từ đã thuộc toàn hệ thống (Total Mastered).
- **Body**: Một `GridView` hoặc `ListView` cuộn dọc chứa các `VocabDeckCard`.
- **VocabDeckCard Design**:
  - Dạng Folder hình chữ nhật góc bo tròn `AppDimensions.radiusXl`.
  - Gradient Material Soft Glass.
  - Tên: Tên Chủ đề đã tạo (VD: "Trò chuyện tại Quầy Cafe mùng 8/3").
  - Tiến độ (ProgressBar): Một thanh ngang chạy hiển thị `% Mastered` (VD: 3/5 Từ). Báo Done khi 100%.

### View 2: Trạm Ôn Tập (Flashcard Stage - Modal / Screen phụ)
**Là gì**: Khi bấm vào một Deck ở View 1, nó Pop-up màn hình này. Màn hình rèn luyện tập trung (Full Screen) với Background Dim (Tối màu) giúp User focus.
**Chi tiết UI**:
- **Khung thẻ (Card Flipper)**: Sử dụng package `flip_card` hoặc `Transform` ma trận 3D của Flutter.
  - **Mặt Trước (Front)**: 
    - Hiển thị từ vựng tiếng Anh to bự `AppTextStyles.h1`.
    - Nút chức năng: *Icon Loa (Phát âm chuẩn)*, *Nút Xem Gợi ý (Show Sample Sentence)*.
  - **Mặt Sau (Back - Bấm để lật)**:
    - Nghĩa Tiếng Việt, Từ loại.
    - Câu ví dụ chứa từ vựng được trích nguyên si từ lịch sử hội thoại có Highlight từ đó.
- **Thanh Hành Động (Action Bar) đáy màn hình**:
  - Chỉ hiện ra sau khi lật thẻ. 
  - Nút Vàng Trái: `Chưa thuộc / Hard` (Vuốt thẻ về đầu list để tí học lại).
  - Nút Xanh Phải (Big CTA): `ĐÃ THUỘC / DONE` (Card bay lên vỡ thành hoa tiêu, update Data + 1 Mastered).

---

## 3. LOGIC APP (STATE MANAGEMENT VỚI GETX)

Để trải nghiệm mượt "Không Loading" (Optimistic UI), ViewModel sử dụng kỹ thuật sau:

### 3.1. Phân mảnh Data (State Variables)
Trong `VocabularyViewModel`:
```dart
final RxList<VocabDeckModel> decks = <VocabDeckModel>[].obs;
final RxList<VocabCardModel> activeCards = <VocabCardModel>[].obs; // Thẻ đang học trong Session popup
final RxBool isLoadingDecks = false.obs;
```

### 3.2. Chạm là đổi (Optimistic Update cho việc Tích Done)
Khi User bấm nút "Done" trên 1 thẻ:
1. Giao diện (Thẻ vừa học) hiệu ứng tự động Flip và văng ra ngoài danh sách `activeCards` (Xử lý ngay lập tức trên RAM điện thoại cho tốc độ < 16ms).
2. Gọi hàm `repository.markWordAsDone(wordId)` ngầm qua Thread phụ lên Backend.
3. Update con số ProgressBar ở Màn hình Decks.
*(Vì mạng có thể lag rớt mạng, ta làm UI bay biến mất luôn, nếu Backend thất bại mới hiện `ScenioAlert.showError` và nhả thẻ về lại list cũ, giống hệt Tinder).*

### 3.3. Text To Speech (Phát âm từ vựng)
Sử dụng thư viện phổ thông `flutter_tts` dành cho Frontend:
- Chạy offline mượt mà không cần API Backend tốn tiền API.
- Cấu hình chuẩn Mỹ: `flutterTts.setLanguage("en-US");`
- Khi lật bài, ứng dụng tự động đọc to từ vựng đó luôn giúp người học quen rãnh âm thanh.

---

## 4. TÍCH HỢP VÀO NAVBAR TỔNG (NAVIGATOR 2.0)

Cách để đẩy Tab này ra hệ thống menu gốc:
1. Sửa `home_pill_nav_bar.dart` từ 4 Item thành 5 Item cấu trúc tỷ lệ chia đều ngang (Flex = 1) hoặc có Scroll tùy theo màn nhỏ.
2. Icon đại diện: `Icons.style_rounded` (Icon tệp flashcard) hoặc `Icons.layers_rounded`.
3. Add `VocabularyView()` vào Index thứ 2 (Nằm giữa Scene và Practice) trong `IndexedStack` của `home_view.dart`.

---

## 5. DÀNH CHO TIẾN ĐỘ THI CÔNG DEVS: Các chặng (Phases)
- **Phase 1**: Dựng tĩnh UI `VocabularyView` (Có Data ảo fake lists). Gắn thẻ Flashcard giả để test animation Lật 3D.
- **Phase 2**: Sửa `ProfileSection` cắt bỏ Sổ Từ Vựng. Biến Tab 5 vào Bottom Nav Bar. Liên kết Data cứng.
- **Phase 3**: Đấu Backend API. Kết hợp logic TTS (Đọc phát âm) và Test thuật toán Optimistic UI khi "Tích Done".
