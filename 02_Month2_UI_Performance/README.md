# 📅 THÁNG 2: Rendering + UI Performance

*Mục tiêu: Ám ảnh với hiệu năng, làm chủ UI Internals và Instruments.*

---

## 🗓 Tuần 1: SwiftUI Internals
* **Thứ 2:** Cơ chế Diffing & Identity.
  * **Lý thuyết:** SwiftUI dùng ID để xác định 2 view có phải là 1 (Structural Identity vs Explicit Identity). Tại sao dùng `AnyView` phá hỏng identity và làm chậm app.
  * **Ví dụ:** Tạo 1 `List` với ID tự sinh, sau đó dùng `.id()` modifier truyền UUID. So sánh animation khi xoá 1 item xem cái nào mượt hơn.
* **Thứ 3:** Vòng đời State.
  * **Lý thuyết:** Tại sao `@State` chỉ khởi tạo 1 lần dù View khởi tạo lại. Khác biệt `@StateObject` (View sở hữu) và `@ObservedObject` (View cha truyền xuống).
  * **Ví dụ:** Viết View cha đếm số giây, cập nhật liên tục. Trền data vào View con dùng `@ObservedObject` vs `@StateObject`. Xem View con nào bị reset data sai cách khi cha re-render.
* **Thứ 4:** Body re-render & EquatableView.
  * **Lý thuyết:** SwiftUI so sánh các property của View con. Nếu giống nhau, nó skip hàm `body`.
  * **Ví dụ:** Viết 1 Custom View tốn thời gian render. Đánh dấu nó conform `EquatableView` và tuỳ chỉnh hàm `==` để chặn việc re-render thừa.
* **Thứ 5:** Environment & PreferenceKey.
  * **Lý thuyết:** `Environment` đẩy data từ cha xuống N đời con. `PreferenceKey` lật ngược: thu thập data từ con đẩy lên cha.
  * **Ví dụ:** Dùng `GeometryReader` ở view con tính toán toạ độ (Frame) và đẩy kết quả lên view cha bằng `PreferenceKey`. View cha dùng toạ độ đó vẽ 1 đường viền bao quanh view con.
* **Thứ 6:** Animation system.
  * **Lý thuyết:** Implicit animation (`.animation()` modifier áp dụng cho toàn bộ view) vs Explicit animation (`withAnimation` áp dụng cho logic cụ thể). Transaction.
  * **Ví dụ:** Xây dựng hiệu ứng Hero Transition (ảnh nhỏ click phóng to ra màn hình khác) dùng `matchedGeometryEffect`.
* **Thứ 7:** Thực hành Debug SwiftUI.
  * **Ví dụ:** Cài đặt gói `Self._printChanges()` vào hàm body của các view lồng nhau. Nhìn log console để biết View nào bị render thừa và tối ưu lại bằng cách chia nhỏ cấu trúc View.
* **Chủ nhật:** 💤 **Rest Day** (Nghỉ ngơi).

## 🗓 Tuần 2: UIKit Internals & CoreAnimation
* **Thứ 2:** Runloop.
  * **Lý thuyết:** Vòng lặp sự kiện chính. `default` mode (bình thường) vs `UITrackingRunLoopMode` (khi user chạm/vuốt).
  * **Ví dụ:** Dùng `Timer.scheduledTimer` in log đếm giờ. Dùng tay vuốt 1 cái `UIScrollView`. Bạn sẽ thấy log ngừng chạy. Fix bằng cách add Timer vào runloop với `.common` mode.
* **Thứ 3:** Layout cycle.
  * **Lý thuyết:** `layoutSubviews()` (nơi tính toán frame), `setNeedsLayout` (đánh dấu cần update ở chu kỳ sau), `layoutIfNeeded` (ép update ngay lập tức).
  * **Ví dụ:** Thay đổi constant của Auto Layout Constraint. Gọi `layoutIfNeeded()` bên trong khối `UIView.animate` để xem layout thay đổi mượt mà.
* **Thứ 4:** Reuse mechanism.
  * **Lý thuyết:** Cơ chế Dequeue của TableView/CollectionView tái sử dụng Cell để tiết kiệm RAM.
  * **Ví dụ:** Đổi màu nền cell dựa theo data (Nếu data = true thì set Đỏ). Cố tình bỏ qua case `else` hoặc không dùng `prepareForReuse`. Cuộn lên xuống để thấy lỗi "rác hiển thị" - màu đỏ dính lung tung sang cell khác.
* **Thứ 5:** CoreAnimation Basics.
  * **Lý thuyết:** UI hiển thị thực chất được vẽ bởi `CALayer`. View chỉ xử lý chạm. CALayer nhẹ hơn rất nhiều.
  * **Ví dụ:** Thay vì dùng ảnh động (GIF/Lottie) làm icon loading, hãy tự vẽ 1 vòng tròn bằng `CAShapeLayer` và xoay nó bằng `CABasicAnimation`.
* **Thứ 6:** View hierarchy & Off-screen rendering.
  * **Lý thuyết:** Góc bo tròn (`cornerRadius`), đổ bóng (`shadow`) khiến GPU phải tính toán riêng trong bộ nhớ phụ (off-screen pass) gây drop FPS cực nặng.
  * **Ví dụ:** Test làm 1 mảng 100 view đổ bóng bằng thuộc tính `shadow`. So sánh FPS khi set thêm thuộc tính `shadowPath = UIBezierPath(rect: bounds).cgPath`.
* **Thứ 7:** Thực hành: Shadow & Rasterization.
  * **Ví dụ:** Thử nghiệm bật `layer.shouldRasterize = true` (cache kết quả thành ảnh bitmap) và check FPS. Tự quy hoạch code để toàn bộ thao tác vẽ UI đắt đỏ chuyển vào extension riêng xử lý triệt để.
* **Chủ nhật:** 💤 **Rest Day**.

## 🗓 Tuần 3: Làm chủ Instruments
* **Thứ 2:** Time Profiler.
  * **Lý thuyết:** Time Profiler chụp (sample) lại Call Tree CPU 1000 lần/giây để xem hàm nào "ngốn" thời gian. Phải bật `Invert Call Tree` để đọc từ trong ra ngoài.
  * **Ví dụ:** Cố tình khởi tạo DateFormatter mới mỗi lần hiển thị 1 cell (trong hàm cellForRow). Chạy Time profiler, tìm ra lỗi, sửa lại bằng 1 Singleton DateFormatter và thấy CPU giảm 80%.
* **Thứ 3:** Allocations.
  * **Lý thuyết:** Allocation đo bộ nhớ RAM được cấp phát. Kỹ thuật `Mark Generation` để tìm lượng RAM phình lên sau khi thực hiện 1 thao tác và về lại ban đầu.
  * **Ví dụ:** Push màn hình B -> Pop về màn hình A. Bấm nút `Mark Generation`. Nếu sau nhiều lần push/pop mà Generation sau cao hơn Generation trước -> Có memory leak (hoặc memory growth vô cớ).
* **Thứ 4:** Leaks & Memory Graph.
  * **Lý thuyết:** Bắt những object mồ côi (không ai quản lý nhưng không dealloc). Leak Tool bắt leak tự động. Memory Graph cho bạn soi sơ đồ tham chiếu 3D.
  * **Ví dụ:** Cài vào ViewModel hàm closure mạnh trỏ ngược vào View. Dùng Debug Memory Graph truy tận gốc đường nét đứt và nét liền để xác nhận retain cycle.
* **Thứ 5:** FPS & Core Animation Profiling.
  * **Lý thuyết:** Core Animation tool trên Simulator hỗ trợ phát hiện "Color Blended Layers". Màu đỏ: UI đục/trong suốt đè nhau bắt GPU tính toán màu pha trộn. Màu xanh lục: Opaque, tối ưu tuyệt đối.
  * **Ví dụ:** Bật tính năng Blended Layers trên simulator. Tối ưu bằng cách đổi thuộc tính `backgroundColor` của UILabel từ `clear` sang màu trắng mờ giống với màu cell cha. Màu đỏ sẽ thành màu lục.
* **Thứ 6:** Thermal & Energy Impact.
  * **Lý thuyết:** App chạy ngầm liên tục gây hao pin, máy nóng (thermal state -> serious/critical) dẫn tới OS tự động bóp xung CPU làm app lag toàn tập.
  * **Ví dụ:** Dùng CLLocationManager cấu hình độ chính xác cao nhất `kCLLocationAccuracyBest` chạy ẩn. Mở Energy Log để xem vạch đỏ cảnh báo.
* **Thứ 7:** Thực hành rà soát Open Source.
  * **Ví dụ:** Tải một dự án open source cũ trên GitHub. Dành cả ngày chạy cả 4 tool để "bới lông tìm vết" mọi điểm nghẽn hiệu năng.
* **Chủ nhật:** 💤 **Rest Day**.

## 🗓 Tuần 4: Project Bắt Buộc - Heavy Feed App
* **Thứ 2:** Setup UI.
  * **Ví dụ:** Xây dựng khung Feed dạng List / UICollectionView. Dữ liệu mồi (Mock data) gồm 500 Object chứa Text, URL Ảnh lớn, và URL Video MP4.
* **Thứ 3:** Pagination & Prefetching.
  * **Lý thuyết/Ví dụ:** Không bao giờ tải sẵn 500 bài. Tải từng page (10 bài). Dùng Protocol `UICollectionViewDataSourcePrefetching` để tải page tiếp theo và fetch ảnh vào cache khi user cuộn gần tới mép dưới.
* **Thứ 4:** Video auto-play logic.
  * **Lý thuyết/Ví dụ:** Tính toán kích thước (Intersection) của cell đang scroll so với giữa màn hình (dùng hàm `CGRectIntersectsRect`). Nếu cell nằm chính giữa -> kích hoạt khởi tạo `AVPlayer` và `play()`.
* **Thứ 5:** Video auto-pause & Memory limit.
  * **Lý thuyết/Ví dụ:** AVPlayer chiếm vài chục MB RAM mỗi object. Chỉ giới hạn tối đa 2 player tồn tại trong bộ nhớ. Khi cell cuộn ra ngoài, gọi `player.pause()`, xoá item khỏi player và tái sử dụng layer.
* **Thứ 6:** Profile Time & Opt (< 16ms).
  * **Ví dụ:** Chạy Time Profiler, phát hiện logic tính kích thước ảnh/text quá chậm (làm nghẽn main thread). Chuyển logic tính size (như `NSAttributedString.boundingRect`) sang background thread trước khi reload data.
* **Thứ 7:** Profile RAM & Opt (Memory spike).
  * **Ví dụ:** Nếu scroll cực nhanh qua 100 cell, RAM dội lên 1GB do hệ thống decode ảnh nén (JPEG) ra Bitmap uncompressed quá nhiều. Áp dụng kỹ thuật `ImageIO` Downsampling (Chỉ render ảnh bằng đúng size của cell) thay vì chứa ảnh bự 4K.
* **Chủ nhật:** 💤 **Rest Day**.
