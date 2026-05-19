# Scenio Mobile - In-App Notifications UI Spec

Tài liệu này handoff cho mobile để nối UI với backend in-app notifications đã implement ở `scenio_be`.

Mục tiêu phase này là:

- Có inbox thông báo trong app.
- Có badge unread ở icon chuông.
- User bấm vào notification sẽ đi đúng màn liên quan.
- Chưa làm push notification. Chưa cần Firebase ở phase này.

Base URL local:

```text
http://localhost:3000/api
```

Android emulator:

```text
http://10.0.2.2:3000/api
```

Tất cả endpoint cần:

```http
Authorization: Bearer <accessToken>
``` 

---

## 1. Backend status

Backend đã có:

- bảng `notifications`
- API list notifications
- API mark một notification là đã đọc
- API mark tất cả notifications là đã đọc
- auto tạo notification cho:
  - hoàn thành session
  - hoàn thành mission
  - nhận badge mới
  - learning plan ready / refreshed

Backend chưa có:

- push notification
- device token
- Firebase / FCM

---

## 2. Endpoints

### 2.1. List notifications

```http
GET /api/notifications?page=1&limit=20
GET /api/notifications?page=1&limit=20&unreadOnly=true
```

Response:

```json
{
  "success": true,
  "status": 200,
  "timestamp": "2026-05-17T10:00:00.000Z",
  "data": {
    "items": [
      {
        "id": "uuid",
        "type": "SESSION_COMPLETED",
        "title": "Session completed: At the Pharmacy",
        "message": "You earned 73 XP. Grammar 80 • Vocabulary 70 • Naturalness 75.",
        "ctaType": "SESSION_RESULT",
        "metadata": {
          "sessionId": "uuid",
          "sceneId": "uuid",
          "sceneTitle": "At the Pharmacy",
          "sourceType": "CURATED_SCENE"
        },
        "isRead": false,
        "readAt": null,
        "createdAt": "2026-05-17T10:00:00.000Z",
        "updatedAt": "2026-05-17T10:00:00.000Z"
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 7,
      "totalPages": 1,
      "hasNextPage": false
    },
    "unreadCount": 3,
    "filters": {
      "unreadOnly": false
    }
  }
}
```

### 2.2. Mark one as read

```http
PATCH /api/notifications/:id/read
```

Response:

```json
{
  "success": true,
  "status": 200,
  "timestamp": "2026-05-17T10:00:00.000Z",
  "data": {
    "notification": {
      "id": "uuid",
      "type": "MISSION_COMPLETED",
      "title": "Mission completed: Daily warm-up",
      "message": "You completed a daily mission and earned 50 bonus XP.",
      "ctaType": "MISSIONS",
      "metadata": {
        "missionIds": ["uuid"],
        "userMissionIds": ["uuid"],
        "titles": ["Daily warm-up"],
        "totalXp": 50,
        "count": 1
      },
      "isRead": true,
      "readAt": "2026-05-17T10:02:00.000Z",
      "createdAt": "2026-05-17T10:00:00.000Z",
      "updatedAt": "2026-05-17T10:02:00.000Z"
    },
    "updated": true
  }
}
```

Nếu notification đã đọc từ trước, BE vẫn trả `200`, nhưng `updated = false`.

### 2.3. Mark all as read

```http
PATCH /api/notifications/read-all
```

Response:

```json
{
  "success": true,
  "status": 200,
  "timestamp": "2026-05-17T10:00:00.000Z",
  "data": {
    "updatedCount": 3
  }
}
```

---

## 3. Notification types và ý nghĩa

### `SESSION_COMPLETED`

Tạo khi user hoàn thành một session và backend đã chấm điểm xong.

`ctaType`:

```text
SESSION_RESULT
```

`metadata`:

```json
{
  "sessionId": "uuid",
  "sceneId": "uuid",
  "sceneTitle": "At the Pharmacy",
  "sourceType": "CURATED_SCENE"
}
```

Tap behavior:

- mark read
- mở màn `Session Result`
- mobile gọi:

```http
GET /api/sessions/:sessionId/result
```

### `MISSION_COMPLETED`

Tạo khi user complete ít nhất một daily mission trong reward flow.

`ctaType`:

```text
MISSIONS
```

`metadata`:

```json
{
  "missionIds": ["uuid"],
  "userMissionIds": ["uuid"],
  "titles": ["Daily warm-up"],
  "totalXp": 50,
  "count": 1
}
```

Tap behavior:

- mark read
- về Home hoặc mở block mission/today missions

### `BADGE_EARNED`

Tạo khi user mở khóa achievement mới.

`ctaType`:

```text
BADGES
```

`metadata`:

```json
{
  "badgeIds": ["uuid"],
  "titles": ["First Session"],
  "totalXp": 20,
  "count": 1
}
```

Tap behavior:

- mark read
- mở Profile -> Badges section

### `LEARNING_PLAN_READY`

Tạo khi onboarding xong và backend generate learning plan đầu tiên.

`ctaType`:

```text
LEARNING_PLAN
```

`metadata`:

```json
{
  "planId": "uuid",
  "title": "Travel English A2 Roadmap",
  "focusSkill": "GRAMMAR",
  "weeklyTarget": 3
}
```

Tap behavior:

- mark read
- mở màn Learning Plan

### `LEARNING_PLAN_REFRESHED`

Tạo khi user refresh learning plan.

`ctaType`:

```text
LEARNING_PLAN
```

Tap behavior giống `LEARNING_PLAN_READY`.

---

## 4. UI concept cho mobile

### 4.1. Header bell

Ở Home header hiện đã có icon chuông placeholder.

Mobile nên:

- fetch `GET /api/notifications?page=1&limit=20` khi bootstrap Home/app shell
- lấy `unreadCount`
- nếu `unreadCount > 0` thì show badge tròn nhỏ ở icon chuông
- badge chỉ cần hiện:
  - `1` đến `9`
  - `9+` nếu lớn hơn 9

### 4.2. Notifications screen

Màn này nên có:

- App bar: `Notifications`
- action góc phải: `Mark all as read`
- tab/filter đơn giản:
  - `All`
  - `Unread`
- danh sách card theo thời gian mới nhất

Mỗi card nên có:

- icon theo `type`
- `title`
- `message`
- timestamp relative: `2m ago`, `3h ago`, `Yesterday`
- trạng thái unread bằng dot hoặc nền hơi khác

### 4.3. Empty state

Nếu `items.length == 0`:

- title: `No notifications yet`
- subtitle: nói ngắn gọn kiểu:
  - `Scenio will show learning updates, rewards, and session feedback here.`

### 4.4. Read state

Khi user tap một item:

1. gọi `PATCH /api/notifications/:id/read`
2. optimistic update local `isRead = true`
3. giảm `unreadCount`
4. điều hướng theo `ctaType`

Khi user tap `Mark all as read`:

1. gọi `PATCH /api/notifications/read-all`
2. set local unread về 0
3. tất cả item local `isRead = true`

---

## 5. Mapping ctaType sang route mobile

| ctaType | Màn nên mở |
|---|---|
| `SESSION_RESULT` | gọi `GET /sessions/:id/result`, mở `SessionResultView` |
| `LEARNING_PLAN` | mở tab / màn Learning Plan |
| `MISSIONS` | về Home và focus section daily missions |
| `BADGES` | mở Profile, scroll hoặc route tới badges |
| `SCENES` | mở tab Scenes |
| `HOME` | về Home |

Lưu ý:

- `ctaType` là gợi ý route.
- `metadata` mới là thứ mobile dùng để deep link chính xác hơn.
- `SESSION_RESULT` là case quan trọng nhất, cần làm chuẩn đầu tiên.

---

## 6. DTO gợi ý cho mobile

```dart
class AppNotificationEntity {
  final String id;
  final String type;
  final String title;
  final String message;
  final String? ctaType;
  final Map<String, dynamic>? metadata;
  final bool isRead;
  final DateTime? readAt;
  final DateTime createdAt;
}
```

```dart
class NotificationsPageEntity {
  final List<AppNotificationEntity> items;
  final int unreadCount;
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasNextPage;
  final bool unreadOnly;
}
```

Repository methods nên có:

```dart
Future<NotificationsPageEntity> fetchNotifications({
  int page = 1,
  int limit = 20,
  bool unreadOnly = false,
});

Future<AppNotificationEntity> markNotificationAsRead(String id);

Future<int> markAllNotificationsAsRead();
```

---

## 7. Priority cho mobile

### P0

- badge unread ở icon chuông
- màn list notifications
- tap notification -> mark read
- `SESSION_RESULT` deep link hoạt động
- `LEARNING_PLAN` deep link hoạt động

### P1

- filter `All / Unread`
- pagination load more
- `MISSIONS` và `BADGES` deep link mượt hơn

### P2

- grouping theo ngày
- swipe action mark read
- settings bật/tắt loại notification

---

## 8. QA checklist

- session complete xong có notification mới
- unreadCount tăng đúng
- mở inbox thấy item mới ở đầu list
- tap item đổi read state đúng
- badge unread trên chuông giảm đúng
- `Mark all as read` hoạt động
- kill app mở lại vẫn giữ read/unread đúng từ backend
- session notification mở được result screen thật

---

## 9. Ghi chú triển khai

- Phase này chỉ là **in-app notification**.
- Không cần Firebase.
- Không cần `firebase_messaging`.
- Không cần device token.

Push notification sẽ là phase sau nếu cần.
