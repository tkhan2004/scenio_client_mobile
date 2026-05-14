# Scenio Mobile - Scene, Session, Chat Feature Spec

## 1. Mục tiêu của feature này

Scenio không chỉ là app chat text với AI. Mục tiêu sản phẩm là để người học luyện giao tiếp tiếng Anh theo từng tình huống thực tế như:

- gọi món ở quán cafe
- check-in ở sân bay
- phỏng vấn xin việc
- nói chuyện với lễ tân khách sạn

Về lâu dài, người dùng sẽ có cảm giác như đang "nói chuyện điện thoại" với AI trong một bối cảnh cụ thể. Tuy nhiên ở phase mobile hiện tại, team nên thiết kế UI theo hướng:

- text-first để dễ triển khai và test
- voice-ready để sau này nâng cấp sang realtime voice mà không phải đập lại toàn bộ màn hình

Nói ngắn gọn:

- `Scene` là nơi người dùng chọn bối cảnh luyện tập
- `Session` là một lần luyện tập cụ thể trong bối cảnh đó
- `Chat` là giao diện đang diễn ra của một session

## 2. Cách hiểu 3 khái niệm chính

### 2.0 Nguồn tạo session trong Scenio

Một `Session` trong Scenio không chỉ đến từ `scene có sẵn`.

Về lâu dài, session nên có 2 nguồn:

- `Curated Scene`
- `Custom Practice Brief`

Điều này có nghĩa là:

- user có thể chọn một scene có sẵn trong thư viện
- hoặc tự mô tả một tình huống thật mà mình muốn luyện

Trong cả hai trường hợp, đầu ra cuối cùng vẫn là:

- một `Practice Session` để user bắt đầu nói chuyện với AI

Chi tiết riêng cho luồng `Custom Practice` được mô tả ở:

- `sample/CUSTOM_PRACTICE_SESSION_SPEC.md`

### 2.1 Scene

`Scene` là một kịch bản học tiếng Anh. Mỗi scene trả lời câu hỏi:

- người dùng đang ở đâu
- đang nói chuyện với ai
- mục tiêu giao tiếp là gì
- độ khó bao nhiêu
- nên học trong bao lâu

Ví dụ:

- `At the Restaurant`
- nhân vật AI: `Jake`
- vai trò AI: `Waiter`
- mission: hoàn thành cuộc gọi món từ lúc order đến lúc thanh toán

Về mặt UI, `Scene` giống một "practice card" hoặc "learning scenario".

### 2.2 Session

`Session` là một lần người dùng bấm vào scene và bắt đầu luyện thật.

Một user có thể luyện cùng một scene nhiều lần, nên:

- `Scene` là template học
- `Session` là attempt thực tế

Session có trạng thái:

- `ACTIVE`: đang học
- `COMPLETED`: học xong
- `ABANDONED`: thoát giữa chừng

### 2.3 Chat

`Chat` không nên được hiểu là một module messenger độc lập như Zalo/Messenger.

Trong Scenio, `Chat` thực chất là "màn luyện tập đang diễn ra" của một `Session`.

Nó có thể bắt đầu bằng text, nhưng về lâu dài sẽ thành:

- voice input
- AI trả audio
- transcript realtime
- trạng thái nghe / nói / chờ phản hồi

Vì vậy, mobile dev nên coi chat screen là:

`Practice Session Screen`

chứ không phải generic chat screen.

## 3. Đề xuất lại bottom navigation

Hiện mock cũ đang có:

- Home
- Scene
- Chat
- Profile

Home và Profile đã có rồi. Với phần còn lại, khuyến nghị nên chỉnh cách hiểu như sau:

### Option khuyến nghị

- `Home`
- `Scenes`
- `Practice`
- `Profile`

Lý do:

- `Scenes` là tab khám phá thư viện tình huống
- `Practice` là nơi vào session đang active hoặc empty state nếu chưa có session nào
- tên `Practice` đúng bản chất sản phẩm hơn `Chat`

### Nếu vẫn giữ tên `Chat`

Vẫn dùng được, nhưng nên hiểu:

- `Scenes` = thư viện để chọn tình huống
- `Chat` = entry point vào phiên luyện tập đang active

Trong trường hợp này, tab `Chat` không phải nơi list nhiều cuộc trò chuyện, mà chỉ là:

- resume session đang học
- hoặc hiện empty state "Choose a scene to start practicing"

### Khuyến nghị UI quan trọng

Khi user đã vào màn chat/session đang diễn ra, nên ẩn bottom nav để tạo cảm giác tập trung và immersive hơn.

Bottom nav chỉ nên xuất hiện ở:

- Home
- Scene discovery
- Practice empty/resume shell
- Profile

## 4. User flow tổng thể

## 4.1 Flow chính

1. User mở app vào `Home`
2. Home hiển thị:
   - greeting
   - daily missions
   - recommended scenes
   - session đang active nếu có
3. User bấm vào một scene từ Home hoặc tab `Scenes`
4. Mở `Scene Detail`
5. User bấm `Start Practice`
6. Backend tạo `Session`
7. Mở `Practice Session Screen`
8. User luyện hội thoại với AI
9. Kết thúc buổi học
10. Mở `Session Result Screen`
11. User quay lại Home hoặc tiếp tục scene khác

## 4.2 Flow resume

1. User đang có session `ACTIVE`
2. Từ Home hoặc tab `Practice`, user thấy nút `Continue Session`
3. Bấm vào để quay lại đúng session đang học

## 4.3 Flow abandoned

1. User đang luyện nhưng thoát giữa chừng
2. Backend mark session là `ABANDONED`
3. Session không còn hiển thị là active nữa
4. User có thể start lại từ scene detail

## 5. Những màn hình mobile nên có

## 5.1 Scenes Tab - Scene Discovery Screen

Đây là màn hình để user tìm scene phù hợp.

Nội dung nên có:

- search bar
- filter theo category
- filter theo difficulty
- recommended scenes section
- scene list/grid

Một scene card nên hiển thị:

- title
- category
- difficulty
- estimated time
- character name / role
- 1 dòng description ngắn

CTA gợi ý:

- `Start`
- hoặc `View details`

API backend có thể dùng:

- `GET /api/scenes`
- `GET /api/scenes/search`
- `GET /api/scenes/recommend`

## 5.2 Scene Detail Screen

Đây là màn hình giúp user hiểu mình sắp luyện cái gì trước khi vào session.

Nội dung nên có:

- title scene
- category
- difficulty
- estimated minutes
- description
- mission text
- AI character card
  - character name
  - character role
- vocabulary preview
- CTA chính

CTA theo trạng thái:

- nếu chưa có session active: `Start Practice`
- nếu đã có session active của scene này: `Continue Practice`
- nếu có session active ở scene khác: hiển thị cảnh báo nhẹ, ưu tiên resume session cũ

API backend:

- `GET /api/scenes/:id`
- `POST /api/sessions/start`

## 5.3 Practice Tab / Practice Shell Screen

Màn này là shell khi user bấm tab `Practice` từ bottom nav.

Trường hợp 1: có session active

- hiển thị thẻ `Resume current session`
- scene title
- character
- started at
- progress summary sơ bộ

Trường hợp 2: chưa có session active

- empty state minh họa
- title kiểu `Start your next conversation`
- nút `Browse Scenes`

Màn này không cần quá nặng. Nó chủ yếu đóng vai trò điều hướng đúng vào session đang active.

## 5.4 Practice Session Screen

Đây là màn quan trọng nhất của sản phẩm.

Mục tiêu UX:

- user cảm thấy mình đang "đóng vai" trong một tình huống thực tế
- không giống app chat thông thường
- sẵn sàng nâng cấp lên voice realtime sau này

### Direction khuyến nghị

Màn này nên đi theo hướng:

- `realtime conversation UI`
- `voice-first layout`
- `text as caption/transcript`

Tức là không nên lấy mô hình chính là list bubble chat như Messenger.

Text vẫn rất quan trọng, nhưng vai trò của nó nên là:

- caption ở phía dưới để user đọc nhanh câu vừa nói
- transcript history để xem lại
- fallback khi phase đầu vẫn đang chat text

UI trung tâm nên thể hiện:

- tôi đang nói chuyện với AI
- AI là một nhân vật cụ thể
- AI có avatar hoặc logo riêng
- ai đang nói thì người đó được nhấn mạnh bằng animation/state

### Điểm cần chốt thêm cho team mobile

Avatar AI không nên chỉ là hình tĩnh.

Khi AI nói, phần đại diện của AI cần có chuyển động nhịp nhịp, sống động, kiểu:

- Siri khi đang phản hồi
- ChatGPT voice mode khi đang nói
- voice orb / audio pulse / speaking halo

Nói ngắn gọn:

- AI phải có `presence`
- user phải nhìn vào màn hình là biết ngay `AI đang nói`, `AI đang nghĩ`, hay `AI đang chờ`
- animation này là một phần của UX cốt lõi, không phải chi tiết trang trí

### Layout đề xuất

#### 1. Header

- scene title
- AI character name + role
- badge difficulty
- menu phụ: hint, leave, more

#### 2. Realtime stage

Đây là phần visual chính của màn hình.

- avatar hoặc logo của user
- avatar hoặc logo của AI character
- hiệu ứng active speaker
- glow / ring / pulse khi đang nói
- trạng thái ngắn:
  - `Listening`
  - `Speaking`
  - `Thinking`
  - `Paused`

### Visual chính của AI nên như thế nào

Khuyến nghị tốt nhất là dùng:

- `Character Avatar`
- cộng với `AI voice aura`
- cộng với `speech visualizer`

Tức là AI có một chân dung hoặc logo chính, nhưng xung quanh nó có lớp motion để thể hiện trạng thái realtime.

### Cấu trúc visual đề xuất cho AI

#### Lớp 1 - Avatar nhân vật

- hình đại diện của nhân vật trong scene
- ví dụ: barista, receptionist, airport staff, interviewer
- đây là lớp giúp user cảm nhận đúng ngữ cảnh roleplay

#### Lớp 2 - AI indicator

- label nhỏ như `AI`
- hoặc badge `AI Partner`
- mục tiêu là để user hiểu đây là nhân vật AI, không phải người thật

#### Lớp 3 - Voice animation layer

Đây là lớp rất quan trọng.

Khi AI đang nói, quanh avatar nên có một trong các hiệu ứng sau:

- vòng sáng co giãn theo nhịp
- waveform tròn bao quanh avatar
- blob mềm dao động
- các thanh sóng đối xứng ở hai bên
- ánh sáng pulse theo biên độ giọng nói

Khuyến nghị:

- không dùng waveform kỹ thuật quá cứng
- nên dùng motion mềm, hữu cơ, hơi "liquid" để hợp với hướng UI của Scenio
- animation phải nhìn "đang giao tiếp", không giống loading spinner

### Mapping trạng thái AI ra animation

- `Idle`
  - avatar đứng yên
  - chỉ có nhịp thở rất nhẹ
  - glow rất nhỏ

- `Listening`
  - AI không pulse mạnh
  - có viền sáng nhẹ cho biết AI đang chờ user nói
  - mic zone của user là phần được nhấn mạnh hơn

- `Thinking`
  - chuyển sang shimmer / orbit / soft rotating glow
  - không nên dùng pulse như đang nói
  - cần cho cảm giác AI đang xử lý

- `Speaking`
  - đây là state phải nổi bật nhất
  - vòng sáng / waveform / blob nhịp theo giọng
  - có thể scale 1.0 -> 1.08 -> 1.0 theo beat mềm
  - caption phía dưới update theo transcript

- `Paused / Disconnected`
  - motion dừng lại
  - màu giảm bão hòa
  - hiển thị trạng thái rõ ràng

AI nên được biểu diễn bằng:

- character avatar nếu scene mang tính roleplay rõ
- hoặc logo/avatar AI đồng nhất của Scenio nếu muốn thống nhất branding

Khuyến nghị tốt nhất là kết hợp cả hai:

- avatar chính mang tính nhân vật
- kèm label phụ cho biết đây là AI

Ví dụ:

- `Mia`
- `Barista`
- `AI Partner`

### Công thức hiển thị AI được khuyến nghị

`Character Avatar + AI Badge + Speaking Pulse`

Đây nên là pattern mặc định cho mọi scene voice session.

Nếu chưa đủ asset avatar cho từng nhân vật, vẫn nên giữ:

- 1 avatar nền thống nhất của Scenio
- tên nhân vật
- vai trò nhân vật
- speaking pulse riêng theo state

Không nên để fallback là icon robot đứng yên hoàn toàn.

#### 3. Live caption area

Đây là phần text ở dưới màn hình, không phải thân chính của UI.

Nội dung:

- câu AI vừa nói
- câu user vừa nói
- partial transcript nếu đang realtime
- subtitle 1-2 dòng

Khuyến nghị:

- chỉ hiển thị đoạn gần nhất
- text to, dễ đọc
- tách rõ `AI` và `You`
- có thể dùng 2 dòng:
  - dòng trên: câu AI
  - dòng dưới: câu user

#### 4. Transcript history

Transcript đầy đủ không nên chiếm toàn bộ màn hình ngay từ đầu.

Nó nên là:

- bottom sheet kéo lên
- hoặc panel có thể expand

Khi thu gọn:

- chỉ hiện live caption

Khi mở rộng:

- xem toàn bộ lịch sử đối thoại
- xem hint
- xem message lỗi hoặc gợi ý sửa

#### 5. Control bar

Thanh control dưới cùng nên tối ưu cho realtime practice:

- mic button lớn ở giữa
- end session button
- hint button
- text input fallback nhỏ hơn hoặc secondary action

Nếu phase đầu chưa có voice thật, vẫn nên giữ bố cục này.

Lúc đó:

- mic button có thể là `coming soon` hoặc `hold to talk` giả lập
- text input vẫn hoạt động
- caption area vẫn dùng để hiển thị câu gần nhất

### Wireframe tinh thần

```text
 -------------------------------------------------
|  Airport Check-in                 Hint   Leave  |
|  David - Check-in Staff (AI)                    |
|-------------------------------------------------|
|                                                 |
|            [ You Avatar ]   [ AI Avatar ]       |
|                                                 |
|     You: Listening      AI: Speaking ~~~        |
|                                                 |
|     AI side: pulse ring / liquid waveform       |
|     User side: mic ring / listening state       |
|                                                 |
|-------------------------------------------------|
| AI: "Sure, may I see your passport?"            |
| You: "Yes, here it is."                         |
|-------------------------------------------------|
|      [ Hint ]   [ Big Mic ]   [ End ]           |
|    [ text fallback input if needed below ]      |
 -------------------------------------------------
```

### Context strip

- mission text ngắn
- trạng thái session: active / listening / ai speaking / paused

### Composer / controls

- phase text-first:
  - input text
  - send button
  - mic button ở trạng thái disabled hoặc coming soon
- phase voice:
  - large mic button
  - waveform / speaking indicator
  - live transcript
  - mute / speaker states

### State machine mà UI nên chuẩn bị

- `idle`
- `starting`
- `active`
- `userTyping`
- `userListening`
- `aiThinking`
- `aiSpeaking`
- `paused`
- `finishing`
- `completed`
- `abandoned`
- `error`

### Điểm UX quan trọng

- không lấy transcript bubble làm trung tâm màn hình
- trung tâm màn hình nên là 2 chủ thể đang giao tiếp: user và AI
- AI avatar/logo cần đủ rõ để user cảm nhận đây là partner trong buổi luyện
- AI avatar phải có motion khi nói, không được là hình tĩnh đơn thuần
- text nên đóng vai trò caption và transcript support
- background có thể subtle theo từng scene category
- composer nên ít giống app chat đại trà, nhiều cảm giác "practice console"
- cần nút `Hint` rõ ràng nhưng không lấn át CTA chính
- khi AI đang nói, avatar AI nên được active rõ ràng
- khi user đang nói, avatar user hoặc mic zone nên được active rõ ràng
- state `AI speaking` và `AI thinking` phải nhìn khác nhau rõ rệt

### Điều team mobile không nên làm

- không dùng avatar tĩnh + đổi mỗi text status
- không biến visual speaking thành loading spinner
- không làm waveform quá nhỏ đến mức chỉ là chi tiết trang trí
- không để transcript chiếm mất vai trò của stage realtime

## 5.5 Session Result Screen

Sau khi kết thúc session, user cần thấy cảm giác "mình vừa hoàn thành một buổi luyện".

Nội dung nên có:

- trạng thái: completed / abandoned
- xp earned
- hint count
- 3 skill scores:
  - grammar
  - vocabulary
  - naturalness
- transcript section
- button `Practice Again`
- button `Back to Home`

API backend:

- `GET /api/sessions/:id/result`
- `PATCH /api/sessions/:id/abandon`
- `POST /api/users/xp`

## 6. Mapping với backend hiện tại

## 6.1 Scene data

Backend hiện đang có đủ dữ liệu để dựng scene card và scene detail:

- `id`
- `title`
- `category`
- `description`
- `missionText`
- `difficulty`
- `estimatedMinutes`
- `characterName`
- `characterRole`
- `vocabulary[]`

Điều này đủ để mobile dựng:

- scene list
- scene detail
- header cho practice session

## 6.2 Session data

Backend session hiện tại đã có:

- `id`
- `sceneId`
- `status`
- `xpEarned`
- `hintCount`
- `startedAt`
- `endedAt`
- `messages[]`
- `scores`

Điều này đủ để mobile dựng:

- resume state
- result screen
- transcript screen

## 6.3 Home integration

Home hiện đã có các section rất phù hợp để nối với Scene/Session:

- recommended scenes
- daily missions
- continue learning

Mobile dev chỉ cần xem Home như điểm vào nhanh cho:

- mở scene detail
- resume session active

## 7. Đề xuất route và page map cho mobile

Đây là gợi ý route-level, không bắt buộc đúng tên kỹ thuật.

- `/home`
- `/scenes`
- `/scenes/:id`
- `/practice`
- `/sessions/:id`
- `/sessions/:id/result`
- `/profile`

Nếu team vẫn muốn bám bottom nav cũ:

- `home`
- `scenes`
- `chat`
- `profile`

thì mapping nên là:

- `chat tab` -> `/practice`
- active session screen thật -> `/sessions/:id`

Tức là tab và session screen không nhất thiết là cùng một màn.

## 8. Đề xuất component tree cho Scene và Session

## 8.1 Scene Discovery

- `SceneSearchBar`
- `SceneFilterChips`
- `RecommendedSceneSection`
- `SceneCard`
- `SceneEmptyState`

## 8.2 Scene Detail

- `SceneHeroHeader`
- `SceneMetaRow`
- `SceneMissionCard`
- `CharacterIntroCard`
- `VocabularyPreviewList`
- `StartPracticeButton`

## 8.3 Practice Session

- `SessionHeader`
- `RealtimeConversationStage`
- `ParticipantAvatarCard`
- `AiVoicePulseOrb`
- `AiSpeakingHalo`
- `SpeechEnergyVisualizer`
- `ActiveSpeakerRing`
- `LiveCaptionStrip`
- `TranscriptBottomSheet`
- `SessionMissionStrip`
- `ConversationList`
- `MessageBubble`
- `HintBubble`
- `SessionComposer`
- `VoiceControlBar`
- `SessionLeaveDialog`

## 8.4 Result

- `ResultHeroCard`
- `XpRewardChip`
- `SkillScoreCards`
- `TranscriptSection`
- `ResultActionBar`

## 9. Realtime voice về sau sẽ ảnh hưởng UI như thế nào

Theo direction hiện tại của backend, về lâu dài app sẽ hỗ trợ realtime voice với AI.

Điều đó có nghĩa là Practice Session Screen nên được thiết kế để dễ nâng cấp thêm:

- mic state
- listening indicator
- AI speaking indicator
- waveform
- partial transcript
- reconnect state

### Điều mobile dev nên chuẩn bị từ bây giờ

- đừng khóa UX vào text-only chat bubble
- composer nên có chỗ cho mic button lớn
- transcript list nên hỗ trợ cả text final và text đang stream
- header nên có room cho trạng thái realtime
- stage trung tâm nên được dựng theo hướng có thể cắm animation AI speaking ngay
- nên tách riêng widget animation AI để sau này đổi từ pulse đơn giản sang waveform đẹp hơn mà không đụng layout

### Gợi ý motion design ở phase đầu

Ngay cả khi phase đầu chưa có realtime voice thật, UI vẫn nên mock được 4 motion state cơ bản:

- `AI idle pulse`
- `AI thinking shimmer`
- `AI speaking pulse`
- `User listening / mic active`

Như vậy tới lúc backend/provider voice cắm vào, team chỉ cần nối state thật vào widget có sẵn.

### Điều chưa cần làm ngay

- chưa cần thiết kế call screen quá phức tạp như app họp online
- chưa cần thêm nhiều control như switch camera, room members, vv
- chưa cần mô phỏng WebRTC detail ở UI phase đầu

Mục tiêu phase đầu chỉ là:

- text practice đẹp và rõ
- có chỗ để sau này bật voice lên

## 10. Khuyến nghị quan trọng cho team mobile

### Khuyến nghị 1

Đừng xem `Chat` là tab chính theo nghĩa messenger. Hãy xem nó là cửa vào `Practice`.

### Khuyến nghị 2

`Scene Detail` là màn rất quan trọng. Nó quyết định user có muốn bắt đầu buổi luyện hay không.

### Khuyến nghị 3

`Practice Session Screen` nên là full-screen experience, tách khỏi cảm giác bottom-nav app thường.

### Khuyến nghị 4

Luôn thiết kế cả:

- loading state
- empty state
- error state
- no active session state

### Khuyến nghị 5

Nếu phải chốt naming ngay bây giờ, nên dùng:

- `Scenes`
- `Practice`

thay vì:

- `Scene`
- `Chat`

vì nó gần đúng với sản phẩm sau cùng hơn.

## 11. Bản tóm tắt ngắn cho mobile dev

Nếu cần hiểu thật nhanh, chỉ cần nhớ:

- `Scene` = user chọn tình huống để học
- `Session` = một lần user luyện tập thật trong tình huống đó
- `Chat` = màn đang diễn ra của session, sau này sẽ lên voice realtime
- Home là nơi khám phá nhanh và resume
- Scenes là thư viện tình huống
- Practice là entry point vào buổi luyện hiện tại
- Profile là nơi xem tiến độ, badge, lịch sử học

UI cần làm tiếp nên xoay quanh 4 màn:

- Scene Discovery
- Scene Detail
- Practice Session
- Session Result

Direction quan trọng nhất của Practice Session là:

- UI giống một cuộc hội thoại realtime giữa `tôi` và `AI`
- AI được đại diện bằng avatar hoặc logo
- khi AI nói, phần đại diện này phải có animation nhịp nhịp kiểu voice assistant
- text nằm phía dưới như live caption và transcript
