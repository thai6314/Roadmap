# 📅 THÁNG 1: Core Foundation & Combine

*Mục tiêu: Nắm vững cốt lõi ngôn ngữ, không bao giờ để xảy ra Memory Leak hay Crash do đa luồng.*

---

## 🗓 Tuần 1: ARC & Memory Management
* **Thứ 2:** Deep dive `Retain Cycle` & Memory Graph.
  * **Lý thuyết:** ARC (Automatic Reference Counting) hoạt động thế nào. Tại sao 2 class trỏ `strong` vào nhau lại gây ra memory leak.
  * **Ví dụ:** Tạo class `Person` và `Apartment` tham chiếu chéo nhau. Khởi tạo, gán `nil` và quan sát hàm `deinit` không được gọi. Bật *Memory Graph Debugger* trong Xcode để xem sơ đồ tham chiếu bị kẹt.
* **Thứ 3:** Phân biệt `weak` vs `unowned`.
  * **Lý thuyết:** `weak` biến thành Optional và tự gán `nil` khi object bị hủy. `unowned` không gán `nil`, giúp truy cập nhanh hơn nhưng gây crash (Dangling pointer) nếu object gốc đã chết.
  * **Ví dụ:** Code ví dụ `Customer` (có CreditCard) và `CreditCard` (bắt buộc trỏ ngược về Customer bằng `unowned`). Ép crash bằng cách giải phóng Customer rồi truy cập từ Card.
* **Thứ 4:** `Closure Capture`.
  * **Lý thuyết:** Closure mặc định là *strong capture*. Tìm hiểu capture list `[weak self]`, `[unowned self]`.
  * **Ví dụ:** Viết hàm call API giả lập delay 5s (`DispatchQueue.main.asyncAfter`). Gán closure vào thuộc tính của class. Thoát màn hình (ViewController) trước 5s. Quan sát leak nếu không dùng `[weak self]`.
* **Thứ 5:** `Autoreleasepool` & Stack vs Heap.
  * **Lý thuyết:** Stack cấp phát nhanh, giới hạn dung lượng. Heap cấp phát chậm, quản lý qua ARC. `autoreleasepool` giúp dọn dẹp biến tạm ngay lập tức trong vòng lặp.
  * **Ví dụ:** Viết vòng lặp `for` 100,000 lần khởi tạo `UIImage`. Chạy qua *Instruments (Allocations)* để thấy RAM phình to. Bọc thân vòng lặp trong `autoreleasepool` và thấy biểu đồ RAM đi ngang.
* **Thứ 6:** Cơ chế `Copy-on-write` (CoW).
  * **Lý thuyết:** Array, String, Dictionary là struct (value type) nhưng chứa reference type bên trong để chứa data. Swift tối ưu bằng cách chỉ thực sự copy bộ nhớ khi có thao tác chỉnh sửa (mutating).
  * **Ví dụ:** Gán `arrayB = arrayA`. Dùng hàm `withUnsafeBufferPointer` in địa chỉ vùng nhớ của 2 mảng để thấy chúng trỏ chung 1 chỗ. Thử `arrayB.append(1)` và in lại để thấy vùng nhớ tách ra.
* **Thứ 7:** Thực hành Instruments.
  * **Ví dụ:** Tạo 1 project cố tình gây ra leak qua 3 cách: (1) Delegate pattern quên dùng `weak`, (2) `Timer.scheduledTimer` quên gọi `invalidate()`, (3) Khai báo closure lưu vào biến toàn cục. Dùng tool **Leaks** để truy vết và sửa.
* **Chủ nhật:** 💤 **Rest Day**.

## 🗓 Tuần 2: Value vs Reference & Generics
* **Thứ 2:** Struct vs Class Internals & Method Dispatch.
  * **Lý thuyết:** Static dispatch (Compile-time) nhanh hơn Dynamic dispatch (Runtime / V-Table). Struct mặc định là Static dispatch. Class có thể bị Dynamic dispatch.
  * **Ví dụ:** Viết 1 Struct và 1 Class. Dùng keyword `final` cho Class. Viết vòng lặp so sánh sơ bộ thời gian khởi tạo 1 triệu object.
* **Thứ 3:** `mutating` keyword & Thread safety.
  * **Lý thuyết:** Hàm trong Struct muốn thay đổi property phải đánh dấu `mutating`. Class không thread-safe, truy cập từ nhiều thread gây crash. Struct tạo bản sao nên an toàn hơn.
  * **Ví dụ:** Mở 2 luồng `DispatchQueue.global().async` cùng thay đổi 1 property của Class -> App crash. Chuyển sang Struct và quan sát kết quả.
* **Thứ 4:** Generics cơ bản & `associatedtype`.
  * **Lý thuyết:** Generics giúp code tái sử dụng (như `Array<Element>`). Protocol không thể có Generics ngoặc nhọn trực tiếp, mà phải dùng `associatedtype`.
  * **Ví dụ:** Viết một Protocol `Storage` có `associatedtype Item`. Viết class `CacheStorage` conform protocol này và tự động định nghĩa `Item` là `String`.
* **Thứ 5:** `opaque type` (`some`) và `existentials` (`any`).
  * **Lý thuyết:** `some View` (Opaque) ẩn giấu kiểu cụ thể, compiler vẫn biết kiểu thật ở compile time. `any View` (Existential) là một hộp chứa động (Dynamic dispatch, tốn RAM).
  * **Ví dụ:** Viết hàm trả về `any Shape` vs `some Shape`. Cố gắng cho hàm `some Shape` trả về ngẫu nhiên `Circle()` hoặc `Rectangle()` và xem lỗi compiler báo (some yêu cầu phải trả về đúng 1 kiểu cố định).
* **Thứ 6:** Kỹ thuật Type Erasure.
  * **Lý thuyết:** Trước Swift 5.7, dùng protocol có `associatedtype` như một biến bình thường sẽ báo lỗi. Cần tạo class `Any...` để bọc (wrap) kiểu gốc lại.
  * **Ví dụ:** Tự build một class `AnyStorage<Item>` để bọc protocol `Storage` ở bài Thứ 4. (Tương tự `AnyPublisher`, `AnyView`).
* **Thứ 7:** Protocol-Oriented Programming (POP).
  * **Lý thuyết:** Hạn chế đa kế thừa phức tạp của OOP bằng cách dùng Protocol + Protocol Extension để cung cấp hàm mặc định (default implementation).
  * **Ví dụ:** Refactor một hệ thống OOP kế thừa (Animal -> Bird, Fish) gặp lỗi logic (chim cánh cụt là chim nhưng biết bơi, đại bàng bay được) sang hệ thống POP (`Flyable`, `Swimmable`).
* **Chủ nhật:** 💤 **Rest Day**.

## 🗓 Tuần 3: Concurrency
* **Thứ 2:** GCD Basics.
  * **Lý thuyết:** Sự khác nhau giữa `sync` (chặn luồng) và `async`. Serial Queue (tuần tự) vs Concurrent Queue (song song).
  * **Ví dụ:** Tạo một serial queue. Gọi `queue.sync` ở trong chính closure của `queue.async` -> Tạo ra lỗi **Deadlock** block hoàn toàn queue đó.
* **Thứ 3:** Synchronization trong GCD.
  * **Lý thuyết:** Khắc phục Data Race (Nhiều luồng ghi/đọc data cùng lúc).
  * **Ví dụ:** Dùng `DispatchBarrier` trên Concurrent queue để giả lập một class Thread-safe Array (Cho phép nhiều luồng đọc cùng lúc, nhưng khi viết thì chặn tất cả luồng khác).
* **Thứ 4:** Modern Concurrency: `async`/`await` & `Task`.
  * **Lý thuyết:** GCD tạo thread mới gây nặng máy. `async/await` dùng Continuation, tạm ngưng (suspend) hàm mà không lock thread.
  * **Ví dụ:** Viết một hàm `func fetchUser() async throws -> User` sử dụng `URLSession.shared.data(from:)`. Gọi hàm này bằng cách bọc trong `Task { }`.
* **Thứ 5:** `TaskGroup` & Race condition.
  * **Lý thuyết:** Dùng `TaskGroup` để xử lý mảng các tác vụ mạng chạy song song thay vì dùng `DispatchGroup`.
  * **Ví dụ:** Nhận vào một mảng 10 URL ảnh. Dùng `withThrowingTaskGroup` để download song song 10 ảnh. Trả về mảng ảnh sau khi tất cả hoàn tất.
* **Thứ 6:** `Actor`, `MainActor` và `Sendable`.
  * **Lý thuyết:** `actor` giống class nhưng nó tự động quản lý luồng để chặn data race. `MainActor` ép hàm chạy ở UI thread.
  * **Ví dụ:** Viết class `BankAccount` có hàm rút tiền, chạy đa luồng gây âm tiền. Đổi thành `actor BankAccount`, quan sát compiler ép bạn phải gọi bằng `await` và sửa lỗi data race hoàn toàn.
* **Thứ 7:** Thực hành: Download Manager.
  * **Ví dụ:** Xây dựng class `DownloadManager` dùng `async/await`. Hỗ trợ tải file lớn có track `%` progress, có thể Pause/Resume và Cancel (`Task.cancel()`).
* **Chủ nhật:** 💤 **Rest Day**.

## 🗓 Tuần 4: Combine & Project Cuối Tháng
* **Thứ 2:** Combine Basics: `Publisher`, `Subscriber`.
  * **Lý thuyết:** Tư duy luồng dữ liệu (Reactive). Dữ liệu chảy từ Publisher -> Subscriber. Đăng ký bằng `sink`, lưu biến hủy bằng `AnyCancellable`.
  * **Ví dụ:** Dùng `@Published var count = 0`. Dùng `$count.sink { }` để in log mỗi khi `count` đổi giá trị.
* **Thứ 3:** Các loại Subject.
  * **Lý thuyết:** Subject vừa là Publisher vừa là Subscriber. `PassthroughSubject` (bắn data đi ngay, không giữ lại) vs `CurrentValueSubject` (luôn giữ data mới nhất, subscribe là nhận ngay).
  * **Ví dụ:** Tạo logic Login: Bắn thông báo "Login success" qua `PassthroughSubject`. Lưu user token vào `CurrentValueSubject` để các class khác lấy data lập tức.
* **Thứ 4:** Combine Operators.
  * **Lý thuyết:** Biến đổi luồng bằng `map`, `filter`, `flatMap` (tạo chuỗi request API), `combineLatest` (nhóm 2 luồng).
  * **Ví dụ:** Form UI có 2 TextField (email, password) tương ứng 2 publisher `$email`, `$password`. Dùng `Publishers.CombineLatest` kiểm tra cả 2 > 6 ký tự mới biến biến `$isLoginEnabled` thành true.
* **Thứ 5:** **Project:** Setup Mini Image Loader (SPM).
  * **Lý thuyết/Ví dụ:** Cách cấu trúc Swift Package. Mở Xcode -> New Package. Khai báo dependencies trong `Package.swift`.
* **Thứ 6:** **Project:** Implement Cache.
  * **Lý thuyết/Ví dụ:** Xây dựng `MemoryCache` wrap `NSCache` lại. Xây dựng `DiskCache` dùng `FileManager`. Logic: check memory -> check disk -> gọi mạng.
* **Thứ 7:** **Project:** Tải và Prefetch (Hoàn thành app).
  * **Lý thuyết/Ví dụ:** Dùng `async/await` kết hợp Actor để ngăn việc 1 URL ảnh bị tải 2 lần (Race condition lúc scroll nhanh). Chạy Test TableView FPS.
* **Chủ nhật:** 💤 **Rest Day**.
