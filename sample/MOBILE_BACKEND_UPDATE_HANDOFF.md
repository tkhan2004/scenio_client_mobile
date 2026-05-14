# Mobile Backend Update Handoff

Tài liệu này dành cho agent/mobile team triển khai UI sau các cập nhật mới ở backend Scenio: pgvector semantic recommendation, learning plan cá nhân hóa, AI model/provider config, và test provider keys.

Mục tiêu mobile: biến Scenio từ app chat luyện nói thành app học tập có lộ trình rõ ràng: onboarding -> learning plan -> practice -> correction -> next step.

---

## 1. Backend update summary

Backend hiện đã có thêm:

1. `GET /api/learning-plan/current`
   - Lấy hoặc tự tạo lộ trình học active cho user.
   - Có `plan`, `steps`, `nextStep`.

2. `POST /api/learning-plan/generate`
   - Tạo lại learning plan từ onboarding, level, session history, recommendation.

3. `POST /api/learning-plan/refresh`
   - Refresh plan thủ công từ client.

4. `PATCH /api/learning-plan/steps/:id/complete`
   - Đánh dấu step đã hoàn thành, backend tự unlock step kế tiếp.

5. `GET /api/scenes/search`
   - Ưu tiên pgvector semantic search.
   - Fallback text search nếu chưa có vector/key.
   - Response có thêm `retrievalMode`, `similarity`, `matchReason`.

6. `GET /api/scenes/recommend`
   - Ưu tiên hybrid vector + learning data.
   - Fallback heuristic nếu chưa có vector/key.
   - Response có thêm `retrievalMode`, `focusSkill`, `score`, `matchReason`.

7. Backend provider keys đã test:
   - Gemini embedding: PASS.
   - ElevenLabs TTS: PASS.
   - OpenAI/Claude: optional, hiện skip nếu chưa có key.

---

## 2. Mobile screens cần cập nhật

### 2.1. Home screen

Home nên thêm block `Learning Plan / Next Step`.

Khi user vào Home:

```http
GET /api/home/dashboard
GET /api/learning-plan/current
```

UI đề xuất:

- Card "Your Learning Plan"
- Hiển thị:
  - `plan.title`
  - `plan.summary`
  - `plan.focusSkill`
  - `plan.weeklyTarget`
  - progress: completed steps / total steps
- CTA chính:
  - Nếu `nextStep.type = SCENE`: `Start next practice`
  - Nếu chưa có `nextStep`: `Refresh plan`

Không cần gọi `POST /learning-plan/generate` khi vào Home vì `GET /current` đã tự tạo nếu chưa có.

### 2.2. Learning Plan screen

Thêm màn riêng để user xem lộ trình.

Endpoint:

```http
GET /api/learning-plan/current
```

UI cần có:

- Header:
  - title: `plan.title`
  - summary: `plan.summary`
  - chips: `level`, `learningGoal`, `focusSkill`, `weeklyTarget`
- Timeline/list steps:
  - `NEXT`: nổi bật, có CTA start.
  - `LOCKED`: disabled/locked style.
  - `COMPLETED`: tick/completed style.
  - `IN_PROGRESS`: highlight đang học.
- Step content:
  - `title`
  - `description`
  - `reason`
  - `scene.title`
  - `scene.category`
  - `scene.difficulty`
  - `scene.estimatedMinutes`
- Action:
  - `Refresh plan`: gọi `POST /api/learning-plan/refresh`
  - `Mark completed`: gọi `PATCH /api/learning-plan/steps/:id/complete`

### 2.3. Scene search screen

Endpoint:

```http
GET /api/scenes/search?q=airport&limit=10
```

Mobile cần map thêm:

```json
{
  "retrievalMode": "VECTOR",
  "similarity": 0.86,
  "matchReason": "Matched semantically by pgvector"
}
```

UI rule:

- Không cần show technical label `VECTOR` cho user thường.
- Có thể dùng `matchReason` làm subtitle nhỏ kiểu "Recommended because it matches your search".
- Nếu `retrievalMode = TEXT_FALLBACK`, vẫn render bình thường.
- Nếu `similarity` null, không hiện similarity.

### 2.4. Recommended scenes section

Endpoint:

```http
GET /api/scenes/recommend?limit=5
```

Response có:

```json
{
  "retrievalMode": "HYBRID_VECTOR",
  "focusSkill": "VOCABULARY",
  "scenes": []
}
```

Mỗi scene có thêm:

```json
{
  "retrievalMode": "HYBRID_VECTOR",
  "focusSkill": "VOCABULARY",
  "score": 0.78,
  "matchReason": "Recommended from weak skill, level fit, and vector similarity"
}
```

UI rule:

- Hiển thị section title theo `focusSkill`:
  - `GRAMMAR`: "Practice clearer sentences"
  - `VOCABULARY`: "Build useful phrases"
  - `NATURALNESS`: "Sound more natural"
  - `CONFIDENCE`: "Build speaking confidence"
- Card scene có thể hiện `matchReason` ngắn.
- Không cần show `retrievalMode` trực tiếp, chỉ dùng để debug/log.

### 2.5. Session result screen

Sau khi user complete session:

```http
POST /api/sessions/:id/complete
GET /api/sessions/:id/result
GET /api/learning-plan/current
```

Backend đã update learning plan sau session complete. Mobile nên:

1. Hiển thị score/corrections như hiện tại.
2. Sau result, gọi lại `/learning-plan/current`.
3. Hiển thị card "Next practice" từ `nextStep`.

CTA:

- `Practice next step`
- `Back to plan`

---

## 3. API contracts mobile cần map

### 3.1. Learning plan current

```http
GET /api/learning-plan/current
```

Response:

```json
{
  "success": true,
  "status": 200,
  "data": {
    "plan": {
      "id": "uuid",
      "title": "Travel English A2 Roadmap",
      "summary": "Lộ trình 3 buổi/tuần cho trình độ A2, ưu tiên vocabulary theo mục tiêu TRAVEL.",
      "status": "ACTIVE",
      "level": "A2",
      "learningGoal": "TRAVEL",
      "studyFrequency": "REGULAR",
      "focusSkill": "VOCABULARY",
      "weeklyTarget": 3,
      "generatedBy": "RULE",
      "sourceSnapshot": {
        "selfAssessment": "VOCABULARY",
        "recentSessionCount": 4
      },
      "createdAt": "2026-05-07T00:00:00.000Z",
      "updatedAt": "2026-05-07T00:00:00.000Z"
    },
    "steps": [
      {
        "id": "uuid",
        "type": "SCENE",
        "status": "NEXT",
        "focusSkill": "VOCABULARY",
        "sceneId": "uuid",
        "title": "At the Pharmacy",
        "description": "Explain symptoms and ask for medicine advice.",
        "reason": "Recommended from weak skill, level fit, and vector similarity",
        "sortOrder": 1,
        "targetCount": 1,
        "completedCount": 0,
        "metadata": {
          "retrievalMode": "HYBRID_VECTOR",
          "score": 0.78,
          "similarity": 0.84
        },
        "scene": {
          "id": "uuid",
          "title": "At the Pharmacy",
          "category": "HEALTH",
          "difficulty": "A2",
          "estimatedMinutes": 7,
          "characterName": "Emma",
          "characterRole": "Pharmacist"
        }
      }
    ],
    "nextStep": {
      "id": "uuid",
      "type": "SCENE",
      "sceneId": "uuid",
      "title": "At the Pharmacy",
      "focusSkill": "VOCABULARY"
    }
  }
}
```

### 3.2. Complete learning plan step

```http
PATCH /api/learning-plan/steps/:id/complete
```

Response: giống `GET /learning-plan/current`.

Mobile dùng khi:

- User hoàn thành một step không thông qua session flow.
- User bấm manual complete trên Learning Plan screen.

Trong normal practice flow, backend đã tự update plan sau `POST /sessions/:id/complete`, nên mobile thường không cần gọi endpoint này.

### 3.3. Refresh learning plan

```http
POST /api/learning-plan/refresh
```

Response: giống `GET /learning-plan/current`.

Mobile dùng khi:

- User đổi mục tiêu học.
- User muốn tạo lại plan.
- Plan rỗng hoặc next step không phù hợp.

---

## 4. Enum mapping

### LearningPlanStatus

```ts
type LearningPlanStatus = 'ACTIVE' | 'ARCHIVED' | 'COMPLETED';
```

### LearningPlanStepStatus

```ts
type LearningPlanStepStatus =
  | 'LOCKED'
  | 'NEXT'
  | 'IN_PROGRESS'
  | 'COMPLETED'
  | 'SKIPPED';
```

### LearningPlanStepType

```ts
type LearningPlanStepType =
  | 'SCENE'
  | 'VOCABULARY_REVIEW'
  | 'RETRY_SCENE'
  | 'CUSTOM_PRACTICE';
```

### LearningFocusSkill

```ts
type LearningFocusSkill =
  | 'GRAMMAR'
  | 'VOCABULARY'
  | 'NATURALNESS'
  | 'CONFIDENCE';
```

### RetrievalMode

```ts
type RetrievalMode =
  | 'VECTOR'
  | 'TEXT_FALLBACK'
  | 'HYBRID_VECTOR'
  | 'HEURISTIC_FALLBACK';
```

UI không cần show raw enum cho user, nhưng nên log/debug để biết backend đang chạy vector hay fallback.

---

## 5. Mobile data models gợi ý

```dart
class LearningPlanDto {
  final String id;
  final String title;
  final String summary;
  final String status;
  final String level;
  final String? learningGoal;
  final String? studyFrequency;
  final String focusSkill;
  final int weeklyTarget;
  final String generatedBy;
}
```

```dart
class LearningPlanStepDto {
  final String id;
  final String type;
  final String status;
  final String focusSkill;
  final String? sceneId;
  final String title;
  final String description;
  final String? reason;
  final int sortOrder;
  final int targetCount;
  final int completedCount;
  final Map<String, dynamic>? metadata;
  final SceneDto? scene;
}
```

```dart
class LearningPlanResponseDto {
  final LearningPlanDto plan;
  final List<LearningPlanStepDto> steps;
  final LearningPlanStepDto? nextStep;
}
```

`nextStep` trong API hiện là object rút gọn, không đầy đủ như item trong `steps`. Mobile có thể:

1. Dùng `nextStep.id` để tìm full step trong `steps`.
2. Nếu không tìm thấy, render title/focusSkill rút gọn.

---

## 6. Integration order cho mobile

### Priority 1 - Learning plan visible on Home

1. Add repository method `getCurrentLearningPlan()`.
2. Call after dashboard load.
3. Render next step card.
4. CTA start scene nếu `nextStep.sceneId != null`.

### Priority 2 - Learning Plan screen

1. Create route/screen `LearningPlanPage`.
2. Render timeline/list steps.
3. Add refresh action.
4. Add manual complete action optional.

### Priority 3 - Result to next step loop

1. Sau session result, fetch current learning plan.
2. Show `Next practice` card.
3. CTA start next scene.

### Priority 4 - Recommendation metadata

1. Extend `SceneApiModel` with:
   - `retrievalMode`
   - `focusSkill`
   - `score`
   - `similarity`
   - `matchReason`
2. Render `matchReason`/focus chip where useful.
3. Do not block UI if fields are null.

---

## 7. Fallback behavior mobile cần hiểu

Backend intentionally supports fallback:

| Case | Backend response | Mobile behavior |
|---|---|---|
| Gemini key/vector ready | `VECTOR`, `HYBRID_VECTOR` | Render normal recommendation. Optional debug badge only in dev. |
| Chưa backfill vector | `TEXT_FALLBACK`, `HEURISTIC_FALLBACK` | Render normal recommendation, không show lỗi. |
| Learning plan chưa có | `GET /current` tự generate | Show loading, rồi render plan. |
| Plan có `steps = []` | Rare fallback case | Show empty state + Refresh plan. |
| Provider OpenAI/Claude chưa có key | Chỉ ảnh hưởng feature provider tương ứng | Không chặn learning plan/search/recommend nếu Gemini đã có. |

Mobile tuyệt đối không cần biết provider key. Tất cả provider/API key nằm ở backend/admin.

---

## 8. QA checklist cho mobile

1. Login learner.
2. Home load dashboard và learning plan.
3. Learning plan screen render được 5 steps.
4. Bấm next step mở scene detail/start session.
5. Search scene `airport` vẫn ra kết quả dù `retrievalMode = TEXT_FALLBACK`.
6. Recommend scene vẫn ra kết quả dù `retrievalMode = HEURISTIC_FALLBACK`.
7. Complete session xong result screen hiển thị next practice.
8. Refresh plan không crash và trả plan mới.
9. Manual complete một step unlock step tiếp theo.
10. Không có UI nào yêu cầu user nhập Gemini/OpenAI/ElevenLabs key.

---

## 9. Current backend test status

Smoke API đã pass:

```txt
Admin login: PASS
Learner login: PASS
Admin overview: PASS
Admin AI model catalog: PASS
Home dashboard: PASS
Scene list: PASS
Scene search: PASS
Scene recommend: PASS
Learning plan current: PASS
```

Provider ping đã pass:

```txt
Gemini embedding: PASS
ElevenLabs TTS: PASS
OpenAI: SKIP, chưa có key
Anthropic Claude: SKIP, chưa có key
```

Sau khi backend chạy:

```bash
cd scenio_be
npm run test:smoke
npm run test:providers
```

