# 📅 THÁNG 6: Debugging + System Design + Soft-skills

*Mục tiêu: Đạt năng lực của một Senior Engineer, hiểu tư duy hệ thống và quy trình làm việc chuẩn.*

---

## 🗓 Tuần 1: Debugging (Săn Bug Thực Chiến)
* **Thứ 2:** Phân tích Crash Log (dSYM).
  * **Lý thuyết:** Khi app crash trên AppStore, bạn chỉ nhận được file log các địa chỉ ô nhớ dạng hexa (0x0124...). dSYM là "bản đồ dịch" để map ô nhớ ra lại tên hàm và số dòng code bị lỗi (Symbolication).
  * **Ví dụ:** Cố tình viết mã crash trên máy thật (Force unwrap array index ngoài rìa). Mở file `.crash`, dùng tool xcodebuild để dịch thủ công ngược lại xem crash nằm ở dòng nào.
* **Thứ 3:** Debug App Freezes & Deadlocks.
  * **Lý thuyết:** Main Thread Watchdog. Nếu main thread bị block bằng loop vô hạn hoặc deadlock quá 10 giây, OS sẽ thẳng tay giết (kill) app. Thread Sanitizer giúp bắt các đoạn code cố thay đổi mảng cùng lúc ở 2 luồng.
  * **Ví dụ:** Viết code deadlock (`queue.sync` trong chính nó) -> bật Thread Sanitizer để Xcode báo động tím và chỉ ra chính xác điểm lỗi.
* **Thứ 4:** Debug Scrolling Lag.
  * **Lý thuyết:** Hit testing & Render loop. Thời gian cho 1 frame là 16.6ms. Nếu có hàm gì đó gọi quá lâu lúc scroll, frame rate sẽ sụt.
  * **Ví dụ:** Nhét 1 vòng lặp delay 10ms vô hàm `cellForRow`. Dùng Instruments (Time Profiler) trace call tree để bắt tận tay hàm delay đó.
* **Thứ 5:** Debug Memory (Retain Cycle nâng cao).
  * **Lý thuyết:** Vòng lặp tham chiếu qua nhiều bậc (A trỏ qua Closure của B, B lại là delegate của C, C lại trỏ về A). Bắt memory leak trong Combine/RxSwift khi quên huỷ bằng `cancellables`.
  * **Ví dụ:** Tạo một luồng Rx/Combine dài nhiều operator, dùng self liên tục bên trong `.map { self.doX() }`. Xoá view để xem leak và cách sửa bằng vòng lặp `[weak self]` trong toàn bộ chuỗi Combine.
* **Thứ 6:** Breakpoint nâng cao (Tiết kiệm thời gian).
  * **Lý thuyết:** Thay vì thêm `print("x")` rồi phải build lại app, dùng Breakpoint Action để in log tự động và không bắt app dừng. Breakpoint Condition (Chỉ dừng khi `user.id == 5`).
  * **Ví dụ:** Đặt condition breakpoint vào vòng lặp 1000 lần, chỉ dừng lại kiểm tra tại vòng lặp thứ 999. Khỏi mất công spam nút next.
* **Thứ 7:** Thực hành: Debug Challenge.
  * **Ví dụ:** Lấy các open source issue khó trên GitHub của RxSwift, Kingfisher hoặc Alamofire. Đọc log issue của người ta, tự đặt breakpoint lần mò tìm nguyên nhân hệ thống.
* **Chủ nhật:** 💤 **Rest Day** (Nghỉ ngơi).

## 🗓 Tuần 2: Kỹ năng Middle/Senior (Code Review & Estimation)
* **Thứ 2:** Tư duy Code Review (Đừng chỉ "LGTM - Looks Good To Me").
  * **Lý thuyết:** Mục tiêu review: Phát hiện lỗi kiến trúc (bad smell), vi phạm Dependency Rule, rò rỉ bộ nhớ, tái sử dụng code... hơn là đi bắt lỗi tab/space hay đặt tên biến.
  * **Ví dụ:** Phân tích một file diff PR giả lập. Viết comment lịch sự mang tính "gợi ý giải pháp" (Suggestion) thay vì "chê bai" (Criticism) đồng nghiệp.
* **Thứ 3:** Thực hành Code Review.
  * **Ví dụ:** Mở Github Swift repo hoặc dự án open source. Vào tab Pull Requests đã được merge. Đọc xem các kỹ sư Senior comment soi code sửa code cho nhau như thế nào để học lỏm.
* **Thứ 4:** Estimation kỹ thuật (WBS - Work Breakdown Structure).
  * **Lý thuyết:** Con người rất dở trong việc đoán thời gian làm 1 khối lượng việc lớn. Nguyên tắc Senior: Không bao giờ estimate một task tốn quá 8h (1 ngày). Nếu > 8h, phải chặt task đó ra nhiều phần siêu nhỏ.
  * **Ví dụ:** Tính năng "Giỏ hàng". Chặt ra: Tạo UI (2h), Build Database cache (3h), Logic sync giỏ (3h), Unit test giỏ (2h).
* **Thứ 5:** Thực hành Estimation.
  * **Ví dụ:** Lấy tính năng News Feed của Facebook (Text, Ảnh, Video, Bình luận, Tương tác thả tim, Realtime). Áp dụng WBS chặt nhỏ màn hình này thành 30 tasks nhỏ. Trình bày file Excel estimate ngày hoàn thành.
* **Thứ 6:** Khái niệm Technical Document / RFC (Request For Comments).
  * **Lý thuyết:** Trước khi gõ dòng code đầu tiên cho feature bự, bạn phải viết tài liệu. Đưa ra bối cảnh, giải pháp đề xuất, thiết kế DB, Diagram và rủi ro để cả team/sếp tranh luận phê duyệt.
  * **Ví dụ:** Đọc mẫu một RFC open source (VD: Swift Evolution proposals). Học cấu trúc văn phong viết kỹ thuật chuyên nghiệp.
* **Thứ 7:** Self-Review (Soi gương).
  * **Ví dụ:** Mở source code cá nhân của bạn cách đây 1 năm. Liệt kê tối thiểu 10 điểm "ngây ngô", lỗi tiềm ẩn, và viết ra giấy giải pháp khắc phục bằng mindset hiện tại.
* **Chủ nhật:** 💤 **Rest Day**.

## 🗓 Tuần 3: System Design Mobile
* **Thứ 2:** Bài toán Chat App (WhatsApp).
  * **Lý thuyết:** Mô hình gửi nhận (HTTP Long polling vs WebSockets). Giao thức MQTT (nhẹ, tối ưu pin). Cấu trúc bảng Database lưu message cục bộ trên máy để chạy offline.
  * **Ví dụ:** Vẽ luồng: User A gửi tin khi rớt mạng -> Máy lưu DB nháp (status: pending) -> Mạng có lại -> Sync background gửi đi -> Đổi status thành "Đã gửi".
* **Thứ 3:** Bài toán Social Feed / Caching.
  * **Lý thuyết:** Pagination dạng con trỏ (Cursor-based) thay vì trang số (Page-based) để tránh lỗi duplicate bài viết khi có người đăng bài mới xen vào giữa. Cache ảnh/video LFU (Least Frequently Used).
  * **Ví dụ:** Trình bày giải pháp: Làm sao để user kéo 10,000 bài post feed mà app chỉ ăn 150MB RAM tối đa, ko crash.
* **Thứ 4:** Bài toán Sync Engine (Đồng bộ đa luồng).
  * **Lý thuyết:** Giải quyết mâu thuẫn đồng bộ (Conflict resolution). Last Write Wins (ai ghi cuối cùng thì lấy) hoặc gộp data (Merge). Hàng đợi công việc (OperationQueue).
  * **Ví dụ:** User note trên iPad Offline, rồi lại sửa note đó trên iPhone Online. Giải pháp xử lý conflict khi máy iPad kết nối lại mạng là gì?
* **Thứ 5:** Bài toán Media Editor (Tiktok).
  * **Lý thuyết:** Tại sao cắt ghép video trên đt lại chạy mượt? (Không render cả cục). Lưu cấu trúc Project dưới dạng JSON/XML metadata chỉ ghi toạ độ thời gian cắt (Timeline), chỉ render ra MP4 ở bước cuối cùng.
  * **Ví dụ:** Thiết kế 1 hệ thống model class (JSON) chứa mô tả các hiệu ứng (âm thanh ở giây 5, chuyển cảnh ở giây 10) thay vì thao tác trên video file gốc.
* **Thứ 6:** Scale app Mobile (Triệu user).
  * **Lý thuyết:** Ở client-side, 1 triệu user đè nặng lên server ra sao. Kỹ thuật Debounce (chống spam click API). GraphQL vs REST để tải đúng và đủ lượng data cần thiết tránh phí băng thông. Quản lý App Bundle Size để user dễ tải bằng 4G.
* **Thứ 7:** Thực hành vẽ UML Diagram.
  * **Ví dụ:** Sử dụng web vẽ Draw.io hoặc PlantUML. Vẽ sơ đồ luồng (Sequence Diagram) cho quy trình Login OTP qua điện thoại (User, Client App, Auth Server, SMS Provider).
* **Chủ nhật:** 💤 **Rest Day**.

## 🗓 Tuần 4: Project Cuối Cùng - Viết System Design Document (RFC)
* **Thứ 2:** Define Scope & Use Cases.
  * **Ví dụ:** Chọn chủ đề: "Thiết kế tính năng đọc tin Offline tự động đồng bộ khi có wifi". Đặt ra giới hạn phạm vi, mô tả flow user thao tác.
* **Thứ 3:** Thiết kế Database Schema.
  * **Ví dụ:** Viết cụ thể các bảng (Realm/CoreData). Bảng `Article` (id, title, status, cachePath). Bảng `SyncQueue` theo dõi các task đồng bộ thất bại.
* **Thứ 4:** Vẽ Diagrams.
  * **Ví dụ:** Vẽ Sequence Diagram từ lúc mạng tạch -> user lưu tin -> mạng có lại -> job chạy ngầm -> thông báo thành công.
* **Thứ 5:** Phân tích Threading Model & Performance.
  * **Ví dụ:** Lập luận tại sao dùng DispatchQueue Background cho tác vụ parse hàng nghìn article. Tại sao dùng QoS (Quality of Service) mức `.utility` để tiết kiệm pin.
* **Thứ 6:** Edge Cases & Risk Management.
  * **Ví dụ:** Liệt kê rủi ro: Nếu giữa chừng hệ điều hành kill app thì sao? Trả lời: Lưu state tạm, kết hợp `Background Fetch` hoặc push silent để trigger app chạy nền.
* **Thứ 7:** Đóng gói RFC.
  * **Ví dụ:** Lưu dưới định dạng Markdown chuyên nghiệp. Gửi cho mentor hoặc một group iOS community nhận phản biện. Đánh giá lại toàn bộ chặng đường 6 tháng. **Bạn đã là một kỹ sư Middle cứng thực thụ!** 🎉
* **Chủ nhật:** 💤 **Rest Day**. Mở tiệc ăn mừng! 🍻 Mở Linkedin và chuẩn bị deal lương mới!
