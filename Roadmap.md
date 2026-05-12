# 🚀 Roadmap 6 Tháng — Become a Strong Middle iOS Engineer

> Target: từ iOS dev ~3 năm exp → middle iOS engineer cứng, có production mindset, đủ khả năng handle feature lớn độc lập và có nền tảng lên senior/techlead.

---

# 🎯 Mục tiêu sau 6 tháng

Sau roadmap này cần đạt được:

## Technical Skills
- Swift sâu (Memory Management, Concurrency).
- Reactive Programming (Combine) & State Management.
- SwiftUI + UIKit production.
- Performance optimization (Instruments).
- Architecture & scalability (Clean Architecture, Modularization).
- Networking production-ready.
- Local Database (Core Data / Realm / SwiftData).
- Testing (Unit Test, Mocks) & CI/CD.
- AVFoundation production.
- Debugging thực chiến.

## Soft Skills của Middle Engineer
- **Code Review:** Review phát hiện được memory leak, bad architecture, không chỉ khen "LGTM".
- **Estimation:** Khả năng bẻ nhỏ task lớn thành sub-tasks (<4-8h) để estimate chính xác.
- **System Design:** Viết được Technical/Design Document (RFC) cho team.

---

# ⚠️ Tư duy học đúng

## Không học kiểu:
- Framework collector
- Tutorial addiction
- Clone app vô nghĩa
- Chỉ học syntax

## Phải học kiểu:
- Build feature lớn
- Debug issue thật
- Profile performance
- Refactor
- Đọc Apple docs
- Hiểu runtime & system behavior

---

# 🗓 Tổng Quan 6 Tháng

| Giai đoạn | Nội dung | Trọng tâm |
|---|---|---|
| Tháng 1-2 | Core Foundation & UI Internals | Swift, Memory, Concurrency, Combine, UI Performance |
| Tháng 3-4 | Production Architecture & Testing | Clean Arch, Modularization (SPM/Tuist), CI/CD |
| Tháng 5-6 | Advanced iOS + Senior Mindset | AVFoundation, Debugging, System Design, Soft-skills |

---

# 📘 GIAI ĐOẠN 1 — CORE FOUNDATION & UI INTERNALS

## 📅 THÁNG 1 — Swift Deep Dive + Memory + Concurrency + Combine

### 🧠 Kiến thức cốt lõi
1. **ARC & Memory:** retain cycle, weak/unowned, closure capture, autoreleasepool, stack vs heap, copy-on-write, memory graph.
2. **Value vs Reference:** struct/class internals, mutating, thread safety, immutable mindset.
3. **Generics & Protocol:** associatedtype, opaque type, existentials, type erasure, protocol-oriented programming.
4. **Modern Concurrency (async/await):** Task, TaskGroup, Actor, MainActor, Sendable, race condition, cancellation. Phân biệt sự khác biệt với GCD (Thread-based vs Continuation-based).
5. **GCD:** serial vs concurrent queue, deadlock, priority inversion, QoS, synchronization.
6. **Reactive Programming (Combine):** 80-90% project SwiftUI/UIKit hiện tại vẫn dùng. Cần nắm: `AnyPublisher`, `PassthroughSubject`, `CurrentValueSubject`, operators (`flatMap`, `switchLatest`, `combineLatest`), memory management trong Combine (`AnyCancellable`).

### ✅ Project Bắt Buộc: Mini Image Loader Framework (Swift Package)
**Yêu cầu:** 
- Đóng gói thành 1 module **Swift Package (SPM)** độc lập.
- Async image loading sử dụng async/await.
- Giới hạn RAM Cache (VD: tối đa 50MB) bằng `NSCache`, tự động xoá cache khi nhận `UIApplication.didReceiveMemoryWarningNotification`.
- Disk cache sử dụng `FileManager`.
- Hỗ trợ prefetching và cancellation.
**KPI:** Mở 1 TableView/ScrollView load 100 ảnh cùng lúc, **FPS không rớt xuống dưới 58**.

---

## 📅 THÁNG 2 — Rendering + UI Performance

### 🧠 UI Internals
1. **SwiftUI:** diffing, identity, state lifecycle, body re-render, EquatableView, transaction, animation system, Environment, PreferenceKey.
2. **UIKit Internals:** runloop, rendering cycle, reuse mechanism, layout cycle, CoreAnimation basics.
3. **View hierarchy & Off-screen rendering:** Tại sao `cornerRadius`, `shadow` làm lag app và cách khắc phục (`shouldRasterize`, vẽ shadow bằng `UIBezierPath`).

### ⚡ Performance (Instruments)
Bắt buộc thành thạo Instruments để trả lời các câu hỏi:
- **Time Profiler:** Hàm nào đang chiếm nhiều CPU nhất? (Tìm frame drop).
- **Allocations:** RAM có tăng liên tục không?
- **Leaks / Memory Graph:** Object nào chưa được giải phóng?
- **FPS monitoring.**

### ✅ Project Bắt Buộc: Heavy Feed App
**Yêu cầu:** 
- Danh sách 500+ items (Image + Video mp4).
- Có pagination và prefetching.
- **Tính năng nâng cao:** Auto-play video khi cuộn tới (như Facebook/Tiktok) và tự động pause khi cuộn qua.
**KPI:** 
- Dùng **Time Profiler** chứng minh thời gian load 1 cell < 16ms.
- Dùng **Allocations** chứng minh RAM duy trì định mức an toàn, không tăng tuyến tính theo số lượng bài post kéo được. Xử lý triệt để memory spike khi scroll nhanh.

---

# 📘 GIAI ĐOẠN 2 — PRODUCTION ARCHITECTURE

## 📅 THÁNG 3 — Architecture + Networking + Modularization

### 🧠 Architecture & Modularization
1. **Modular Architecture:** Bỏ tư duy nhét tất cả vào 1 target. Học cách chia App thành các module độc lập: `Core`, `Network`, `UIComponents`, `FeatureA`.
2. **Tooling:** Bắt buộc dùng **Tuist** hoặc **SPM** để quản lý project modular.
3. **Clean Architecture:** Domain, Data, Presentation layers.
4. **State Management & Routing:** MVVM-C (có Coordinator Pattern để tách logic điều hướng ra khỏi View), Reducer pattern, Unidirectional data flow.
5. **Dependency Injection:** Manual DI (Factory pattern, Container), Inversion of Control.

### 🌐 Networking (URLSession Deep Dive)
1. Request Interceptor (JWT Interceptor - tự động call API refresh token khi nhận lỗi 401, sau đó retry lại request gốc).
2. Retry strategy, offline cache.
3. Upload/Download, Websocket.

### ✅ Project Bắt Buộc: Production-ready App (Social/Finance)
**Yêu cầu:**
- Tách tầng Network thành 1 module SPM độc lập (chỉ chứa logic API, không chứa UI).
- Áp dụng Clean Architecture + MVVM-C.
- Implement Authentication, pagination, offline mode.

---

## 📅 THÁNG 4 — Persistence + Testing + CI/CD

### 💾 Persistence (Local Database)
1. **Core Data Deep Dive:** background context, migration, indexing, faulting, performance optimization.
2. **Realm / SwiftData:** Biết cách sử dụng và so sánh ưu nhược điểm với Core Data.

### 🧪 Testing
1. **Dependency Inversion cho Mocks:** VD: Không gọi trực tiếp `NetworkManager`, gọi qua `NetworkServiceProtocol` để dễ dàng mock data khi test.
2. XCTest: Unit test, async test.
3. Integration test, Snapshot test.

### ⚙️ CI/CD
Không học lý thuyết chung chung, bắt buộc thực hành tự động hoá:
- **Fastlane:** Viết lane tự động build và đẩy lên TestFlight.
- **GitHub Actions / Bitrise:** Setup workflow tự động chạy test.

### ✅ Project Bắt Buộc: Refactor & Automation (từ project Tháng 3)
**Yêu cầu:**
- Viết Unit Test cho logic ViewModel và Network.
**KPI:**
- **Code Coverage > 70%** cho business logic.
- Setup **GitHub Actions**: Tự động chạy Unit Test mỗi khi tạo Pull Request lên nhánh `main`. Báo đỏ (fail) nếu test tạch và không cho merge.

---

# 📘 GIAI ĐOẠN 3 — ADVANCED IOS + SENIOR MINDSET

## 📅 THÁNG 5 — Domain Chuyên Sâu (AVFoundation / Media)

### 📷 AVFoundation (Vũ khí cực mạnh)
1. Camera pipeline: `AVCaptureSession` (Input) -> `AVCaptureVideoDataOutput` (Process) -> `AVAssetWriter` (Output).
2. Hiểu cấu trúc `CMSampleBuffer` và `CVPixelBuffer` (Core của xử lý ảnh AI/Filter/Barcode).
3. Audio/video sync, compression, realtime processing, export pipeline.

### 🎨 Core Image & Metal Basic
1. Filter pipeline, realtime rendering với Core Image.
2. GPU pipeline, texture, render pass, compute shader basics.

### ✅ Project Bắt Buộc: Camera App Production-level
**Yêu cầu:**
- Custom Camera UI hoàn toàn (không dùng `UIImagePickerController`).
- Tính năng: Realtime preview, ghi đè filter màu theo thời gian thực.
- Record video & Export `.mp4` tối ưu dung lượng.
**KPI:** Xử lý triệt để dropped frame, thermal issue (nóng máy), background handling khi lưu video.

---

## 📅 THÁNG 6 — Debugging + System Design + Soft-skills

### 🐞 Debugging
Luyện kỹ năng: Retain cycle, app freeze, race condition, scrolling lag, crash log analysis, dSYM.

### 🏗 System Design & Document
Khả năng thiết kế và thuyết trình giải pháp cho team. Học cách design:
- Chat app (Offline-first).
- Feed architecture (Caching strategy).
- Sync engine.

### 🤝 Kỹ năng làm việc (Middle/Senior)
1. **Code Review:** Đọc hiểu code người khác, phát hiện bug tiềm ẩn thay vì chỉ check syntax.
2. **Estimation:** Bẻ nhỏ task lớn để đánh giá thời gian chính xác.

### ✅ Project Bắt Buộc: Viết System Design Document (RFC)
**Yêu cầu:** Chọn 1 tính năng lớn (VD: Chat Offline-first như WhatsApp).
- Vẽ UML Diagram (Sequence, Class diagram).
- Trình bày kiến trúc, threading model, caching & offline strategy, scaling strategy.
- **Viết như một engineer thực thụ đệ trình giải pháp cho sếp/team.**

---

# 📅 Daily Schedule (Try Hard Mode)

*Cảnh báo: Hãy giữ nhịp độ bền bỉ thay vì chạy nước rút. Nên có ít nhất 1 NGÀY NGHỈ (Rest day) trong tuần không đụng đến code để não bộ sắp xếp lại thông tin và tránh burn-out.*

## Weekdays
| Activity | Time |
|---|---|
| Deep learning (Lý thuyết / Docs) | 2h |
| Coding project | 2h |
| Read source code / Docs | 1h |

=> Tổng: ~5h/day

## Weekend
- 6-8h/day (Tập trung sâu).
- Profiling, debugging, rebuild, refactor.

---

# 📚 Tài Liệu Quan Trọng

## Nguồn tài liệu uy tín
- **Apple Docs & WWDC Videos:** Bắt buộc (https://developer.apple.com/videos/)
- **Swift.org:** (https://www.swift.org/documentation/)
- **Point-Free:** Rất tốt cho tư duy Architecture/Functional (https://www.pointfree.co/)
- **Swift by Sundell, objc.io, Donny Wals:** Các blog chuyên sâu về Swift & Combine.

---

# 🔥 Điều Quan Trọng Nhất

## Trong 6 tháng này:
❌ **Tuyệt đối KHÔNG:**
- Học lan man, chase framework mới.
- Xem tutorial liên tục (Tutorial hell).

✅ **BẮT BUỘC PHẢI:**
- Build tính năng khó.
- Debug và Profile liên tục bằng Instruments.
- Đọc Apple Docs để hiểu bản chất gốc rễ.

---

# 🏁 Kết Quả Mong Đợi Sau 6 Tháng

Nếu thực hiện kỷ luật, bạn sẽ:
- Trở thành Strong Middle Engineer, vượt xa phần lớn dev cùng số năm kinh nghiệm.
- Handle các feature lớn, phức tạp độc lập từ lúc design tới khi release.
- Pass phỏng vấn Middle/Senior cứng ở các công ty product.
- Có thế mạnh chuyên sâu (AVFoundation / Performance) khó thay thế. 

> **Mindset Cuối Cùng:** “Middle cứng” không phải người biết nhiều framework nhất. Mà là người: **debug được issue khó, hiểu system behavior, optimize được app production, viết code maintainable và tự design được solution.**