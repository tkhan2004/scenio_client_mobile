# Scenio Mobile - Backend Endpoint Mapping Spec

Tài liệu này dành cho agent/team mobile khi nối `scenio_client_mobile` với `scenio_be` sau các cập nhật backend mới: Google login, learning plan, pgvector recommendation, session evaluator, correction feedback, vocabulary loop và voice foundation.

Mục tiêu UI không chỉ là chat với AI. Mobile cần trình bày Scenio như một app học tập có vòng lặp rõ ràng:

```text
Onboarding / Level Test
  -> Learning Plan
  -> Scene / Custom Practice
  -> Session Result
  -> Corrections
  -> Vocabulary / Next Step
```

Base URL local:

```text
http://localhost:3000/api
```

Android emulator thường dùng:

```text
http://10.0.2.2:3000/api
```

Tất cả endpoint trừ auth public cần header:

```http
Authorization: Bearer <accessToken>
```

Response wrapper chuẩn:

```json
{
  "success": true,
  "status": 200,
  "timestamp": "2026-05-12T00:00:00.000Z",
  "data": {}
}
```

---

## 1. Priority Map Cho Mobile

### P0 - Cần làm để app demo học tập trọn vẹn

| Feature | Endpoint | Mobile cần map |
|---|---|---|
| Auth email | `POST /auth/login`, `POST /auth/register`, `POST /auth/refresh`, `POST /auth/logout`, `GET /auth/verify-token` | Auth provider/repository đã có, kiểm tra lại token refresh và logout |
| Google login | `POST /auth/google` | Google Sign-In SDK lấy `idToken`, gửi BE, lưu Scenio tokens |
| Home | `GET /home/dashboard` | Home data tổng quan, mission, recommended scenes, in-progress session |
| Learning plan | `GET /learning-plan/current` | Home next step card + màn Learning Plan |
| Scene list/detail | `GET /scenes`, `GET /scenes/:id` | Explore/list/detail, start session |
| Session start/chat | `POST /sessions/start`, `POST /sessions/:id/message` | Start scene, sync finalized transcript/text |
| Session complete/result | `POST /sessions/:id/complete`, `GET /sessions/:id/result` | Điểm, correction từng câu, next learning action |
| Vocabulary decks | `GET /vocabulary/decks`, `GET /vocabulary/decks/:sessionId`, `POST /vocabulary/:id/review` | Ôn từ theo session |

### P1 - Làm sau P0 để đúng concept cá nhân hóa

| Feature | Endpoint | Mobile cần map |
|---|---|---|
| Semantic search | `GET /scenes/search?q=&limit=` | Search dùng BE thay vì filter local |
| Recommend scenes | `GET /scenes/recommend?limit=` | Section gợi ý theo weak skill/vector |
| Refresh plan | `POST /learning-plan/refresh` | User bấm tạo lại lộ trình |
| Complete step | `PATCH /learning-plan/steps/:id/complete` | Manual complete nếu step không đi qua session |
| Level test | `POST /sessions/level-test` | Màn test 5 lượt trước/ sau onboarding |
| User progress | `GET /users/progress`, `GET /users/badges` | Profile dùng dữ liệu thật thay mock |
| User profile | `GET /users/me`, `PATCH /users/me`, `PATCH /users/me/onboarding` | Profile edit + onboarding survey |

### P2 - Voice/realtime foundation

| Feature | Endpoint | Mobile cần map |
|---|---|---|
| Scene voice picker | `GET /scenes/:id/voices` | Quick pick voice trước khi start voice session |
| Realtime token | `POST /sessions/:id/realtime-token` | Mint token để client nối WebRTC/realtime |
| Voice catalog | `GET /voices`, `GET /voices/:id`, `POST /voices/preview` | Voice settings / preview nếu có màn riêng |

---

## 2. Concept UI Theo Backend Flow

### 2.1 First launch / onboarding

Mobile cần phân biệt:

- `needsOnboarding = true`: đưa user qua survey thói quen, mục tiêu, level tự đánh giá.
- `needsLevelTest = true`: đưa user qua level test hoặc cho skip nếu UX cần.
- Sau onboarding/level test, gọi `GET /learning-plan/current` để backend tự tạo lộ trình.

Endpoint:

```http
PATCH /api/users/me/onboarding
POST /api/sessions/level-test
GET /api/learning-plan/current
```

Concept trình bày:

- Không chỉ hỏi thông tin cho vui. Sau khi hoàn tất, UI phải nói được: app đã tạo `Learning Plan` dựa trên mục tiêu, trình độ và thói quen.
- Nếu chưa làm level test, vẫn dùng onboarding/self-assessment để tạo plan fallback.

### 2.2 Home screen

Khi vào Home, mobile nên gọi song song:

```http
GET /api/home/dashboard
GET /api/learning-plan/current
```

Home nên có các block:

- Greeting + level/streak/xp từ dashboard.
- Daily missions từ dashboard.
- Continue session nếu có `inProgressSession`.
- `Your Learning Plan` card từ `/learning-plan/current`.
- `Recommended for you` từ `/scenes/recommend` nếu đã map P1.

Learning Plan card hiển thị:

- `plan.title`
- `plan.summary`
- focus chip: `plan.focusSkill`
- progress: completed steps / total steps
- CTA:
  - có `nextStep.sceneId`: mở scene detail hoặc start practice
  - không có next step: `Refresh plan`

### 2.3 Learning Plan screen

Endpoint chính:

```http
GET /api/learning-plan/current
```

Action:

```http
POST /api/learning-plan/refresh
PATCH /api/learning-plan/steps/:id/complete
```

Concept trình bày:

- Đây là màn "lộ trình học", không phải danh sách scene thường.
- Render timeline/list step theo `sortOrder`.
- `NEXT`: nổi bật, CTA chính.
- `IN_PROGRESS`: đang học.
- `COMPLETED`: tick xanh.
- `LOCKED`: mờ/khóa.
- `SKIPPED`: nhẹ hơn completed, nếu có.

Step card nên có:

- `title`
- `description`
- `focusSkill`
- `reason`
- scene mini info: title/category/difficulty/estimatedMinutes
- metadata debug chỉ hiện dev mode, không show cho user thường.

### 2.4 Scene search / discovery

Endpoint hiện nên dùng:

```http
GET /api/scenes/search?q=airport&limit=10
```

Không nên chỉ filter local trong mobile nữa, vì BE đã có semantic search bằng pgvector và fallback text.

Mobile map thêm field scene:

```json
{
  "retrievalMode": "VECTOR",
  "similarity": 0.86,
  "matchReason": "Matched semantically by pgvector"
}
```

Concept trình bày:

- User không cần thấy chữ `VECTOR`.
- Có thể hiển thị `matchReason` dạng subtitle ngắn nếu thân thiện.
- Nếu `retrievalMode = TEXT_FALLBACK`, vẫn render như kết quả bình thường.
- Nếu `similarity` null thì không show similarity.

### 2.5 Recommended scenes

Endpoint:

```http
GET /api/scenes/recommend?limit=5
```

Response có cấp top-level:

```json
{
  "retrievalMode": "HYBRID_VECTOR",
  "focusSkill": "VOCABULARY",
  "scenes": []
}
```

Mỗi scene có thể có:

```json
{
  "retrievalMode": "HYBRID_VECTOR",
  "focusSkill": "VOCABULARY",
  "score": 0.78,
  "matchReason": "Recommended from weak skill, level fit, and vector similarity"
}
```

Concept trình bày section theo `focusSkill`:

| focusSkill | UI title gợi ý |
|---|---|
| `GRAMMAR` | Practice clearer sentences |
| `VOCABULARY` | Build useful phrases |
| `NATURALNESS` | Sound more natural |
| `CONFIDENCE` | Build speaking confidence |

### 2.6 Practice session

Start curated scene:

```http
POST /api/sessions/start
```

Body:

```json
{
  "sceneId": "uuid",
  "voiceProfileId": "uuid",
  "modality": "TEXT"
}
```

Start custom practice:

```http
POST /api/sessions/start-custom
```

Sau khi start, BE trả `sessionId`, `openingMessage`, `selectedVoice` nếu có.

Sync message:

```http
POST /api/sessions/:id/message
```

Body text:

```json
{
  "source": "USER_TEXT",
  "content": "I go to Paris yesterday",
  "isFinal": true
}
```

Body voice transcript:

```json
{
  "source": "USER_AUDIO",
  "content": "I need check in one bag",
  "isFinal": true,
  "providerEventId": "provider_event_id",
  "audioStartMs": 1200,
  "audioEndMs": 4200
}
```

Important concept:

- Endpoint `/sessions/:id/message` hiện là transcript sync endpoint.
- BE chưa generate AI reply theo từng turn qua endpoint này.
- Nếu mobile text chat đang dùng local AI placeholder, cần ghi rõ đó là placeholder cho demo UI.
- Với voice/realtime sau này, AI reply đến từ realtime provider, mobile chỉ sync final transcript về BE.

Hint:

```http
POST /api/sessions/:id/hint
```

Complete:

```http
POST /api/sessions/:id/complete
```

Abandon:

```http
PATCH /api/sessions/:id/abandon
```

### 2.7 Session result / correction

Sau khi complete:

```http
GET /api/sessions/:id/result
```

Mobile bắt buộc map các field học tập trong `messages[]`, nhất là message `role = USER`:

```json
{
  "id": "uuid",
  "role": "USER",
  "content": "I go to Paris yesterday",
  "turnIndex": 2,
  "hasError": true,
  "errorType": "GRAMMAR",
  "originalPhrase": "I go to Paris yesterday",
  "suggestion": "I went to Paris yesterday",
  "explanation": "Sai thì quá khứ. Với yesterday, dùng went thay vì go.",
  "isGood": false,
  "feedbackDetails": {
    "issues": [
      {
        "type": "GRAMMAR",
        "subtype": "TENSE",
        "originalPhrase": "go",
        "suggestion": "went",
        "explanation": "Use past tense with yesterday."
      }
    ]
  }
}
```

Concept trình bày:

- Result overview: điểm grammar/vocabulary/naturalness + XP.
- Transcript corrections: từng câu user nói/nhập.
- Correction detail: câu gốc, cụm sai, câu gợi ý, giải thích.
- Good sentence: hiện badge tốt để user thấy câu đúng, không chỉ thấy lỗi.
- Next learning action: dùng field BE trả về nếu có, fallback tự suy từ skill thấp nhất.

Rule render:

| BE field | Mobile display |
|---|---|
| `scores.grammar` | Grammar score card |
| `scores.vocabulary` | Vocabulary score card |
| `scores.naturalness` | Naturalness score card |
| `xpEarned` | XP earned |
| `messages[].hasError` | Có correction card |
| `messages[].errorType` | Badge/màu lỗi |
| `messages[].originalPhrase` | Cụm/câu gốc cần sửa |
| `messages[].suggestion` | Câu/cụm nên dùng |
| `messages[].explanation` | Giải thích ngắn |
| `messages[].feedbackDetails.issues` | Danh sách lỗi chi tiết |
| `spokenCoaching` | Panel coaching tổng hợp |
| `nextLearningAction` | CTA học tiếp |

Sau result, mobile nên gọi lại:

```http
GET /api/learning-plan/current
```

Lý do: backend có thể đã cập nhật progress/next step sau khi session complete.

### 2.8 Vocabulary learning

Endpoints:

```http
GET /api/vocabulary
GET /api/vocabulary/decks
GET /api/vocabulary/decks/:sessionId
POST /api/vocabulary
POST /api/vocabulary/:id/review
DELETE /api/vocabulary/:id
```

Concept trình bày:

- Vocabulary không chỉ là danh sách từ. Nên gắn với session/correction.
- Từ session result, nếu `errorType = VOCABULARY`, có thể show CTA `Save phrase`.
- Vocabulary tab nên ưu tiên decks theo session để user ôn lại sau từng buổi học.

### 2.9 Profile / progress

Endpoints:

```http
GET /api/users/me
PATCH /api/users/me
GET /api/users/progress
GET /api/users/badges
```

Concept trình bày:

- Profile không nên còn mock nếu đã báo cáo luận văn.
- Dùng progress thật: XP, streak, skill chart, recent sessions.
- Badges lấy từ backend.
- Nếu cần lịch sử session đầy đủ, hiện backend chưa có endpoint learner paginated riêng; tạm dùng progress recent history nếu có hoặc đề xuất BE thêm `GET /sessions/history`.

---

## 3. Endpoint Contract Summary

### Auth

```http
POST /api/auth/register
POST /api/auth/login
POST /api/auth/google
POST /api/auth/refresh
POST /api/auth/logout
GET  /api/auth/verify-token
```

Google login body:

```json
{
  "idToken": "google_id_token_from_mobile_sdk"
}
```

Response auth:

```json
{
  "accessToken": "jwt",
  "refreshToken": "jwt",
  "user": {
    "id": "uuid",
    "email": "learner@scenio.dev",
    "displayName": "Scenio Learner",
    "level": "A2",
    "totalXp": 320,
    "streakDays": 7,
    "needsOnboarding": false,
    "needsLevelTest": false
  },
  "isNewUser": false,
  "needsOnboarding": false,
  "needsLevelTest": false
}
```

### Home

```http
GET /api/home/dashboard
```

Map:

- `user`
- `missions`
- `inProgressSession`
- `recommendedScenes`

### Scenes

```http
GET /api/scenes?category=&difficulty=&page=1&limit=10
GET /api/scenes/search?q=&limit=10
GET /api/scenes/recommend?limit=5
GET /api/scenes/:id
GET /api/scenes/:id/voices
```

Scene DTO nên support nullable metadata:

```dart
class SceneEntity {
  final String id;
  final String title;
  final String category;
  final String difficulty;
  final String? description;
  final int estimatedMinutes;
  final String? characterName;
  final String? characterRole;
  final String? retrievalMode;
  final String? focusSkill;
  final double? score;
  final double? similarity;
  final String? matchReason;
}
```

### Learning Plan

```http
GET   /api/learning-plan/current
POST  /api/learning-plan/generate
POST  /api/learning-plan/refresh
PATCH /api/learning-plan/steps/:id/complete
```

Enums:

```text
LearningPlanStatus: ACTIVE | ARCHIVED | COMPLETED
LearningPlanStepStatus: LOCKED | NEXT | IN_PROGRESS | COMPLETED | SKIPPED
LearningPlanStepType: SCENE | VOCABULARY_REVIEW | RETRY_SCENE | CUSTOM_PRACTICE
LearningFocusSkill: GRAMMAR | VOCABULARY | NATURALNESS | CONFIDENCE
RetrievalMode: VECTOR | TEXT_FALLBACK | HYBRID_VECTOR | HEURISTIC_FALLBACK
```

DTO gợi ý:

```dart
class LearningPlanResponse {
  final LearningPlanDto plan;
  final List<LearningPlanStepDto> steps;
  final LearningPlanNextStepDto? nextStep;
}

class LearningPlanDto {
  final String id;
  final String status;
  final String title;
  final String summary;
  final String level;
  final String? learningGoal;
  final String? studyFrequency;
  final String focusSkill;
  final int weeklyTarget;
  final String generatedBy;
  final Map<String, dynamic>? sourceSnapshot;
}

class LearningPlanStepDto {
  final String id;
  final String type;
  final String status;
  final String focusSkill;
  final String? sceneId;
  final String title;
  final String? description;
  final String? reason;
  final int sortOrder;
  final int targetCount;
  final int completedCount;
  final Map<String, dynamic>? metadata;
  final SceneEntity? scene;
}
```

### Sessions

```http
POST  /api/sessions/level-test
POST  /api/sessions/start
POST  /api/sessions/start-custom
POST  /api/sessions/:id/realtime-token
POST  /api/sessions/:id/message
POST  /api/sessions/:id/hint
POST  /api/sessions/:id/complete
GET   /api/sessions/:id/result
PATCH /api/sessions/:id/abandon
```

Session result DTO phải có feedback:

```dart
class SessionMessageEntity {
  final String id;
  final String role;
  final String content;
  final int turnIndex;
  final String? modality;
  final bool? isFinal;
  final bool? hasError;
  final String? errorType;
  final String? originalPhrase;
  final String? suggestion;
  final String? explanation;
  final bool? isGood;
  final Map<String, dynamic>? feedbackDetails;
  final bool? isHint;
}
```

### Vocabulary

```http
GET    /api/vocabulary
GET    /api/vocabulary/decks
GET    /api/vocabulary/decks/:sessionId
POST   /api/vocabulary
POST   /api/vocabulary/:id/review
DELETE /api/vocabulary/:id
```

### Users / Missions / Badges

```http
GET   /api/users/me
PATCH /api/users/me
PATCH /api/users/me/onboarding
GET   /api/users/progress
GET   /api/users/badges
POST  /api/users/xp
GET   /api/missions/today
```

Mobile thường không cần gọi `POST /users/xp` khi complete session vì backend session completion đã tự grant XP.

---

## 4. Repository / Provider Methods Cần Có

Theo kiến trúc hiện tại: View -> ViewModel -> Repository -> Provider/API Client.

### AuthRepository

```dart
Future<AuthSession> login(String email, String password);
Future<AuthSession> register(RegisterRequest request);
Future<AuthSession> loginWithGoogle(String idToken);
Future<void> logout(String refreshToken);
Future<String> refresh(String refreshToken);
Future<UserEntity> verifyToken();
```

### LearningRepository

```dart
Future<HomeDashboardModel> getHomeDashboard();
Future<List<SceneEntity>> getScenes({String? category, String? difficulty, int page = 1, int limit = 10});
Future<List<SceneEntity>> searchScenes(String query, {int limit = 10});
Future<RecommendedScenesResult> getRecommendedScenes({int limit = 5});
Future<SceneEntity> getSceneDetail(String sceneId);
Future<SceneVoicesResult> getSceneVoices(String sceneId);
Future<LearningPlanResponse> getCurrentLearningPlan();
Future<LearningPlanResponse> refreshLearningPlan();
Future<LearningPlanResponse> completeLearningPlanStep(String stepId);
```

### SessionRepository

Nếu hiện đang gộp trong LearningRepository vẫn được, nhưng concept nên rõ:

```dart
Future<LevelTestTurnResult> submitLevelTestTurn(LevelTestTurnRequest request);
Future<SessionStartResult> startSession(StartSessionRequest request);
Future<SessionStartResult> startCustomSession(StartCustomPracticeRequest request);
Future<RealtimeTokenResult> createRealtimeToken(String sessionId);
Future<SessionMessageResult> syncSessionMessage(String sessionId, SyncMessageRequest request);
Future<SessionHintResult> requestHint(String sessionId, {String? focus});
Future<SessionCompletionResult> completeSession(String sessionId);
Future<SessionResultModel> getSessionResult(String sessionId);
Future<void> abandonSession(String sessionId);
```

### UserRepository

```dart
Future<UserEntity> getMe();
Future<UserEntity> updateMe(UpdateProfileRequest request);
Future<UserEntity> updateOnboarding(OnboardingRequest request);
Future<UserProgressModel> getProgress();
Future<List<BadgeModel>> getBadges();
```

### VocabularyRepository

```dart
Future<List<VocabularyItem>> getVocabulary();
Future<List<VocabDeck>> getDecks();
Future<VocabDeckDetail> getDeckDetail(String sessionId);
Future<VocabularyItem> saveVocabulary(SaveVocabularyRequest request);
Future<VocabularyItem> reviewVocabulary(String id, ReviewVocabularyRequest request);
Future<void> deleteVocabulary(String id);
```

---

## 5. Mobile Routes / Screens Cần Bổ Sung

| Route/screen | Trạng thái mong muốn | Endpoint chính |
|---|---|---|
| `LearningPlanView` | Màn timeline lộ trình | `/learning-plan/current` |
| `LevelTestView` | Chat/test 5 lượt | `/sessions/level-test` |
| `SessionResultView` | Cần render correction thật | `/sessions/:id/result` |
| `SceneSearchView` | Search bằng backend | `/scenes/search` |
| `ProfileView` | Bỏ mock, dùng progress/badges thật | `/users/progress`, `/users/badges` |
| `VoicePickerSheet` | Quick pick + advanced voices | `/scenes/:id/voices` |

---

## 6. Fallback Mobile Cần Hiểu

Backend đã xử lý fallback, mobile không cần báo lỗi kỹ thuật cho user thường.

| Trường hợp | Backend trả | Mobile behavior |
|---|---|---|
| Gemini embedding OK | `VECTOR`, `HYBRID_VECTOR` | Render search/recommend bình thường |
| Chưa có vector/backfill lỗi | `TEXT_FALLBACK`, `HEURISTIC_FALLBACK` | Render bình thường, không hiện lỗi |
| User chưa có plan | `GET /learning-plan/current` tự tạo | Show loading rồi render plan |
| Plan không có step | `steps = []` | Empty state + Refresh plan |
| Evaluator/provider lỗi | Backend dùng fallback heuristic | Result vẫn render được |
| Voice key/provider chưa sẵn | Voice endpoint có thể lỗi hoặc thiếu token | Ẩn voice CTA hoặc disable với message nhẹ |

Mobile không bao giờ nhập hoặc lưu Gemini/OpenAI/Claude/ElevenLabs key. Key nằm ở backend `.env` hoặc admin config.

---

## 7. QA Checklist Cho Mobile Agent

1. Login email bằng `learner@scenio.dev / 123456`.
2. Google login gửi `idToken` thật từ SDK về `/auth/google`.
3. Home load được dashboard và learning plan.
4. Learning Plan screen render đủ step, next step, progress.
5. Search `airport` gọi `/scenes/search`, không filter local.
6. Recommend gọi `/scenes/recommend`, render được khi fallback.
7. Start scene session, render opening message từ BE.
8. Gửi ít nhất 3 USER_TEXT message lên `/sessions/:id/message`.
9. Complete session, mở result.
10. Result hiện score, XP, transcript, correction, good badges.
11. Result hiện `nextLearningAction` hoặc next step từ learning plan.
12. Vocabulary deck/detail/review chạy với backend thật.
13. Profile không còn hardcode các số chính như XP/streak/badges.
14. Không screen nào yêu cầu user nhập provider key.

---

## 8. Definition Of Done Cho Bản Demo Luận Văn

Mobile được xem là map đủ concept backend khi demo được flow:

```text
Register/Login
  -> Onboarding hoặc Level Test
  -> Home thấy lộ trình cá nhân
  -> Start next practice
  -> Sync transcript
  -> Complete session
  -> Xem điểm và correction từng câu
  -> Save/review vocabulary hoặc đi next step
```

Điểm cần nhấn trong báo cáo:

```text
Scenio không chỉ là chatbot. Backend biến hội thoại thành dữ liệu học tập:
điểm số, lỗi cụ thể, câu sửa, vocabulary, lộ trình cá nhân hóa và gợi ý bài tiếp theo.
Mobile là lớp trình bày vòng lặp học tập đó cho user.
```
