# Mobile Backend Mapping Status

Tài liệu này chốt trạng thái mapping giữa `scenio_client_mobile` và `scenio_be` tại thời điểm hiện tại, để team mobile biết:

- màn nào đã nối backend thật
- màn nào vẫn đang dùng mock / fallback
- flow nào có thể ghép để test client ngay bây giờ

---

## 1. Flow đã nối backend thật

### 1.1 App bootstrap

- `Splash`
  - kiểm tra `hasSeenOnboarding`
  - kiểm tra có session token trong local storage hay chưa
- `Onboarding`
  - đánh dấu đã xem onboarding
- `Auth`
  - `POST /api/auth/login`
  - `POST /api/auth/register`
  - `POST /api/auth/google`

### 1.2 Home / Scenes

- `Home Dashboard`
  - `GET /api/home/dashboard`
- `Scenes Library`
  - `GET /api/scenes`
- `Scene Detail`
  - `GET /api/scenes/:id`

### 1.3 Practice Flow

- `Start Session`
  - `POST /api/sessions/start`
- `Start Custom Practice`
  - `POST /api/sessions/start-custom`
- `Sync transcript`
  - `POST /api/sessions/:id/message`
- `Request hint`
  - `POST /api/sessions/:id/hint`
- `Complete session`
  - `POST /api/sessions/:id/complete`
- `Session result`
  - `GET /api/sessions/:id/result`
- `Abandon session`
  - `PATCH /api/sessions/:id/abandon`

---

## 2. Flow client có thể test ngay

Đây là vertical slice hiện đã có thể ghép vào UI để test:

1. mở app
2. đi qua `Splash -> Onboarding -> Auth`
3. login bằng user test
4. vào `Home`
5. mở `Scenes`
6. vào `Scene Detail`
7. bấm `Start`
8. vào `Practice`
9. gửi vài lượt transcript
10. bấm `Finish`
11. xem `Session Result`

Hoặc:

1. vào tab `Practice`
2. bấm `Create your own practice`
3. chọn preset hoặc điền form
4. bấm `Start custom practice`
5. vào thẳng `Practice`
6. gửi vài lượt transcript
7. bấm `Finish`
8. xem `Session Result`

---

## 3. Những gì đang dùng fallback có chủ đích

### 3.1 AI reply realtime trong màn chat

Hiện mobile **đã sync transcript thật lên backend**, nhưng UI chat hiện tại **chưa gắn WebRTC / realtime voice provider**.

Vì vậy:

- message `USER_TEXT` được gửi thật lên backend
- một AI reply placeholder được tạo local để giữ nhịp test UI
- AI placeholder đó cũng được sync ngược về backend bằng `AI_TEXT`

Ý nghĩa:

- team mobile vẫn test được flow màn hình
- backend vẫn có transcript đủ hai phía để complete/result
- nhưng đây **chưa phải** live conversation engine cuối cùng

### 3.2 Resume active session sau khi mở app lại

Backend có trả `inProgressSession` trên home, nhưng payload dashboard hiện chưa đủ transcript của session đang ACTIVE.

Vì vậy mobile đang xử lý theo kiểu an toàn:

- cố gắng khớp lại scene theo title
- nếu khớp được thì dựng lại session local
- transcript được seed bằng một AI placeholder để user có thể bước vào màn practice

Điều này đủ để test flow, nhưng chưa phải resume thật 100%.

### 3.3 Profile

UI `Profile` hiện **chưa được refactor sang backend thật trong lượt này**.

- `Profile`: vẫn chủ yếu là mock data

Lý do:

- ưu tiên vertical slice test client flow trước
- tránh mở rộng scope quá rộng trong một lượt

---

## 4. Những phần chưa nối ở mobile

Các phần backend đã có hoặc đang có foundation, nhưng mobile vẫn chưa ghép trong lượt này:

- `POST /api/sessions/:id/realtime-token`
- voice selection picker
- realtime audio / WebRTC session
- profile progress thật
- badges thật
- vocabulary deck backend thật ✅

---

## 5. File mobile đã chạm chính

### Core

- `lib/main.dart`
- `lib/app/app_binding.dart`
- `lib/app/core/storage/storage_service.dart`
- `lib/app/core/network/api_client.dart`
- `lib/app/core/network/api_endpoints.dart`
- `lib/app/core/network/api_response.dart`

### Data layer

- `lib/app/data/providers/auth_provider.dart`
- `lib/app/data/providers/learning_provider.dart`
- `lib/app/data/repositories/auth_repository_impl.dart`
- `lib/app/data/repositories/learning_repository_impl.dart`
- `lib/app/data/models/auth_session_model.dart`
- `lib/app/data/models/home_dashboard_model.dart`
- `lib/app/data/models/scene_api_model.dart`
- `lib/app/data/models/custom_practice_model.dart`
- `lib/app/data/models/session_flow_model.dart`

### Domain

- `lib/app/domain/repositories/auth_repository.dart`
- `lib/app/domain/repositories/learning_repository.dart`
- `lib/app/domain/entities/user_entity.dart`
- `lib/app/domain/entities/scene_entity.dart`

### ViewModel / feature wiring

- `lib/app/modules/splash/splash_viewmodel.dart`
- `lib/app/modules/onboarding/onboarding_viewmodel.dart`
- `lib/app/modules/auth/auth_viewmodel.dart`
- `lib/app/modules/home/home_viewmodel.dart`
- `lib/app/modules/custom_practice/custom_practice_view.dart`
- `lib/app/modules/custom_practice/custom_practice_viewmodel.dart`
- `lib/app/modules/scene_detail/scene_detail_viewmodel.dart`
- `lib/app/modules/chat/chat_viewmodel.dart`

---

## 6. Cách chạy để test backend thật

### Base URL mặc định

Mobile hiện dùng:

```text
http://localhost:3000/api
```

Bạn có thể override bằng `dart-define`:

```bash
flutter run --dart-define=SCENIO_API_BASE_URL=http://localhost:3000/api
```

Nếu chạy Android emulator, thường sẽ cần đổi sang:

```text
http://10.0.2.2:3000/api
```

Ví dụ:

```bash
flutter run --dart-define=SCENIO_API_BASE_URL=http://10.0.2.2:3000/api
```

### User test seed

Nếu backend đã seed dữ liệu:

```text
Email: learner@scenio.dev
Password: 123456
```

---

## 7. Bước nên làm tiếp

Nếu tiếp tục theo đúng scope hiện tại, thứ tự hợp lý là:

1. nối `Profile` sang `users/me + users/progress + users/badges`
2. nối `Vocabulary` sang backend thật
3. thay AI placeholder trong `Practice` bằng realtime voice flow thật
4. nối voice selection picker + realtime token

---

## 8. Kết luận ngắn

Hiện tại mobile **đã đủ để test client flow chính với backend thật** cho phần:

- auth
- home
- scenes
- scene detail
- start practice
- transcript sync
- complete
- result

Phần `Practice` hiện đang là **hybrid**:

- backend là nguồn sự thật cho session / transcript / complete / result
- AI reply trong lúc chat vẫn là fallback local để giữ nhịp UI test

Đây là trạng thái hợp lý để team mobile bắt đầu test end-to-end mà chưa cần chờ realtime voice hoàn thiện.
