# Scenio Mobile Design System

> Design source of truth cho việc vibe code UI trong `scenio_client_mobile`.
> Mục tiêu của tài liệu này là biến một mẫu design chung thành hệ quy chiếu đúng với Scenio:
> một ứng dụng luyện giao tiếp tiếng Anh theo ngữ cảnh, có cảm giác nhẹ, hiện đại, dịu mắt,
> nhưng vẫn đủ immersive khi bước vào phiên luyện tập realtime với AI.

---

## 1. Visual Theme & Atmosphere

Scenio không nên trông như:

- app chat đại trà
- fintech dashboard
- game sci-fi nặng màu neon
- landing page marketing thiên về hype

Scenio nên trông như:

- một ứng dụng học tập hiện đại, có chiều sâu cảm xúc
- một không gian luyện nói an toàn, nhẹ nhàng, khuyến khích user mở miệng
- một sản phẩm "calm but alive"
- một hệ thống có đủ polish để user tin rằng AI partner đang thật sự hiện diện

### Tinh thần hình ảnh

Scenio nên đi theo hướng:

- **Liquid Glass nhẹ**
- **Sky-blue calmness**
- **Soft coaching warmth**
- **Voice-first interaction**

Tức là:

- nền sáng, thoáng, có độ trong nhẹ
- surface dùng lớp kính mờ mềm thay vì khối đặc nặng
- màu xanh là trục chính, nhưng không lạnh lẽo
- màu nhấn vàng ấm dành cho XP, thành tích, và động lực
- màu xanh lá chỉ dùng cho success / healthy progress / active state

### Trải nghiệm tổng thể

Toàn app có 2 nhịp chính:

1. **Browse / Learn Mode**
   - Home
   - Scenes
   - Profile
   - tone nhẹ, nhiều khoảng thở, card rõ ràng

2. **Practice / Realtime Mode**
   - Session screen
   - immersive hơn
   - ít chrome hơn
   - AI presence mạnh hơn
   - text không còn là trung tâm, mà là caption hỗ trợ

### Câu chốt về cảm giác

Scenio là:

- dịu
- tin cậy
- có chiều sâu
- không ồn
- không quá "AI slop"
- không generic

Nếu phải tóm gọn bằng một câu:

> **Scenio là một studio luyện giao tiếp bỏ túi, nơi mỗi scene là một không gian nói chuyện riêng với một AI partner có cá tính.**

---

## 2. Color Palette & Roles

### Nguồn sự thật hiện tại

Ưu tiên bám theo các token trong:

- `lib/app/core/constants/app_colors.dart`

Không hard-code màu mới trong widget nếu chưa thực sự cần. Nếu cần mở rộng palette, phải thêm token mới vào `AppColors` trước.

### Primary - Sky Blue System

- **`AppColors.primary900` `#2E628D`**
  - xanh đậm nhất
  - dùng cho phần cần độ tin cậy cao, chiều sâu, hoặc emphasis lớn

- **`AppColors.primary800` `#457FAF`**
  - màu primary mạnh nhất hiện tại trong app
  - dùng cho app bar, CTA chính, selected state

- **`AppColors.primary700` `#66A7DA`**
  - màu brand sáng hơn
  - dùng cho fill nổi bật, hero accent, illustration tint

- **`AppColors.primary500` `#8EC4EB`**
  - dùng cho active icon, highlight nhẹ, supportive tint

- **`AppColors.primary300` `#BFE2F8`**
  - border dịu, placeholder, tone nền soft

- **`AppColors.primary200` `#DBEEFB`**
  - divider, stroke, light border

- **`AppColors.primary50` `#F2F9FE`**
  - surface sáng, input fill, pale card background

### Secondary - Teal / Growth

- **`AppColors.secondary700` `#085041`**
  - success sâu, trạng thái bền vững

- **`AppColors.secondary500` `#1D9E75`**
  - online, completed, healthy progress

- **`AppColors.secondary300` `#5DCAA5`**
  - success tint nhẹ

- **`AppColors.secondary50` `#E1F5EE`**
  - background success

### Accent - Reward / Energy

- **`AppColors.accent500` `#EF9F27`**
  - XP
  - reward
  - streak
  - callout tích cực

- **`AppColors.accent200` `#FAC775`**
  - border / nhẹ cho reward or feedback highlight

- **`AppColors.accent50` `#FAEEDA`**
  - background dịu cho XP, badge, reward strip

### Neutral System

- **`AppColors.neutral900` `#2C2C2A`**
  - text chính

- **`AppColors.neutral700` `#444441`**
  - text phụ mạnh

- **`AppColors.neutral500` `#5F5E5A`**
  - body secondary, metadata

- **`AppColors.neutral300` `#B4B2A9`**
  - disabled, hint

- **`AppColors.neutral200` `#D3D1C7`**
  - border mặc định

- **`AppColors.neutral100` `#F1EFE8`**
  - nền ấm rất nhẹ

- **`AppColors.neutral50` `#F8F7F4`**
  - card surface mềm

### Semantic

- **Error:** `AppColors.error`
- **Error background:** `AppColors.errorBg`
- **Success:** `AppColors.success`
- **Success background:** `AppColors.successBg`
- **Warning:** `AppColors.warning`
- **Warning background:** `AppColors.warningBg`

### Chat / Session Specific

- **`AppColors.bubbleAi`**
  - AI bubble fill

- **`AppColors.bubbleUser`**
  - user bubble fill

- **`AppColors.bubbleAiBorder`**
  - AI bubble border

### Màu nền cấp app

- **`AppColors.background` `#F6FBFF`**
  - scaffold background
  - toàn app nên sáng, sạch và dễ thở

- **`AppColors.surface`**
  - card nền

### Quy tắc màu quan trọng

- Không dùng quá nhiều màu mạnh trên cùng một màn.
- Mỗi màn nên có một trục chính:
  - xanh cho học tập / điều hướng
  - vàng cho reward
  - xanh lá cho success
- Session screen không nên biến thành sân khấu neon.
- AI speaking animation có thể sáng hơn bình thường, nhưng vẫn phải cùng họ màu của Scenio.

---

## 3. Typography Rules

### Nguồn sự thật hiện tại

Ưu tiên bám theo:

- `lib/app/core/constants/app_text_styles.dart`

Font hiện tại là:

- **Plus Jakarta Sans**

Đây là lựa chọn đúng với Scenio vì:

- hiện đại
- mềm
- rõ
- đủ friendly cho app giáo dục
- đủ premium cho UI voice-first

### Triết lý chữ của Scenio

Chữ của Scenio nên:

- rõ
- mềm
- ấm
- không quá corporate
- không quá playful trẻ con
- không quá shouty

### Hệ phân cấp nên giữ

- `displayLarge`
  - cho hero số ít, section lớn, điểm nhấn rất quan trọng

- `displayMedium`
  - cho title lớn của feature / section

- `h1`, `h2`, `h3`
  - cho title màn, card headline, block heading

- `bodyLarge`, `bodyMedium`, `bodySmall`
  - cho nội dung đọc chính

- `labelLarge`, `labelMedium`, `labelSmall`
  - cho button, tab, pill, metadata

- `caption`
  - cho text phụ, micro state

### Quy tắc typography

- Ưu tiên **sentence case** hoặc **title case**.
- Không lạm dụng ALL CAPS.
- Heading của Scenio nên chắc nhưng không gắt.
- Body text luôn ưu tiên readability trước cá tính.
- Trong session screen, caption cần đủ to để đọc nhanh trong lúc nghe.

### Vai trò typographic đặc thù của Scenio

- `tagline`
  - dùng rất tiết chế
  - có thể xuất hiện ở hero hoặc onboarding

- `scoreNumber`
  - dùng cho result screen, progress, score card

- `xpPill`
  - dùng cho XP chip / streak / reward highlight

### Quy tắc khi vibe code

- Nếu màn hình đã dùng `AppTextStyles`, tiếp tục bám theo token sẵn có.
- Không tự nghĩ thêm font mới.
- Nếu một màn cần kiểu chữ mới, thêm token mới vào `AppTextStyles`, không inline style hàng loạt.

---

## 4. Component Stylings

## 4.1 Buttons

### Primary Button

- nền: `AppColors.primary800`
- text: trắng
- bo góc mềm, không quá vuông
- chiều cao dễ chạm
- cảm giác: tin cậy, sáng rõ, sạch

Dùng cho:

- Start Practice
- Continue Practice
- Save
- Confirm

### Secondary Button

- nền sáng hoặc kính mờ
- border nhẹ
- text primary

Dùng cho:

- View details
- Browse scenes
- Retry

### Tertiary / Ghost Button

- rất nhẹ
- không giành spotlight với CTA chính

Dùng cho:

- See all
- Dismiss
- Learn more

### Destructive Button

- không dùng đỏ đậm làm button chính trừ khi thật sự là destructive
- prefer outline nhẹ + confirm dialog

## 4.2 Cards

### Scene Card

Scene card là thành phần cốt lõi của trải nghiệm khám phá.

Nó nên:

- sáng
- rõ
- có độ thoáng
- có visual hierarchy tốt
- không nhồi quá nhiều thông tin

Một scene card nên có:

- title
- category
- difficulty
- estimated time
- character name / role
- description 1 dòng
- CTA rõ

### Mission Card

- có thể dùng nền accent50 hoặc primary50
- text rõ, ngắn
- tạo cảm giác "nhiệm vụ" chứ không phải card thông tin khô

### Character Card

- dùng trong scene detail
- giới thiệu AI partner
- nên có avatar / illustration / icon nhất quán
- có thể có tag `AI Partner`

### Progress Card

- dùng cho Home / Profile
- sạch, dễ quét
- score number nổi bật
- chart / metric phải là secondary, không lấn headline

## 4.3 Inputs

### Search Input

- nền `primary50`
- border tròn
- dịu
- không nặng viền

### Text Composer

Trong phase text-first:

- composer vẫn tồn tại
- nhưng không nên trông y hệt messenger composer

Nó nên:

- gọn
- nhẹ
- đóng vai trò fallback cho practice

## 4.4 Session / Voice Components

Đây là nhóm component rất quan trọng của Scenio.

### RealtimeConversationStage

Đây là visual trung tâm của session screen.

Không nên để transcript list chiếm vai trò này.

### ParticipantAvatarCard

Hiển thị:

- user
- AI partner

Nhưng AI partner phải có sức sống hơn avatar tĩnh.

### AiVoicePulseOrb / AiSpeakingHalo / SpeechEnergyVisualizer

Đây là cụm component đặc thù của Scenio realtime mode.

Khi AI nói:

- phải có pulse
- phải có glow
- phải có chuyển động nhịp nhàng
- user nhìn vào là hiểu "AI đang phản hồi"

Hiệu ứng nên gần tinh thần:

- Siri
- ChatGPT voice mode

nhưng được làm theo palette và chất liệu của Scenio.

### LiveCaptionStrip

- nằm dưới stage
- chỉ hiển thị đoạn gần nhất
- text rõ, ít dòng
- AI và user phân biệt rõ

### TranscriptBottomSheet

- transcript không nên chiếm full màn mặc định
- dùng bottom sheet hoặc expandable panel

### VoiceControlBar

- mic button lớn
- hint
- end
- optional text fallback

---

## 5. Layout Principles

### Mobile-first

Scenio là mobile app trước.
Mọi layout phải ưu tiên cảm giác thoải mái trên màn hình điện thoại.

### Hai loại layout chính

#### Browse Layout

Dùng cho:

- Home
- Scenes
- Profile

Đặc điểm:

- nhiều card
- section rõ
- có vertical rhythm
- có khoảng thở

#### Practice Layout

Dùng cho:

- Session screen

Đặc điểm:

- immersive hơn
- ít distraction hơn
- tập trung vào conversation stage
- bottom nav nên được ẩn

### Khoảng cách

Ưu tiên hệ spacing mềm, đều, dễ nhớ.

Khi viết UI:

- dùng `AppDimensions`
- không hard-code spacing bừa bãi

Nhịp spacing nên cho cảm giác:

- nhẹ
- đủ thở
- không chật
- không quá phung phí

### Safe Area và Gesture

- chú ý notch
- chú ý bottom inset
- session control bar không bị dính đáy khó bấm

### Session layout rule

Practice Session screen nên theo thứ tự:

1. Header
2. Stage realtime
3. Live caption
4. Optional transcript sheet
5. Control bar

Không nên:

- đặt transcript list lên trên stage
- đặt chat bubble làm trung tâm màn hình

---

## 6. Depth & Elevation

Scenio dùng depth mềm, không dùng shadow nặng kiểu ecommerce.

### Philosophy

- bề mặt có lớp
- nhưng không "đè" nhau
- glass nhẹ hơn shadow nặng

### Hướng elevation

| Level | Treatment | Use |
|---|---|---|
| 0 | Không shadow | nền cơ bản |
| 1 | Shadow rất nhẹ + border mềm | card thông thường |
| 2 | Glass card + subtle shadow | sticky bar, highlight card |
| 3 | Glow nhẹ + soft shadow | active component |
| 4 | Pulse / halo / light bloom | AI speaking state |

### Liquid Glass Direction

Scenio nên dùng Liquid Glass theo kiểu:

- translucent fill nhẹ
- border sáng mờ
- blur vừa phải
- ánh sáng dịu

Không nên:

- blur dày đặc
- kính quá trắng
- quá nhiều glow tím / xanh cyber

### AI speaking depth

Khi AI đang nói, depth không đến từ card shadow mà đến từ:

- glow mềm
- pulse ring
- energy waveform
- subtle highlight halo

---

## 7. Do's and Don'ts

### Do

- **Do** giữ tinh thần app học giao tiếp theo ngữ cảnh, không biến nó thành app chat generic.
- **Do** dùng `AppColors`, `AppTextStyles`, `AppDimensions` làm token source of truth.
- **Do** ưu tiên `Practice Session` như một immersive experience.
- **Do** để AI có visual presence khi nói.
- **Do** dùng motion có chủ đích cho `thinking`, `speaking`, `listening`.
- **Do** giữ Home và Scenes đủ thoáng, đủ friendly, dễ bắt đầu.
- **Do** thiết kế Scene Detail như màn "thuyết phục user vào buổi luyện".
- **Do** dùng reward accent tiết chế để làm nổi XP và thành tựu.
- **Do** giữ sentence case cho phần lớn UI text.
- **Do** bám kiến trúc MVVM + GetX của repo.

### Don't

- **Don't** bê nguyên pattern của messenger app vào session screen.
- **Don't** để AI chỉ là avatar tĩnh.
- **Don't** dùng quá nhiều gradient tím / hồng / cyber glow.
- **Don't** hard-code màu và text style trong widget.
- **Don't** biến mỗi màn thành một phong cách khác nhau hoàn toàn.
- **Don't** làm screen quá bận, quá nhiều badge, quá nhiều pill cùng lúc.
- **Don't** cho transcript chiếm hết màn session theo mặc định.
- **Don't** dùng visual voice mode như loading spinner.
- **Don't** làm UI quá nghiêm như dashboard doanh nghiệp.

---

## 8. Responsive Behavior

### Breakpoints

Flutter mobile của Scenio chủ yếu tối ưu cho:

- điện thoại nhỏ
- điện thoại chuẩn
- điện thoại lớn
- tablet ở mức hỗ trợ hợp lý

### Quy tắc responsive

- card co giãn nhẹ, không thay đổi cấu trúc quá cực đoan
- stage realtime phải luôn giữ được trọng tâm thị giác
- caption area không bị thu quá nhỏ
- mic button phải luôn nằm trong vùng dễ chạm

### Session screen trên máy nhỏ

- stage được ưu tiên
- transcript history mặc định đóng
- control bar gọn hơn

### Session screen trên máy lớn

- stage có thể rộng hơn
- transcript sheet có thể mở lớn hơn
- caption và control bar có nhiều breathing room hơn

---

## 9. Agent Prompt Guide

Phần này dành cho những lần vibe code UI sau này.

### Quick Reference

- App vibe: `calm, modern, supportive, voice-first`
- Brand feeling: `Every scene. A new voice.`
- Core mode: `learning by contextual conversation`
- Visual language: `soft liquid glass with sky-blue calmness`
- Session mode: `immersive practice console, not a messenger`
- AI presence: `avatar + AI badge + speaking pulse`

### Component Prompt Examples

1. *"Create a Scene Detail screen for Scenio using the existing AppColors/AppTextStyles tokens. The screen should feel calm, modern, and lightly premium. Show scene title, difficulty, mission, a character intro card, vocabulary preview, and a strong Start Practice CTA. Use soft liquid-glass surfaces and avoid generic ecommerce card styling."*

2. *"Design a Practice Session screen for a contextual English-speaking app. The center of the layout is a realtime conversation stage, not a chat list. Show the AI partner with a speaking pulse halo and subtle waveform animation, plus live caption text below. The UI should feel focused, immersive, and friendly, with a large mic button and a secondary hint button."*

3. *"Create a Home section for recommended scenes using Scenio's baby-sky-blue palette, warm reward accents, and clean rounded cards. The layout should feel breathable and encouraging, not productivity-heavy."*

4. *"Design an AI speaking visual for Scenio: a character avatar combined with a soft pulse ring, liquid waveform halo, and subtle glow that reacts to speaking state. It should feel more like Siri or ChatGPT voice mode than a static chatbot avatar."*

5. *"Build a Session Result screen with a celebratory but clean tone. Show XP earned, grammar/vocabulary/naturalness scores, and transcript access. Use accent color for reward moments without turning the whole screen into a game UI."*

### Iteration Guide

Khi review một màn UI được generate:

1. Kiểm tra xem màn đó có còn đúng sản phẩm Scenio không, hay đang bị generic hóa.
2. Kiểm tra token có bám `AppColors` và `AppTextStyles` không.
3. Kiểm tra session screen có đang bị thiết kế như messenger không.
4. Kiểm tra AI presence có đủ mạnh không.
5. Kiểm tra hierarchy có rõ không, đặc biệt giữa title, caption, CTA và status.
6. Kiểm tra reward accent có đang bị dùng quá tay không.
7. Kiểm tra liquid-glass effect có mềm và tinh tế không, hay đang bị lạm dụng blur.
8. Kiểm tra layout có còn thoáng, dễ thở, đúng tinh thần luyện tập không.

### Rule cuối cùng

Nếu phải chọn giữa:

- nhìn "ấn tượng ngay"
- và nhìn "đúng với một app luyện giao tiếp mà user muốn quay lại hằng ngày"

thì luôn chọn phương án thứ hai.
