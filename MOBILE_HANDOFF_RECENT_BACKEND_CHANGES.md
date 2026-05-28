# Scenio Mobile - Recent Backend Changes Handoff

Tài liệu này dành cho mobile team để map các thay đổi backend mới nhất, tập trung vào:

- roadmap lifecycle hoàn chỉnh hơn
- roadmap reward thật
- roadmap completion / next roadmap flow
- notification bell gắn với roadmap
- session result / evaluator strict hơn
- custom voice selection ổn định hơn

Base URL local:

```text
http://localhost:3000/api
```

Android emulator:

```text
http://10.0.2.2:3000/api
```

Tất cả endpoint private cần:

```http
Authorization: Bearer <accessToken>
```

---

## 1. Thay đổi quan trọng nhất cho mobile

### 1.1 Roadmap không còn tự sinh ngay sau level test

Flow mới:

```text
Level test complete
-> chỉ update level
-> chưa tạo roadmap

Onboarding complete
-> mới tạo roadmap đầu tiên
```

Ý nghĩa với mobile:

- Sau `POST /sessions/level-test`, không assume đã có learning plan.
- Chỉ sau `PATCH /users/me/onboarding` mới nên gọi `GET /learning-plan/current`.
- Nếu gọi `GET /learning-plan/current` quá sớm, backend có thể trả `409`.

### 1.2 Roadmap completion đã là reward thật

Khi roadmap complete:

- cộng `xpBonus` thật vào profile
- grant roadmap badge thật vào achievements
- có notification roadmap completed
- có thể start roadmap tiếp theo bằng endpoint riêng

Điều này có nghĩa:

- màn completion không còn là preview local
- Profile/Achievements phải đọc badge roadmap từ `GET /users/badges`

---

## 2. Endpoint roadmap mobile cần map

### 2.1 GET `/learning-plan/current`

Mục đích:

- lấy roadmap active hiện tại
- tự generate roadmap nếu user đã onboarding xong nhưng chưa có active plan

Case cần xử lý:

- `200`: có roadmap
- `409`: user chưa đủ onboarding context để tạo roadmap

Field mới cần parse:

```json
{
  "plan": {
    "id": "uuid",
    "status": "ACTIVE",
    "derivedState": "IN_PROGRESS",
    "title": "Travel English A2 Roadmap",
    "summary": "...",
    "level": "A2",
    "learningGoal": "TRAVEL",
    "studyFrequency": "REGULAR",
    "focusSkill": "GRAMMAR",
    "weeklyTarget": 3,
    "targetOutcome": "Handle 4 everyday travel situations clearly at A2 level.",
    "completionCriteria": {
      "requiredSteps": 5,
      "requiredCoreScenes": 4,
      "minimumRecentAverageScore": 70
    },
    "reward": {
      "badgeTitle": "A2 Travel English Roadmap",
      "xpBonus": 120,
      "unlocks": ["Next roadmap suggestion"]
    },
    "schedule": {
      "suggestedDays": ["TUE", "THU", "SAT"],
      "nextSuggestedAt": "2026-05-26T09:00:00.000Z"
    }
  },
  "steps": [],
  "nextStep": {},
  "completionSummary": null
}
```

UI cần dùng:

- Home roadmap hero
- Learning Plan screen
- Next step card
- completion auto-detect nếu `completionSummary != null`

### 2.2 GET `/learning-plan/:id/completion-summary`

Dùng cho:

- màn `Roadmap Completion Summary`
- reload lại summary khi user mở từ notification/history

Response chính:

```json
{
  "completionSummary": {
    "planId": "uuid",
    "title": "Travel English A2 Roadmap",
    "level": "A2",
    "completedAt": "2026-05-22T10:00:00.000Z",
    "completedScenes": ["Airport check-in", "Hotel check-in"],
    "scoreDelta": {
      "grammar": { "before": 62, "after": 74 },
      "vocabulary": { "before": 66, "after": 73 },
      "naturalness": { "before": 58, "after": 71 }
    },
    "reward": {
      "badgeTitle": "A2 Travel English Roadmap",
      "xpBonus": 120
    },
    "nextRoadmap": {
      "title": "Travel English vocabulary expansion",
      "level": "A2",
      "focusSkill": "VOCABULARY"
    }
  }
}
```

### 2.3 POST `/learning-plan/:id/start-next`

Dùng cho CTA:

- `Start next roadmap`

Response:

```json
{
  "previousPlanId": "uuid",
  "completionSummary": {},
  "nextPlan": {
    "plan": {
      "id": "uuid",
      "status": "ACTIVE",
      "derivedState": "IN_PROGRESS",
      "title": "Travel English A2 Roadmap",
      "focusSkill": "VOCABULARY"
    }
  }
}
```

UI behavior:

- bấm CTA ở completion screen
- gọi endpoint
- replace state roadmap hiện tại bằng `nextPlan`
- điều hướng sang Learning Plan hoặc Home roadmap card mới

### 2.4 POST `/learning-plan/refresh`

Vẫn giữ như cũ, nhưng response giờ có cùng shape enriched với:

- `derivedState`
- `targetOutcome`
- `completionCriteria`
- `reward`
- `schedule`
- `completionSummary`

---

## 3. Step behavior mới trong roadmap

Mỗi step có thể có:

```json
{
  "id": "uuid",
  "type": "SCENE",
  "status": "NEXT",
  "focusSkill": "GRAMMAR",
  "sceneId": "uuid",
  "title": "Airport check-in",
  "reason": "Practice clearer question forms.",
  "metadata": {
    "openAction": "SCENE_DETAIL"
  },
  "scene": {
    "id": "uuid",
    "title": "Airport Check-in",
    "category": "TRAVEL",
    "difficulty": "A2",
    "estimatedMinutes": 7,
    "characterName": "David",
    "characterRole": "Check-in Staff"
  }
}
```

Rule map cho mobile:

- `SCENE`, `RETRY_SCENE` -> mở scene detail / start session
- `VOCABULARY_REVIEW` -> mở Vocabulary
- `GRAMMAR_PRACTICE`, `CUSTOM_PRACTICE` -> mở Custom Practice

Status map:

- `NEXT` -> CTA chính
- `IN_PROGRESS` -> đang học
- `COMPLETED` -> đã xong
- `LOCKED` -> khóa

---

## 4. Roadmap completion và achievements

### 4.1 Badge roadmap là data thật

Sau khi complete roadmap:

- badge roadmap sẽ xuất hiện trong `GET /users/badges`
- không còn chỉ là text trong summary

Mobile cần:

- không hardcode badge roadmap local
- render badge từ source `users/badges`
- icon roadmap có thể map theo:
  - `iconKey` chứa `roadmap`
  - hoặc `conditionType = ROADMAP_COMPLETED`

### 4.2 Completion screen nên hiển thị

- roadmap title
- completed scenes
- score delta
- XP bonus
- badge title
- next roadmap suggestion
- CTA `Start next roadmap`

---

## 5. Notification bell cần map gì

Roadmap-related notification hiện đi chung vào inbox notification.

Các loại mobile nên expect:

- `LEARNING_PLAN_READY`
- `LEARNING_PLAN_REFRESHED`
- `ROADMAP_COMPLETED`
- `STUDY_REMINDER`

CTA type roadmap side:

- `LEARNING_PLAN`

Khuyến nghị UI:

- icon chuông ở Home/Header luôn là entrypoint chung
- có unread badge count
- tap notification roadmap:
  - `LEARNING_PLAN_READY`, `LEARNING_PLAN_REFRESHED` -> mở Learning Plan
  - `ROADMAP_COMPLETED` -> mở completion summary nếu đã có `planId`, nếu chưa thì mở Learning Plan
  - `STUDY_REMINDER` -> mở Learning Plan hoặc Home roadmap card

Ghi chú:

- chưa cần tab lịch riêng
- reminder học vẫn đi qua bell/inbox là đủ cho demo

---

## 6. Session result thay đổi mobile cần biết

### 6.1 Vẫn có next action sau khi chấm điểm

`GET /sessions/:id/result` và flow complete session hiện trả phần recommend để user biết nên học gì tiếp.

Mobile nên render:

- spoken coaching
- strengths / improvements
- next learning action

### 6.2 Evaluator strict hơn với câu không phải tiếng Anh

Backend vừa siết rule:

- nếu user trả lời bằng ngôn ngữ khác tiếng Anh, feedback không còn “không có nhược điểm”
- có thể xuất hiện action kiểu retry bằng tiếng Anh

Điều này có nghĩa với UI:

- đừng assume feedback luôn “positive”
- nên hiển thị correction/recommendation nghiêm hơn nếu result báo failed / weak
- nếu có next action kiểu retry, CTA nên đưa user quay lại practice

---

## 7. Custom practice voice flow

Backend đã chỉnh lại rule voice selection:

- nếu user chọn `MALE` hoặc `FEMALE`, backend ưu tiên đúng gender trước
- nếu preset cũ conflict với gender mới, backend sẽ resolve lại

Response `POST /sessions/start-custom` hiện có thêm data hữu ích:

- `selectedVoice`
- `voiceSelection`

Mobile note:

- khi user đổi male/female, nên clear `aiVoicePresetId` cũ nếu UI đang giữ state preset
- không nên giữ preset cũ rồi chỉ đổi gender label

---

## 8. Checklist UI cần làm

### P0

1. Home roadmap card parse đủ field mới
2. Learning Plan screen parse:
   - `targetOutcome`
   - `completionCriteria`
   - `reward`
   - `schedule`
3. Completion screen dùng data thật từ backend
4. CTA `Start next roadmap`
5. Notification bell mở đúng learning-plan related items
6. Profile/Achievements render roadmap badge thật
7. Handle `409` khi chưa onboarding xong

### P1

1. Từ notification `ROADMAP_COMPLETED` mở thẳng completion summary
2. Hiển thị `nextSuggestedAt` / `suggestedDays` đẹp hơn
3. Scene/custom practice CTA theo `nextLearningAction`

---

## 9. Definition of done cho mobile

Mobile được xem là map xong phần thay đổi này khi:

1. User hoàn thành onboarding xong thì thấy roadmap thật.
2. Home hiển thị roadmap với goal, progress, next step.
3. Learning Plan có `Expected outcome`, `Completion rule`, `Reward`.
4. Khi roadmap complete, user thấy summary thật từ backend.
5. User bấm `Start next roadmap` được.
6. Profile/Achievements hiện badge roadmap thật.
7. Notification bell dẫn được tới roadmap / reminder / completion flow.

