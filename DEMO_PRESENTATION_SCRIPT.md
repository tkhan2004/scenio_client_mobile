# Kịch bản thuyết trình demo Scenio end-to-end

Mục tiêu file này: dùng để đọc theo luồng khi thuyết trình và demo app.  
Luồng chính: **Đăng ký -> thu thập thông tin -> tạo roadmap -> vào Home -> luyện hội thoại -> AI chấm điểm -> AI gợi ý bước tiếp theo -> xem lịch sử -> ôn từ vựng**.

Ưu tiên khi demo:

- **MVP cần trình bày kỹ:** đăng ký, onboarding, roadmap cá nhân hóa, Home đề xuất theo roadmap, voice conversation, transcript, chấm điểm, AI gợi ý luyện tiếp, history, vocabulary.
- **Feature phụ trình bày lướt:** notifications, XP/streak, nhiệm vụ hôm nay, profile tổng quan, trạng thái lỗi thân thiện, custom practice nâng cao.
- **Thông điệp xuyên suốt:** Scenio không chỉ là chatbot, mà là vòng học hoàn chỉnh: hiểu người học -> tạo lộ trình -> luyện hội thoại -> chấm điểm -> đề xuất bước tiếp theo.

---

## 0. Chuẩn bị trước khi demo

### Cần mở sẵn

- Backend đang chạy.
- App mobile đang chạy trên simulator hoặc máy thật.
- Tài khoản demo chưa onboarding hoặc có thể đăng ký mới.
- Microphone đã được cấp quyền.
- Nếu dùng voice realtime, chuẩn bị mạng ổn định.

### Dữ liệu nên có để demo mượt

- Một roadmap đang có ít nhất một bước **Sẵn sàng**.
- Một session đã hoàn thành để demo lịch sử.
- Một vài từ đã lưu trong Vocabulary để demo phần ôn tập.

### Câu mở đầu cho người nghe

**Nói:**

> Em xin trình bày Scenio, một ứng dụng luyện giao tiếp tiếng Anh theo ngữ cảnh. Điểm chính của app không chỉ là cho người dùng nói chuyện với AI, mà là app sẽ thu thập mục tiêu học, tạo lộ trình cá nhân hóa, cho luyện hội thoại bằng voice, chấm điểm theo transcript, rồi gợi ý người dùng nên luyện gì tiếp theo.

**Nhấn mạnh:**

- Đây là luồng học khép kín, không phải chỉ là chatbot.
- Mỗi phiên học tạo dữ liệu để cập nhật feedback, roadmap và đề xuất tiếp theo.
- Trong bài demo, em sẽ đi kỹ phần MVP. Các feature phụ như XP, thông báo và profile em sẽ giới thiệu nhanh để người nghe thấy sản phẩm đã có hệ sinh thái đầy đủ.

### Bố cục demo đề xuất

- 60 giây: giới thiệu vấn đề và mục tiêu sản phẩm.
- 2 phút: đăng ký, onboarding và roadmap.
- 4-5 phút: Home -> roadmap step -> voice session -> transcript.
- 3-4 phút: result, chấm chi tiết, AI gợi ý luyện tiếp, history.
- 1-2 phút: vocabulary, profile, notifications, XP/streak.
- 60 giây: tổng kết kiến trúc và giá trị sản phẩm.

---

## 1. Đăng ký tài khoản

### Thao tác

1. Mở app.
2. Ở màn đăng nhập, chọn **Đăng ký ngay**.
3. Nhập thông tin tài khoản demo.
4. Bấm đăng ký.

### Nói

> Đầu tiên người dùng tạo tài khoản. Sau khi đăng ký, hệ thống không đưa ngay vào màn chính, mà sẽ chuyển qua bước lấy thông tin học tập ban đầu. Đây là phần quan trọng vì Scenio cần hiểu mục tiêu, trình độ và thói quen học của người dùng trước khi tạo lộ trình.

### Nhấn mạnh

- Đăng ký xong không chỉ lưu user, mà còn bắt đầu luồng cá nhân hóa.
- Nếu user mới chưa có profile học tập, app bắt buộc đi qua onboarding.

---

## 2. Account onboarding - lấy thông tin học tập

### Thao tác

Đi qua từng step onboarding:

1. Chọn mục tiêu học tiếng Anh.
2. Chọn trình độ tự đánh giá.
3. Chọn tần suất học mong muốn.
4. Chọn các kỹ năng hoặc ngữ cảnh muốn ưu tiên.
5. Hoàn tất onboarding.

### Nói

> Ở bước này, app thu thập thông tin để xây roadmap. Ví dụ người dùng học để giao tiếp hằng ngày, đi làm, du lịch hoặc phỏng vấn. Ngoài mục tiêu, app cũng cần biết trình độ hiện tại, tần suất học và kỹ năng người dùng muốn cải thiện như ngữ pháp, từ vựng, độ tự nhiên hay sự tự tin khi nói.

> Dữ liệu này sẽ được backend dùng để tạo lộ trình phù hợp thay vì dùng một danh sách bài học cố định cho mọi người.

### Nhấn mạnh

- Đây là đầu vào để sinh roadmap.
- Càng đủ thông tin, roadmap càng sát nhu cầu.
- XP và level về sau nên dựa trên số phiên hoàn thành, điểm gần đây, streak và/hoặc level test.

---

## 3. Vào Home - màn tổng quan học tập

### Thao tác

Sau khi onboarding xong, vào Home.

Quan sát các phần:

- Hero card trên cùng.
- Thành tích: XP, streak, từ vựng đã lưu.
- Lịch sử cuộc hội thoại.
- Learning roadmap.
- Bước tiếp theo trong roadmap.
- Nhiệm vụ hôm nay.

### Nói

> Sau khi vào app, Home là trung tâm điều hướng chính. Ở đây người dùng thấy ngay bước học nên làm tiếp, tiến độ học, lịch sử các cuộc hội thoại và các nhiệm vụ hằng ngày.

> Điểm quan trọng là card đề xuất trên Home ưu tiên roadmap. Nếu roadmap nói bước tiếp theo là "Making Weekend Plans" thì Home sẽ đề xuất đúng bước đó, không đề xuất một scene đã hoàn thành như Hotel Check-in.

### Nhấn mạnh

- Hero card phải theo **roadmap next step**.
- Không đề xuất lại step đã hoàn thành.
- Lịch sử cuộc hội thoại đặt ngay Home để user dễ xem lại kết quả, không cần vào Profile.

### Nếu người nghe hỏi "đề xuất này lấy từ đâu?"

**Trả lời:**

> Đề xuất chính lấy từ `learningPlan.nextStep`. Nếu user chưa có roadmap hoặc roadmap chưa có next step, app mới fallback sang danh sách scene recommended chung.

---

## 4. Roadmap - lộ trình cá nhân hóa

### Thao tác

1. Bấm vào card roadmap hoặc nút xem roadmap.
2. Mở màn Learning Plan.
3. Chỉ vào các bước:
   - Bước đã hoàn thành.
   - Bước đang sẵn sàng.
   - Bước đang khóa.
4. Bấm **Mở bước học** ở step đang sẵn sàng.

### Nói

> Đây là lộ trình học cá nhân hóa. Mỗi step có trạng thái riêng: sẵn sàng, hoàn thành hoặc đang khóa. User sẽ đi theo từng bước để hệ thống có dữ liệu học tập tuần tự.

> Ví dụ Hotel Check-in đã hoàn thành thì app không nên tiếp tục đề xuất nó ở Home. Thay vào đó, app chuyển sang bước tiếp theo như Making Weekend Plans.

### Nhấn mạnh

- Roadmap là "xương sống" của sản phẩm.
- Home, Practice và Result phải xoay quanh roadmap.
- Step hoàn thành không nên được đề xuất lại như step chính.

---

## 5. Bắt đầu một phiên hội thoại theo roadmap

### Thao tác

1. Từ roadmap hoặc Home, bấm **Bắt đầu bước này**.
2. Vào màn chi tiết scene hoặc vào thẳng Practice tùy flow hiện tại.
3. Bấm bắt đầu phiên.

### Nói

> Khi user bắt đầu một bước học, app tạo một session. Session này gắn với scene hoặc custom practice config, có mục tiêu, AI partner, độ khó và số lượt hội thoại cần hoàn thành.

> Đây là điểm khác chatbot thông thường: mỗi cuộc hội thoại có mục tiêu học rõ ràng, ví dụ tự giới thiệu, hỏi đường, đặt phòng, hoặc trao đổi cuối tuần.

### Nhấn mạnh

- Session không phải chat tự do hoàn toàn.
- Session có goal, target turns, transcript và điểm số.

---

## 6. Demo voice conversation - AI mở lời trước

### Thao tác

1. Vào màn Practice.
2. Bấm mic để mở voice realtime.
3. Đợi AI nói câu mở đầu.
4. User trả lời bằng giọng nói.
5. Tiếp tục 2-3 lượt.
6. Bấm **Xong** để hoàn tất phiên.

### Nói

> Trong phiên voice, AI là người mở lời trước để tạo cảm giác như một cuộc hội thoại thật. Khi AI đang nói, mic tự khóa để tránh ghi nhầm giọng AI thành transcript của user. Khi AI nói xong, mic mở lại để user trả lời.

> Transcript được lưu theo từng lượt, gồm cả câu AI và câu user. Đây là dữ liệu để backend chấm điểm sau phiên.

### Câu mẫu để nói khi demo phỏng vấn frontend

Nếu AI hỏi:

> Could you start by introducing yourself?

User nói:

> Hi Emma, my name is Kien. I am a final-year student and I am learning frontend development. I have experience with Flutter and React, and I want to apply for this internship because I want to improve my real project skills.

Nếu AI hỏi về project:

> What project have you worked on that you are proud of?

User nói:

> I worked on a mobile app for learning English conversation. I built some screens like home, chat room, and vocabulary review. I tried to make the UI responsive and easy to use.

Nếu AI hỏi vì sao phù hợp:

> Why do you think you are suitable for this role?

User nói:

> I think I am suitable because I learn fast and I care about user experience. I am not perfect yet, but I can work hard, listen to feedback, and improve every week.

### Nhấn mạnh

- AI mở lời trước.
- Mic tự khóa khi AI nói.
- Transcript là dữ liệu thật dùng để chấm.
- Nếu user không nói gì mà bấm xong, app phải cảnh báo và không chấm điểm rỗng.

### Nếu voice lỗi trong lúc demo

**Nói:**

> Phần voice realtime phụ thuộc vào quyền microphone, simulator và network. Nếu voice không mở được, app vẫn hỗ trợ nhập text để hoàn thành flow học và chấm điểm dựa trên transcript.

---

## 7. Màn kết quả - điểm số và AI nhận xét

### Thao tác

Sau khi bấm **Xong**, mở màn Session Result.

Chỉ vào các phần:

- Điểm grammar / vocabulary / naturalness.
- Kết quả nhiệm vụ.
- AI nhận xét.
- Kế hoạch cải thiện.
- Các lượt đáng chú ý.
- Chấm chi tiết từng lượt.
- AI gợi ý luyện tiếp.
- Transcript.

### Nói

> Sau khi hoàn tất, backend chấm session dựa trên transcript. App hiển thị điểm theo ba trục: ngữ pháp, từ vựng và độ tự nhiên. Ngoài điểm tổng, app còn hiển thị AI nhận xét, các lượt đáng chú ý và chấm chi tiết từng câu user nói.

> Phần quan trọng nhất là sau khi chấm xong, AI không dừng lại ở việc báo điểm. AI sẽ gợi ý user nên làm gì tiếp theo để cải thiện. Ví dụ nếu user yếu ở naturalness, app đề xuất luyện lại một phiên tương tự nhưng tập trung nói tự nhiên hơn.

### Nhấn mạnh

- Không chỉ "score".
- Có feedback từng lượt.
- Có câu nên sửa.
- Có kế hoạch cải thiện.
- Có đề xuất luyện tiếp theo.

### Câu nói nhấn mạnh

> Với Scenio, một phiên học không kết thúc ở điểm số. Điểm số chỉ là dữ liệu đầu vào để tạo bước học tiếp theo.

---

## 8. AI gợi ý luyện tiếp - follow-up practice

### Thao tác

1. Ở màn kết quả, kéo đến card **AI gợi ý luyện tiếp**.
2. Đọc chủ đề đề xuất.
3. Bấm nút luyện tiếp.
4. App tạo một custom follow-up practice tương tự.

### Nói

> Đây là phần em muốn nhấn mạnh. Sau khi user hoàn thành một session, AI sẽ gợi ý bước luyện tiếp. Nếu user vừa luyện một chủ đề custom, app có thể tạo một phiên custom follow-up tương tự nhưng thay đổi góc hội thoại và tập trung vào lỗi yếu nhất.

> Ví dụ user vừa luyện phỏng vấn frontend nhưng nói chưa tự nhiên, app sẽ tạo một phiên phỏng vấn tương tự, vẫn cùng chủ đề, nhưng AI sẽ hỏi theo hướng mới và ưu tiên natural English phrasing.

### Nhấn mạnh

- Đây là điểm giúp app có vòng học liên tục.
- User không phải tự nghĩ nên học gì tiếp.
- App dùng kết quả vừa chấm để tạo phiên tiếp theo.

### Câu nói ngắn gọn

> User học xong -> AI chấm -> AI đề xuất chủ đề tiếp theo -> user bấm một nút để luyện tiếp.

---

## 9. Xem lịch sử cuộc hội thoại từ Home

### Thao tác

1. Quay về Home.
2. Kéo tới section **Lịch sử cuộc hội thoại**.
3. Bấm một phiên gần nhất.
4. Mở lại màn kết quả.

### Nói

> Người dùng có thể xem lại lịch sử ngay trên Home, không cần vào Profile. Mỗi item trong lịch sử mở lại toàn bộ kết quả gồm transcript, điểm số, AI nhận xét và gợi ý luyện tiếp.

> Điều này giúp user quay lại xem mình sai ở đâu và tiếp tục học từ chính dữ liệu cũ.

### Nhấn mạnh

- Home có lịch sử nhanh.
- Profile vẫn là nơi xem đầy đủ hơn.
- Lịch sử không chỉ để xem lại transcript, mà còn để xem lại nhận xét và follow-up.

---

## 10. Vocabulary - lưu và ôn lại từ vựng

### Thao tác

1. Trong transcript hoặc phần hội thoại, chọn một từ/cụm từ để lưu.
2. Vào tab Vocabulary.
3. Mở flashcard hoặc review.

### Nói

> Trong lúc luyện hội thoại, user có thể lưu từ hoặc cụm từ quan trọng. Sau đó tab Vocabulary giúp ôn lại các từ này theo ngữ cảnh. Từ vựng không bị tách rời khỏi bài học, mà gắn với session và câu hội thoại nơi user gặp từ đó.

### Nhấn mạnh

- Từ vựng đến từ hội thoại thật.
- Có nghĩa tiếng Việt để user hiểu lại nhanh.
- Vocabulary giúp kéo dài giá trị của mỗi session.

---

## 11. Profile - tổng kết tiến độ học

### Thao tác

1. Vào tab Profile.
2. Chỉ các phần:
   - Tổng XP.
   - Streak.
   - Sessions completed.
   - Skill breakdown.
   - Badges.
   - Practice history.

### Nói

> Profile là nơi tổng hợp tiến độ học dài hạn. User thấy XP, streak, số phiên đã hoàn thành, kỹ năng mạnh/yếu và các huy hiệu. Phần lịch sử ở đây đầy đủ hơn Home.

### Nhấn mạnh

- Home dùng cho hành động nhanh.
- Profile dùng để xem tổng kết dài hạn.

---

## 12. Custom Practice - tự tạo cuộc hội thoại

### Mức ưu tiên demo

Feature này nên trình bày **lướt nhưng rõ giá trị**, vì MVP chính vẫn là roadmap-guided learning. Nếu còn thời gian, demo 1 lần tạo custom practice.

### Thao tác

1. Vào tab Practice hoặc màn tạo cuộc hội thoại.
2. Chọn tạo cuộc hội thoại mới.
3. Điền các field demo:
   - Chủ đề: `Đặt phòng khách sạn khi đi du lịch`
   - Mục tiêu: `Luyện gọi điện hoặc nói chuyện với lễ tân để hỏi phòng trống, đặt phòng, hỏi giá, thời gian nhận phòng và các dịch vụ cơ bản của khách sạn.`
   - Vai trò của tôi: `Khách du lịch muốn đặt một phòng đôi cho 2 đêm. Tôi cần hỏi giá, bữa sáng, giờ nhận phòng và xác nhận đặt phòng.`
   - Vai trò của AI: `Lễ tân khách sạn thân thiện, nói chậm, đặt câu hỏi tự nhiên và giúp khách hoàn tất đặt phòng.`
   - Tên AI: `Anna`
   - Giới tính / giọng AI: `Nữ`
   - Trình độ: `A2`
   - Thời lượng: `5 phút`
   - Số lượt mục tiêu: `4-5 lượt`
   - Yêu cầu đặc biệt: `AI chỉ giao tiếp bằng tiếng Anh. Nếu tôi nói sai, AI vẫn tiếp tục hội thoại tự nhiên, không sửa lỗi ngay trong cuộc gọi. Sau khi kết thúc phiên mới nhận xét và gợi ý cách nói tốt hơn.`
4. Bấm tạo và bắt đầu phiên.

### Nói

> Ngoài roadmap, Scenio còn cho user tự tạo tình huống riêng. Ví dụ hôm nay user chuẩn bị đi du lịch và muốn luyện đặt phòng khách sạn, user có thể nhập mục tiêu, vai trò của mình, vai trò AI và độ khó mong muốn. Từ đó app tạo một phiên luyện tập đúng ngữ cảnh.

> Phần này giúp app không bị giới hạn trong các bài học có sẵn. Roadmap dùng cho lộ trình dài hạn, còn custom practice dùng cho nhu cầu tức thời của người học.

### Nhấn mạnh

- Roadmap là luồng học chính.
- Custom practice là luồng linh hoạt theo nhu cầu cá nhân.
- Kết quả custom practice vẫn đi qua cùng hệ thống transcript, scoring, history và AI gợi ý luyện tiếp.

### Kịch bản demo để nói với AI

Nếu AI mở lời:

> Good evening, this is Anna from Sunrise Hotel. How can I help you today?

User nói:

> Hello, I would like to book a room for two nights.

Nếu AI hỏi ngày:

> Sure. What dates would you like to stay with us?

User nói:

> I would like to stay from June tenth to June twelfth.

Nếu AI hỏi loại phòng:

> What kind of room would you prefer?

User nói:

> I need a double room for two people. Do you have any rooms available?

Nếu AI nói có phòng và hỏi thêm:

> Yes, we have a double room available. Would you like breakfast included?

User nói:

> Yes, please. How much is the room per night with breakfast?

Nếu AI trả lời giá:

> It is eighty dollars per night, including breakfast.

User nói:

> That sounds good. What time can I check in?

Nếu AI trả lời check-in:

> Check-in starts at two p.m.

User nói:

> Great. I would like to confirm the booking. My name is Khang Nguyen.

### Câu kết demo custom practice

> Sau khi kết thúc phiên này, app vẫn chấm như các session khác: có transcript, điểm số, lỗi từng lượt và gợi ý luyện tiếp. Điểm khác là chủ đề không lấy từ scene có sẵn, mà được tạo từ nhu cầu thực tế của user.

### Câu chuyển sang phần chính

> Trong demo MVP, em sẽ quay lại luồng roadmap vì đây là phần thể hiện rõ nhất khả năng cá nhân hóa và theo dõi tiến độ dài hạn.

---

## 13. Missions, XP và streak - trình bày lướt

### Mức ưu tiên demo

Feature phụ. Chỉ cần chỉ vào màn hình và nói 30-45 giây.

### Thao tác

1. Ở Home, chỉ vào khu vực thành tích.
2. Chỉ vào XP, streak và số từ vựng đã lưu.
3. Nếu có section nhiệm vụ hôm nay, chỉ nhanh các nhiệm vụ.

### Nói

> Đây là lớp động lực học tập. User có XP, streak và nhiệm vụ hằng ngày để duy trì thói quen luyện nói. XP không phải điểm trình độ tuyệt đối, mà là điểm hoạt động học tập: hoàn thành session, lưu từ vựng, duy trì streak hoặc hoàn thành nhiệm vụ sẽ tăng XP.

> Việc tăng trình độ nên dựa trên dữ liệu chất lượng hơn, ví dụ điểm các phiên gần đây, độ ổn định qua nhiều topic, số session hoàn thành và kết quả đánh giá level. Như vậy XP tạo động lực, còn level phản ánh năng lực học.

### Nhấn mạnh

- XP dùng để tăng engagement.
- Level nên tăng khi user thật sự tiến bộ qua nhiều phiên.
- Missions giúp user biết hôm nay nên làm gì.

---

## 14. Notifications - thông báo và nhắc học

### Mức ưu tiên demo

Feature phụ. Chỉ cần mở icon chuông nếu có dữ liệu.

### Thao tác

1. Ở Home, bấm icon chuông.
2. Chỉ vào danh sách thông báo.
3. Nếu có thông báo session hoặc roadmap, bấm mở nhanh.

### Nói

> Notifications dùng để nhắc user quay lại học, xem kết quả phiên vừa hoàn thành hoặc tiếp tục bước mới trong roadmap. Đây là feature hỗ trợ retention, không phải trọng tâm chấm điểm AI.

### Nhấn mạnh

- Notification giúp kéo user quay lại roadmap.
- Nếu bấm thông báo kết quả, user nên mở lại đúng session result hoặc history.

---

## 15. Roadmap cập nhật sau mỗi session

### Mức ưu tiên demo

Đây là phần MVP, nên trình bày kỹ nếu backend đã có dữ liệu cập nhật.

### Thao tác

1. Sau khi hoàn thành một session, quay về Home.
2. Quan sát hero card đề xuất.
3. Vào Learning Plan.
4. Chỉ ra step vừa hoàn thành và step kế tiếp đang ready.

### Nói

> Sau mỗi phiên, kết quả không chỉ lưu vào history. Nó còn có thể ảnh hưởng tới roadmap. Nếu user hoàn thành tốt, roadmap mở bước tiếp theo. Nếu user yếu ở một kỹ năng, hệ thống có thể đề xuất luyện thêm một phiên gần chủ đề cũ nhưng tập trung vào điểm yếu đó.

> Vì vậy Home không nên lấy đề xuất ngẫu nhiên. Home phải ưu tiên `nextStep` từ roadmap, tránh trường hợp một step đã hoàn thành như Hotel Check-in vẫn hiện là đề xuất chính.

### Nhấn mạnh

- Result tạo dữ liệu cho roadmap.
- Roadmap tạo đề xuất chính cho Home.
- Step đã done không được recommend như bài học chính.
- Follow-up AI có thể tồn tại song song với roadmap: một cái là lộ trình chính, một cái là luyện sửa điểm yếu.

---

## 16. Trạng thái lỗi thân thiện trong demo

### Mức ưu tiên demo

Feature phụ nhưng nên nhắc nhanh vì đây là điểm chất lượng sản phẩm.

### Nói

> Trong quá trình làm, app cũng cần xử lý lỗi theo hướng user-friendly. Ví dụ backend timeout thì không hiển thị lỗi kỹ thuật như Dio timeout hay Prisma error cho người dùng, mà cần hiện thông báo dễ hiểu như "Máy chủ phản hồi hơi lâu, vui lòng thử lại". Nếu user chưa nói gì mà bấm hoàn thành, app không chấm điểm rỗng mà cảnh báo người dùng tiếp tục nói hoặc thoát phiên.

### Các lỗi nên nói là đã/đang xử lý

- Backend timeout hoặc mạng chậm.
- Microphone chưa cấp quyền.
- Voice session chưa active nhưng user bấm thao tác realtime.
- User không nói gì mà bấm hoàn thành.
- Transcript thiếu hoặc quá ngắn, không đủ dữ liệu để chấm.

### Nhấn mạnh

> Đây là app học tập, nên lỗi kỹ thuật phải được chuyển thành hướng dẫn hành động cho người học.

---

## 17. Tóm tắt kiến trúc sản phẩm theo luồng

### Nói

> Về mặt luồng dữ liệu, app hoạt động như sau:

1. User đăng ký và onboarding.
2. Backend tạo hoặc cập nhật learning roadmap.
3. Home hiển thị next step từ roadmap.
4. User bắt đầu session.
5. AI tạo hội thoại realtime hoặc text.
6. Transcript được lưu về backend.
7. Khi user bấm hoàn tất, backend chấm điểm và tạo feedback.
8. App hiển thị kết quả, lỗi từng lượt và kế hoạch cải thiện.
9. AI gợi ý phiên luyện tiếp.
10. Kết quả được lưu vào history, profile, vocabulary và roadmap progress.

### Nhấn mạnh

> Điểm mạnh của Scenio là tạo được một vòng học liên tục: cá nhân hóa -> luyện tập -> chấm điểm -> đề xuất -> luyện tiếp.

### Nếu bị hỏi "phần này có chạy backend thật không?"

**Trả lời:**

> Mobile gọi API thật qua Dio. Backend chịu trách nhiệm auth, user profile, onboarding, learning plan, session, transcript, scoring, vocabulary và notifications. Mobile chỉ render dữ liệu, điều hướng flow và xử lý realtime voice ở phía client. Phần chấm điểm và gợi ý tiếp theo không nên hardcode ở mobile, mà lấy từ kết quả backend trả về sau khi hoàn tất session.

### Nói lướt về kiến trúc

> Ở mobile em tổ chức theo MVVM với GetX: View hiển thị UI, ViewModel giữ state, Repository gọi API. Ở backend, dữ liệu được lưu qua Prisma và các module như sessions, learning-plan, vocabulary, notifications sẽ phục vụ từng phần trong app. Cách tách này giúp sau này thay đổi prompt AI hoặc logic scoring ở backend mà không phải sửa lại toàn bộ mobile UI.

---

## 18. Feature matrix khi bị hỏi "app có những gì?"

Nếu hội đồng hỏi tổng quan feature, trả lời theo nhóm:

### Nhóm MVP chính

- Auth: đăng ký, đăng nhập, lưu phiên user.
- Onboarding: lấy mục tiêu học, trình độ, tần suất, kỹ năng ưu tiên.
- Learning roadmap: lộ trình cá nhân hóa, step ready/done/locked.
- Practice session: voice/text conversation với AI theo scene hoặc custom topic.
- Transcript: lưu lượt AI và user theo thời gian.
- Scoring: chấm grammar, vocabulary, naturalness và nhiệm vụ.
- Detailed feedback: nhận xét tổng quan, lỗi từng lượt, câu gợi ý sửa.
- Follow-up practice: AI gợi ý chủ đề luyện tiếp dựa trên điểm yếu.
- History: xem lại kết quả cũ từ Home và Profile.
- Vocabulary: lưu từ từ hội thoại và ôn lại.

### Nhóm phụ trợ

- XP, streak, nhiệm vụ hằng ngày.
- Notifications.
- Profile overview.
- Badges hoặc achievements.
- Error handling thân thiện.
- Admin/backend quản lý dữ liệu nếu cần mở rộng.

### Câu nói ngắn

> Nếu chia theo mức độ quan trọng, MVP của Scenio là roadmap -> practice -> scoring -> follow-up. Các feature như XP, notifications và profile là lớp hỗ trợ để giữ user quay lại học thường xuyên.

---

## 19. Kết bài

### Nói

> Tóm lại, Scenio không chỉ là ứng dụng chat với AI. Scenio là một hệ thống luyện giao tiếp tiếng Anh theo roadmap cá nhân hóa. Người dùng có thể bắt đầu từ mục tiêu học của mình, luyện trong các ngữ cảnh thực tế, nhận feedback chi tiết sau từng phiên, lưu từ vựng, xem lại lịch sử và tiếp tục bằng các chủ đề được AI gợi ý.

> Mục tiêu cuối cùng là giúp người học không bị mất phương hướng sau mỗi lần luyện. Mỗi phiên học đều trả lời ba câu hỏi: hôm nay mình làm được gì, mình sai ở đâu, và tiếp theo nên luyện gì.

---

## 20. Checklist demo nhanh

Trước khi bắt đầu thuyết trình, kiểm tra các mục này:

- [ ] Backend chạy.
- [ ] App chạy.
- [ ] Tài khoản demo đăng nhập được.
- [ ] Có roadmap.
- [ ] Home hero đang hiện next step roadmap, không hiện step đã done.
- [ ] Có ít nhất một session history.
- [ ] Voice có quyền microphone.
- [ ] Có thể hoàn tất session và mở result.
- [ ] Card **AI gợi ý luyện tiếp** hiển thị.
- [ ] Bấm luyện tiếp tạo follow-up custom practice.
- [ ] Vocabulary có ít nhất một từ đã lưu.
- [ ] Nếu demo custom practice, chuẩn bị sẵn nội dung field để điền nhanh.
- [ ] Nếu demo notifications, đảm bảo có ít nhất một thông báo.
- [ ] Nếu demo XP/streak, dùng tài khoản có số liệu nhìn được.

---

## 21. Bản nói rút gọn trong 2 phút

> Scenio là app luyện giao tiếp tiếng Anh theo ngữ cảnh. Người dùng bắt đầu bằng đăng ký và trả lời onboarding để app hiểu mục tiêu học, trình độ và kỹ năng cần cải thiện. Từ đó backend tạo roadmap cá nhân hóa.

> Ở Home, app ưu tiên hiển thị bước tiếp theo trong roadmap. User bấm vào để bắt đầu một phiên hội thoại với AI. Trong phiên voice, AI mở lời trước, mic tự khóa khi AI nói và mở lại khi đến lượt user. Transcript được lưu lại để chấm điểm.

> Khi user hoàn thành, app hiển thị điểm grammar, vocabulary, naturalness, nhận xét AI, lỗi từng lượt, câu gợi ý sửa và kế hoạch cải thiện. Quan trọng nhất là AI gợi ý user nên luyện gì tiếp theo. Nếu user bấm luyện tiếp, app tạo một phiên follow-up tương tự, tập trung vào điểm yếu vừa được phát hiện.

> Người dùng cũng có thể xem lại lịch sử hội thoại ngay ở Home, ôn từ vựng đã lưu và theo dõi XP, streak, skill breakdown trong Profile. Như vậy Scenio tạo một vòng học hoàn chỉnh: onboarding -> roadmap -> practice -> feedback -> next practice.
