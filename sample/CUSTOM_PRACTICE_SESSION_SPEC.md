# Scenio Mobile - Custom Practice Session Spec

## 1. Mục tiêu của feature này

Scenio không chỉ nên cho user chọn các scene có sẵn.

Vì bản chất dự án là **học giao tiếp theo ngữ cảnh**, user cần có khả năng tạo một buổi luyện tập dựa trên nhu cầu thật của mình, ví dụ:

- luyện phỏng vấn vị trí `Frontend Intern`
- luyện nói chuyện với `HR recruiter`
- luyện gọi điện đặt lịch khám
- luyện trao đổi với khách hàng khó tính
- luyện trình bày ý tưởng với team lead

Feature này được gọi là:

- `Custom Practice`
- hoặc `Custom Practice Session`

Nó không thay thế `scene có sẵn`, mà bổ sung thêm một luồng cá nhân hóa sâu hơn.

---
       
## 2. Cách hiểu đúng trong Scenio

### 2.1. Curated Scene

Đây là scene có sẵn trong thư viện.

Ưu điểm:

- chất lượng ổn định
- dễ recommend ở Home
- có metadata rõ ràng
- phù hợp cho đa số user

### 2.2. Custom Practice Session

Đây là buổi luyện tập được sinh từ mô tả của user.

User không cần tạo một `scene library item` hoàn chỉnh như admin.
User chỉ cần mô tả:

- mục tiêu
- bối cảnh
- người đang nói chuyện với mình là ai
- cách họ nên nói
- giọng nào phù hợp

Hệ thống sẽ chuẩn hóa input đó thành:

- `session config`
- `AI persona config`
- `voice config`
- `learning config`

### 2.3. Kết luận về mô hình

Scenio nên có 2 nguồn để tạo session:

- `Curated Scene`
- `Custom Practice Brief`

Nhưng cả hai cuối cùng đều dẫn tới:

- `Practice Session`

---

## 3. Vị trí của feature trong app

### 3.1. Entry points khuyến nghị

User có thể vào `Custom Practice` từ các vị trí sau:

- `Home`
  - card kiểu `Luyện theo mục tiêu của bạn`
- tab `Practice`
  - CTA `Tạo buổi luyện riêng`
- tab `Scenes`
  - CTA phụ `Không thấy tình huống phù hợp? Tạo buổi luyện riêng`

### 3.2. Vị trí trong bottom nav

Không cần thêm tab mới.

Khuyến nghị:

- `Home`
- `Scenes`
- `Practice`
- `Profile`

Trong đó `Practice` là nơi phù hợp nhất để chứa:

- resume session đang active
- entry vào `Custom Practice`

---

## 4. Màn hình cần có

### 4.1. Custom Practice Entry Screen

Đây là màn giới thiệu ngắn trước khi user điền form.

Nội dung nên có:

- title: `Luyện theo mục tiêu của bạn`
- subtitle: `Mô tả tình huống thật mà bạn muốn luyện với AI`
- 2 nhóm ví dụ:
  - `Interview`
  - `Work`
  - `Travel`
  - `Phone Call`
  - `Customer Support`
- CTA:
  - `Bắt đầu tạo buổi luyện`

### 4.2. Custom Practice Form Screen

Đây là màn quan trọng nhất.

Nó không nên chỉ là một ô text lớn kiểu “Describe your scenario”.

Nó nên là một form có cấu trúc rõ ràng để:

- user điền dễ hơn
- backend tạo prompt ổn định hơn
- mobile có thể validate tốt hơn
- voice persona nhất quán hơn

### 4.3. Custom Practice Review Screen

Sau khi user điền xong, nên có một bước review tóm tắt:

- mục tiêu
- context
- vai trò của user
- vai trò AI
- tên AI / kiểu giọng
- độ khó
- cách sửa lỗi

CTA:

- `Bắt đầu luyện`
- `Chỉnh sửa`

### 4.4. Practice Session Screen

Sau khi xác nhận, app mở vào `Practice Session Screen` giống luồng scene thường.

Điểm khác là session này đến từ `custom config`, không phải từ `curated scene`.

---

## 5. Cấu trúc form khuyến nghị

## 5.1. Nhóm 1 - Mục tiêu buổi luyện

Field:

- `practiceGoal`
- `successOutcome`
- `topicSummary`

Mô tả:

- `practiceGoal`: mục tiêu tổng thể của user
- `successOutcome`: sau buổi luyện user muốn đạt được điều gì
- `topicSummary`: mô tả ngắn tình huống

Ví dụ:

- `practiceGoal`: Luyện phỏng vấn vị trí frontend intern
- `successOutcome`: Có thể tự tin giới thiệu bản thân và trả lời câu hỏi về dự án
- `topicSummary`: Buổi phỏng vấn online 15 phút với HR

## 5.2. Nhóm 2 - Bối cảnh hội thoại

Field:

- `contextType`
- `location`
- `conversationChannel`
- `timePressure`
- `specialConditions`

Mô tả:

- `contextType`: loại bối cảnh
  - `INTERVIEW`
  - `WORK`
  - `TRAVEL`
  - `PHONE_CALL`
  - `CUSTOMER_SERVICE`
  - `SOCIAL`
  - `MEDICAL`
  - `OTHER`
- `location`: nơi diễn ra
  - online
  - office
  - airport
  - restaurant
- `conversationChannel`:
  - `IN_PERSON`
  - `PHONE_CALL`
  - `VIDEO_CALL`
- `timePressure`:
  - `LOW`
  - `MEDIUM`
  - `HIGH`
- `specialConditions`: điều kiện đặc biệt
  - đang vội
  - đối phương khó tính
  - cần lịch sự cao

## 5.3. Nhóm 3 - Vai trò của user

Field:

- `userRole`
- `userIntent`
- `userEnglishLevel`
- `userPersonaNotes`

Mô tả:

- `userRole`: user đang đóng vai ai
  - ứng viên
  - khách hàng
  - hành khách
  - nhân viên
- `userIntent`: user muốn đạt mục tiêu gì trong cuộc nói chuyện
- `userEnglishLevel`: level hiện tại của user
- `userPersonaNotes`: ghi chú thêm

Ví dụ:

- `userRole`: Frontend intern candidate
- `userIntent`: Thuyết phục HR rằng mình phù hợp
- `userEnglishLevel`: INTERMEDIATE

## 5.4. Nhóm 4 - Vai trò của AI

Field:

- `aiRole`
- `aiDisplayName`
- `aiRelationshipToUser`
- `aiPrimaryGoal`
- `aiBehaviorStyle`

Mô tả:

- `aiRole`: AI đóng vai ai
  - HR recruiter
  - receptionist
  - waiter
  - customer
  - team lead
- `aiDisplayName`: tên hiển thị của nhân vật AI
  - Emma
  - Daniel
  - Lisa
- `aiRelationshipToUser`:
  - `INTERVIEWER`
  - `CUSTOMER`
  - `COLLEAGUE`
  - `MANAGER`
  - `SERVICE_STAFF`
  - `STRANGER`
- `aiPrimaryGoal`: mục tiêu chính của nhân vật AI trong hội thoại
- `aiBehaviorStyle`:
  - thân thiện
  - chuyên nghiệp
  - hơi khó tính
  - nhanh gọn
  - điềm tĩnh

## 5.5. Nhóm 5 - Persona và giọng AI

Field:

- `aiGenderPresentation`
- `aiVoicePreset`
- `aiVoiceTone`
- `aiSpeechSpeed`
- `aiAccentPreference`

Mô tả:

- `aiGenderPresentation`:
  - `MALE`
  - `FEMALE`
  - `NEUTRAL`
- `aiVoicePreset`:
  - preset giọng cụ thể nếu backend hỗ trợ
- `aiVoiceTone`:
  - `WARM`
  - `CALM`
  - `CONFIDENT`
  - `FRIENDLY`
  - `FORMAL`
- `aiSpeechSpeed`:
  - `SLOW`
  - `NORMAL`
  - `FAST`
- `aiAccentPreference`:
  - `US`
  - `UK`
  - `NEUTRAL`

Ghi chú:

- `aiGenderPresentation` ở đây phục vụ trải nghiệm persona và giọng nói
- không nên biến nó thành một lựa chọn quá nhạy cảm hoặc quá nặng nề trong UI
- nếu cần đơn giản ở phase đầu, chỉ cần:
  - `Nam`
  - `Nữ`
  - `Trung tính`

## 5.6. Nhóm 6 - Độ khó và coaching

Field:

- `difficulty`
- `conversationLength`
- `correctionStyle`
- `hintFrequency`
- `responseComplexity`

Mô tả:

- `difficulty`:
  - `BEGINNER`
  - `INTERMEDIATE`
  - `ADVANCED`
- `conversationLength`:
  - `SHORT`
  - `MEDIUM`
  - `LONG`
- `correctionStyle`:
  - `AFTER_RESPONSE`
  - `END_ONLY`
  - `GENTLE_INLINE`
  - `MINIMAL`
- `hintFrequency`:
  - `OFF`
  - `LOW`
  - `MEDIUM`
  - `HIGH`
- `responseComplexity`:
  - `SIMPLE`
  - `BALANCED`
  - `CHALLENGING`

## 5.7. Nhóm 7 - Nội dung cần tập trung

Field:

- `focusSkills`
- `mustUseVocabulary`
- `avoidTopics`
- `customInstructions`

Mô tả:

- `focusSkills`:
  - giới thiệu bản thân
  - đặt câu hỏi
  - thương lượng
  - xử lý phản đối
  - small talk
- `mustUseVocabulary`: danh sách từ / cụm từ user muốn luyện
- `avoidTopics`: chủ đề không muốn chạm vào
- `customInstructions`: ghi chú tự do

---

## 6. Form UI khuyến nghị cho mobile

### 6.1. Không nên dùng một màn form quá dài, phẳng

Khuyến nghị:

- chia thành các section card
- hoặc multi-step form 3 đến 5 bước

### 6.2. Flow stepper khuyến nghị

#### Step 1 - Goal

- practiceGoal
- successOutcome
- topicSummary

#### Step 2 - Context

- contextType
- location
- conversationChannel
- timePressure

#### Step 3 - Roles

- userRole
- aiRole
- aiDisplayName
- aiRelationshipToUser
- aiBehaviorStyle

#### Step 4 - Voice

- aiGenderPresentation
- aiVoicePreset
- aiVoiceTone
- aiSpeechSpeed
- aiAccentPreference

#### Step 5 - Learning Setup

- difficulty
- correctionStyle
- hintFrequency
- focusSkills
- mustUseVocabulary

### 6.3. Control types khuyến nghị

- text input cho goal/summary/instructions
- chips cho `difficulty`, `accent`, `tone`
- bottom sheet selector cho `role`, `contextType`
- segmented control cho `channel`
- optional text areas cho `customInstructions`

---

## 7. Dữ liệu backend nên nhận

## 7.1. Payload gợi ý

```json
{
  "practiceGoal": "Luyện phỏng vấn vị trí frontend intern",
  "successOutcome": "Tự tin giới thiệu bản thân và trả lời về dự án cá nhân",
  "topicSummary": "Buổi phỏng vấn online 15 phút với HR công ty công nghệ",
  "context": {
    "contextType": "INTERVIEW",
    "location": "Online video call",
    "conversationChannel": "VIDEO_CALL",
    "timePressure": "MEDIUM",
    "specialConditions": [
      "Professional setting",
      "Need concise answers"
    ]
  },
  "userProfile": {
    "userRole": "Frontend intern candidate",
    "userIntent": "Show confidence and explain project experience clearly",
    "userEnglishLevel": "INTERMEDIATE",
    "userPersonaNotes": "Thường bị run khi trả lời câu hỏi đột ngột"
  },
  "aiPersona": {
    "aiRole": "HR recruiter",
    "aiDisplayName": "Emma",
    "aiRelationshipToUser": "INTERVIEWER",
    "aiPrimaryGoal": "Evaluate communication, confidence, and role fit",
    "aiBehaviorStyle": "Professional but friendly",
    "aiGenderPresentation": "FEMALE",
    "aiVoicePreset": "emma_hr_warm_01",
    "aiVoiceTone": "CONFIDENT",
    "aiSpeechSpeed": "NORMAL",
    "aiAccentPreference": "US"
  },
  "learningConfig": {
    "difficulty": "INTERMEDIATE",
    "conversationLength": "MEDIUM",
    "correctionStyle": "END_ONLY",
    "hintFrequency": "LOW",
    "responseComplexity": "BALANCED",
    "focusSkills": [
      "Self introduction",
      "Project explanation",
      "Strengths and weaknesses"
    ],
    "mustUseVocabulary": [
      "internship",
      "responsive design",
      "team collaboration"
    ],
    "avoidTopics": [],
    "customInstructions": "Hãy giữ vai HR xuyên suốt và hỏi tiếp nối tự nhiên."
  }
}
```

---

## 8. Backend nên trả gì về cho mobile

Mobile không nên phải tự xây logic persona từ đầu.

Backend nên trả:

- `generatedSessionId`
- `sessionType`
- `displayTitle`
- `displaySubtitle`
- `sceneLikeSummary`
- `aiPersonaPreview`
- `voiceProfile`
- `startingInstructions`

Ví dụ:

```json
{
  "generatedSessionId": "custom-session-123",
  "sessionType": "CUSTOM_PRACTICE",
  "displayTitle": "Frontend Interview Practice",
  "displaySubtitle": "You are interviewing with Emma, an HR recruiter.",
  "sceneLikeSummary": {
    "category": "Interview",
    "difficulty": "INTERMEDIATE",
    "estimatedMinutes": 12
  },
  "aiPersonaPreview": {
    "name": "Emma",
    "role": "HR recruiter",
    "behaviorStyle": "Professional but friendly"
  },
  "voiceProfile": {
    "genderPresentation": "FEMALE",
    "voiceTone": "CONFIDENT",
    "accent": "US"
  },
  "startingInstructions": "Start with a short greeting and ask the candidate to introduce themselves."
}
```

---

## 9. Gắn vào flow Scene / Session hiện tại

## 9.1. Tư duy đúng

`Custom Practice` không cần trở thành `Scene` trong thư viện.

Nó chỉ cần được map thành:

- một `custom session config`
- rồi tạo ra `Session`

### 9.2. Nguồn tạo session

Session của Scenio từ nay nên có 2 nguồn:

- `CURATED_SCENE`
- `CUSTOM_PRACTICE`

### 9.3. UI result

Khi đã tạo xong, màn `Practice Session` vẫn dùng layout chung như scene thường:

- AI stage
- live caption / transcript
- voice / text interaction
- hint
- result

Điểm khác chỉ nằm ở:

- persona
- objective
- prompt config
- voice config

---

## 10. Các preset để user thao tác nhanh hơn

Để user không phải nhập quá nhiều, nên có preset card gợi ý:

- `Job Interview`
- `Talk to a Customer`
- `Phone Call with Receptionist`
- `Team Meeting`
- `Difficult Customer`
- `Travel Emergency`

Khi bấm preset, form được prefill:

- context
- roles
- difficulty mặc định
- giọng AI đề xuất

---

## 11. Màn hình review trước khi start

Trước khi vào session, nên có một summary card:

- `Goal`
- `Your role`
- `AI role`
- `AI voice`
- `Difficulty`
- `Coaching style`

Và 2 CTA:

- `Start Practice`
- `Edit`

Màn này giúp:

- user yên tâm là mình sắp luyện đúng thứ mình cần
- giảm lỗi do form quá dài

---

## 12. Những điều mobile không nên làm

- Không chỉ dùng một ô text duy nhất kiểu `Describe your scenario`
- Không bỏ qua `AI persona` vì nó ảnh hưởng lớn đến UX
- Không gộp `role`, `context`, `voice`, `difficulty` vào cùng một block mơ hồ
- Không để `Custom Practice` trông giống một form admin tạo content
- Không làm nó thành một màn kỹ thuật khô khan

---

## 13. Khuyến nghị triển khai phase đầu

### Phase 1

- form có cấu trúc
- chưa cần quá nhiều preset voice
- chỉ cần:
  - role
  - context
  - AI gender presentation
  - tone
  - difficulty
  - correction style
  - custom instructions

### Phase 2

- thêm voice preset thật
- thêm preview voice
- thêm preset theo ngành nghề

### Phase 3

- AI tự gợi ý config tốt hơn từ brief ngắn
- hybrid flow:
  - user nhập ngắn
  - system expand thành config đầy đủ

---

## 14. Kết luận ngắn

`Custom Practice Session` nên là một feature lõi của Scenio.

Nó giúp dự án đi đúng bản chất:

- học giao tiếp theo ngữ cảnh
- cá nhân hóa theo mục tiêu thật
- kết hợp được persona, role, context, và giọng AI

Về UX, đây không phải là `tạo scene như admin`.

Đây là:

- `tạo một buổi luyện nói đúng nhu cầu của user`

và hệ thống phải biến brief đó thành:

- một session thật sự có cấu trúc, có vai trò rõ ràng, có AI persona rõ ràng, và có voice configuration nhất quán.
