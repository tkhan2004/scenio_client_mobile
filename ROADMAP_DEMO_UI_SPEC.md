# Scenio Mobile - Roadmap Demo UI Spec

Tài liệu này dùng để làm UI trước cho bản demo Scenio, với mục tiêu:

- app không chỉ là chat với AI
- roadmap có ý nghĩa rõ ràng
- session result giải thích được user tiến bộ gì, chưa đạt gì, nên làm gì tiếp
- có ghi chú phần lịch học/reminder gắn với icon thông báo

Spec này ưu tiên **luồng demo hoàn chỉnh**, không cố mở rộng hết mọi chức năng.

---

## 1. Mục tiêu demo

Khi người xem trải nghiệm app, họ phải hiểu được luồng sau:

```text
Onboarding / xác định mục tiêu
-> app tạo roadmap
-> user luyện scene
-> AI chấm theo ngữ cảnh
-> user thấy mình mạnh/yếu chỗ nào
-> app gợi ý buổi học tiếp theo
-> roadmap có đích đến và phần thưởng/ý nghĩa sau khi hoàn thành
```

Điểm mấu chốt:

- roadmap phải trả lời câu hỏi: `học để đạt được gì`
- result screen phải trả lời câu hỏi: `mình vừa học được gì`
- next step phải trả lời câu hỏi: `mình nên làm gì tiếp`

---

## 2. Ưu tiên UI theo phase

### P0 - Bắt buộc cho demo

1. Home có card roadmap rõ ràng
2. Learning Plan screen
3. Session Result screen nâng cấp
4. Roadmap completion summary
5. Icon chuông có badge unread và mở inbox thông báo

### P1 - Nếu còn thời gian

1. Filter notifications
2. Schedule picker đơn giản cho số buổi/tuần
3. Reminder card trên Home

### P2 - Làm sau demo

1. Push notification bằng Firebase
2. Calendar sync
3. Cấu hình ngày học chi tiết hơn

---

## 3. Màn Home

### 3.1. Mục tiêu Home

Home phải làm rõ 3 thứ:

- user đang theo roadmap nào
- buổi học tiếp theo là gì
- hôm nay có cần quay lại học không

### 3.2. Cấu trúc khối trên Home

Thứ tự đề xuất:

1. Header
2. Roadmap hero card
3. Next session / next step card
4. Daily missions
5. Recommended scenes
6. Recent progress / streak / XP

### 3.3. Header

Header gồm:

- tên user
- level
- streak/xp ngắn
- icon chuông thông báo ở góc phải

Icon chuông:

- nếu có unread notifications -> hiện badge đỏ nhỏ
- tap icon -> mở màn `Notifications`

Nếu có reminder học hôm nay, badge chuông vẫn dùng chung:

- chưa cần icon riêng cho lịch
- reminder học sẽ đi vào cùng inbox notification

### 3.4. Roadmap hero card

Card này là phần quan trọng nhất của Home.

Thông tin cần hiển thị:

- `roadmap title`
- `focus skill`
- `weekly target`
- `target outcome`
- `progress`
- `current phase`

Ví dụ nội dung:

- `Travel English A2 Roadmap`
- `Focus: Grammar + Confidence`
- `3 sessions / week`
- `Goal: handle 4 everyday travel situations clearly`
- `4 / 8 sessions completed`

CTA chính:

- `Continue roadmap`

CTA phụ:

- `View full plan`

### 3.5. Next step card

Card riêng ngay dưới roadmap hero.

Thông tin:

- title: `Next best step`
- scene title hoặc practice type
- reason ngắn:
  - `You still need cleaner sentence structure`
  - `Vocabulary is improving, now focus on natural replies`

CTA:

- `Start now`

Mục đích:

- user không phải tự đoán scene nào nên học tiếp

### 3.6. Reminder card nhẹ

Nếu roadmap có `3 sessions/week`, Home có thể có 1 reminder card nhẹ:

- `You planned 3 study sessions this week`
- `Next suggested day: Thursday`

Nếu chưa làm scheduling backend thật:

- card này có thể là UI placeholder dùng data roadmap + logic local
- nhưng không nên chặn demo

---

## 4. Learning Plan screen

### 4.1. Mục tiêu

Màn này phải cho user thấy:

- roadmap kéo dài bao lâu
- hoàn thành roadmap sẽ đạt được gì
- hiện tại mình đang ở bước nào

### 4.2. Header summary

Phần đầu màn gồm:

- roadmap title
- short summary
- focus skill chip
- weekly target
- completion percentage

Thêm block `Expected outcome`:

- đây là thứ roadmap hiện đang thiếu
- phải present rõ

Ví dụ:

```text
After finishing this roadmap, you should be able to:
- ask and answer basic travel service questions
- explain simple needs clearly
- maintain short real-life conversations in 4 key scenes
```

### 4.3. Completion rule block

Phải có 1 card riêng `How completion works`

Ví dụ:

- Complete `8 sessions`
- Finish `4 core scenes`
- Reach average score `>= 70` in recent practice

Card này làm cho roadmap có logic rõ ràng, không mơ hồ.

### 4.4. Timeline steps

Mỗi step hiển thị:

- title
- type
- focus skill
- reason
- status

Status:

- `Next`
- `In progress`
- `Completed`
- `Locked`

Visual:

- `Next`: nổi bật màu primary
- `Completed`: có check
- `Locked`: mờ

### 4.5. Reward / meaning block

Phần cuối màn hoặc gần cuối:

`What you unlock after this roadmap`

Ví dụ:

- roadmap completion badge
- bonus XP
- next roadmap recommendation
- advanced scenes unlocked

Nếu backend chưa có unlock thật cho scene thì vẫn nên có ít nhất:

- completion badge
- XP bonus
- next roadmap card

---

## 5. Session Result screen

### 5.1. Mục tiêu

Result screen phải biến session thành một vòng học hoàn chỉnh.

Không chỉ hiển thị:

- XP
- grammar/vocabulary/naturalness

Mà còn phải hiển thị:

- mission success
- AI coaching
- what improved
- what to fix next
- next practice recommendation

### 5.2. Cấu trúc mới của Result screen

Thứ tự đề xuất:

1. completion badge / title
2. scene title
3. XP + score summary
4. mission outcome card
5. AI coaching card
6. key turns / highlights
7. next learning action
8. transcript highlights
9. CTA buttons

### 5.3. Mission outcome card

Card mới cần thêm cho demo.

Mục tiêu:

- đánh giá user có hoàn thành mục tiêu hội thoại không

Nội dung:

- `Mission success: Achieved / Partially achieved / Needs retry`
- giải thích bằng ngôn ngữ tự nhiên

Ví dụ:

- `You successfully explained your need and responded to the pharmacist.`
- `You stayed in context, but your reply was too short to complete the goal clearly.`

### 5.4. AI coaching card

Card này đã gần có nền tảng từ backend.

Nên present:

- summary
- strengths
- improvements
- confidence / clarity / expression

Tone:

- thân thiện
- cụ thể
- không quá “phán xét”

### 5.5. Key turns / highlights

Hiển thị 2-3 lượt quan trọng:

- một câu tốt
- một hoặc hai câu cần sửa

Mỗi item:

- original sentence
- short note
- suggestion nếu có

### 5.6. Next learning action

Card này rất quan trọng cho demo.

Nó phải trả lời:

`Sau buổi này, bạn nên làm gì tiếp theo?`

Ví dụ:

- `Practice cleaner sentence structure`
- `Review useful phrases from this situation`
- `Try a more natural follow-up reply`

CTA:

- `Practice now`
- `Review vocabulary`
- `Retry similar scene`

### 5.7. CTA buttons cuối màn

Hai nút nên là:

- Primary: `Continue learning`
- Secondary: `Back to Home`

Nếu có `next learning action`, primary nên điều hướng đúng action đó.

---

## 6. Roadmap completion summary screen

### 6.1. Có nên làm không?

Có. Đây là một trong những màn có ý nghĩa nhất cho demo.

Nếu roadmap complete mà không có màn tổng kết, user và người xem sẽ không cảm nhận được giá trị của roadmap.

### 6.2. Khi nào mở?

Mở khi:

- roadmap đủ điều kiện complete theo rule backend

### 6.3. Nội dung màn

1. Title:
   - `Roadmap completed`

2. Outcome summary:
   - `You finished Travel English A2 Roadmap`

3. Before / after progress:
   - grammar: `62 -> 74`
   - vocabulary: `66 -> 73`
   - naturalness: `58 -> 71`

4. Real-life capability summary:
   - `You can now handle short travel service conversations more clearly`

5. Scenes completed:
   - chips hoặc mini cards của các scene core đã hoàn thành

6. Reward section:
   - badge earned
   - XP bonus

7. Next roadmap recommendation:
   - `Recommended next roadmap: Travel Vocabulary Expansion`

8. CTA:
   - `Start next roadmap`
   - `Back to Home`

### 6.4. Tông màn này

- cảm giác hoàn thành
- rõ tiến bộ
- có hướng tiếp tục

Không nên làm như popup thưởng đơn thuần.

---

## 7. Notifications screen

### 7.1. Mục tiêu

Màn này không chỉ là inbox hệ thống.

Nó còn là nơi gắn:

- session completed
- mission completed
- badge earned
- roadmap ready
- reminder học

### 7.2. Nguồn notification trong demo

Cho phase demo, notification nên gồm:

- `Session completed`
- `Mission completed`
- `Badge earned`
- `Learning plan ready`
- `Learning plan refreshed`
- `Study reminder` (nếu kịp làm local/in-app)

### 7.3. Liên kết lịch học với icon thông báo

Phần `lịch học` trong demo nên gắn với icon chuông theo cách này:

1. User chọn `study frequency`, ví dụ `3 sessions / week`
2. App gợi ý ngày học:
   - `Tue / Thu / Sat`
3. Đến ngày học, tạo in-app notification:
   - `Study reminder: Your roadmap suggests a practice session today.`
4. Notification này hiện trong inbox và tăng badge chuông

Tức là:

- **không cần tạo tab lịch riêng ở phase demo**
- **reminder đi chung vào hệ thông báo**

Đây là cách scope gọn hơn nhưng vẫn có ý nghĩa.

### 7.4. UI của Notifications

App bar:

- `Notifications`
- action: `Mark all as read`

Filter chip:

- `All`
- `Unread`

Notification card:

- icon theo type
- title
- short message
- timestamp
- unread dot

### 7.5. Tap behavior

| Type | Hành động |
|---|---|
| Session completed | mở Session Result |
| Learning plan ready/refreshed | mở Learning Plan |
| Mission completed | về Home -> mission block |
| Badge earned | mở Profile -> badges |
| Study reminder | mở Home hoặc mở roadmap next step |

---

## 8. Scheduling / reminder note

### 8.1. Có nên làm scheduling thật trước demo không?

Không nên làm full scheduling trước demo nếu còn ít thời gian.

Không cần:

- calendar integration
- Firebase push
- timezone phức tạp
- cài đặt nhắc nhiều khung giờ

### 8.2. Nên làm mức nào là đủ?

Chỉ cần mức nhẹ:

- roadmap biết `weeklyTarget`
- UI có `suggested study days`
- app tạo in-app reminder theo các ngày đó
- reminder đi vào inbox notification

### 8.3. Gợi ý UX

Ở Learning Plan hoặc onboarding:

- `How many days per week do you want to study?`
- nếu chọn `3`, app gợi ý:
  - `Tue / Thu / Sat`

Nếu chưa kịp làm backend cho selected days:

- cứ ghi trong spec UI trước
- phase code có thể mock local hoặc derive từ weekly target

---

## 9. Adaptive evaluation note cho UI

UI cần chuẩn bị chỗ để backend sau này trả đánh giá mềm hơn.

Ngoài 3 score chính, UI nên có slot cho:

- `missionSuccess`
- `contextAppropriateness`
- `confidence`
- `initiative`

Phase demo có thể chỉ hiển thị:

- `Mission outcome`
- `AI coaching summary`
- `Next learning action`

Như vậy là đủ để app trông “scene-aware”, không quá máy móc.

---

## 10. Component list cho mobile

### Home

- `RoadmapHeroCard`
- `RoadmapOutcomeChipGroup`
- `NextStepCard`
- `NotificationBellButton`
- `ReminderMiniCard`

### Learning Plan

- `LearningPlanHeader`
- `ExpectedOutcomeCard`
- `CompletionRuleCard`
- `LearningPlanStepTimeline`
- `RoadmapRewardCard`

### Session Result

- `MissionOutcomeCard`
- `AiCoachingCard`
- `TurnHighlightList`
- `NextLearningActionCard`

### Roadmap Completion

- `RoadmapCompletionHero`
- `ProgressDeltaCard`
- `CompletedScenesWrap`
- `RewardSummaryCard`
- `NextRoadmapCard`

### Notifications

- `NotificationListItem`
- `NotificationFilterChips`
- `UnreadBadgeDot`

---

## 11. Luồng demo khuyến nghị

Đây là luồng đẹp nhất để trình bày:

1. Vào Home
2. Chỉ vào roadmap card và target outcome
3. Mở Learning Plan để cho thấy completion rule
4. Start một scene practice
5. Complete session
6. Vào Result screen:
   - mission outcome
   - AI coaching
   - next learning action
7. Quay về Home
8. Chỉ icon chuông có notification mới
9. Mở inbox thông báo
10. Cho thấy roadmap / session / reward đều kết nối với nhau

---

## 12. Definition of Done cho UI demo

UI được xem là đủ tốt cho demo khi:

- Home nói rõ user đang theo roadmap nào
- Learning Plan nói rõ hoàn thành roadmap sẽ đạt được gì
- Session Result nói rõ user vừa làm tốt/chưa tốt ở đâu
- Có next learning action rõ ràng
- Có roadmap completion summary hoặc ít nhất UI shell của nó
- Icon chuông có unread badge
- Notifications screen mở được và map được các type chính
- Reminder học được ghi chú trong cùng hệ notification, không tách rời

---

## 13. Kết luận

Cho demo, ưu tiên đúng là:

1. roadmap có outcome rõ
2. result có ý nghĩa học tập
3. next step rõ
4. notification bell kết nối với roadmap/reminder

Không nên dàn trải sang push notification hoặc calendar thật ở giai đoạn này.
