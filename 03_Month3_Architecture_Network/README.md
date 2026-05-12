# 📅 THÁNG 3: Production Architecture + Modularization

*Mục tiêu: Đập bỏ tư duy ứng dụng monolithic cục mịch, biết cách chia source code thành module và design chuẩn Clean Architecture.*

---

## 🗓 Tuần 1: Modular Architecture
* **Thứ 2:** Giới thiệu Modular Architecture.
  * **Lý thuyết:** App Monolithic có 1 target, build cực lâu, đụng chạm code dễ conflict. Modular chia App thành các thư viện độc lập: Core, UIComponent, FeatureA.
  * **Ví dụ:** Phác thảo cấu trúc: MainApp (Chỉ chứa setup) -> Feature (Home, Profile) -> Network, Domain -> Core (Extensions, Utils).
* **Thứ 3:** Setup Swift Package Manager (SPM).
  * **Lý thuyết:** Dùng SPM ngay bên trong cấu trúc project để quản lý local package (không cần đưa lên github).
  * **Ví dụ:** Khởi tạo thư mục `Modules`, dùng lệnh `swift package init --type library`. Kéo thư mục vào file `.xcodeproj` và link các package vào target chính.
* **Thứ 4:** Tooling: **Tuist**.
  * **Lý thuyết:** `.xcodeproj` rất hay bị conflict khi làm team lớn. Tuist là tool (viết bằng Swift) dùng file `Project.swift` để tự gen lại toàn bộ file `.xcodeproj`.
  * **Ví dụ:** Cài đặt Tuist CLI (`tuist install`). Chạy `tuist init`. Viết manifest file tạo 1 project đơn giản có 2 module.
* **Thứ 5:** Phân chia module thực tế.
  * **Lý thuyết:** Quy tắc Dependency Rule: Layer trên gọi layer dưới, không làm ngược lại, không tạo vòng tròn (Circular Dependency).
  * **Ví dụ:** Xây dựng `UIComponents` module (Chứa custom Button, Textfield, Color, Font). Bắt FeatureHome và FeatureProfile cùng phụ thuộc vào UIComponents.
* **Thứ 6:** Routing giữa các module độc lập.
  * **Lý thuyết:** Làm sao Màn hình A (Module Feature A) gọi được Màn hình B (Module Feature B) mà không bị phụ thuộc vòng? Dùng Protocol Interface hoặc Coordinator URL Routing.
  * **Ví dụ:** Thiết kế 1 protocol `ProfileRouting` ở module Core. Màn hình A gọi qua protocol, Màn hình B là người implement thực sự.
* **Thứ 7:** Thực hành: Bẻ gãy Monolithic.
  * **Ví dụ:** Lấy ứng dụng bạn làm trước đây (nhét hết code ở 1 chỗ), dùng SPM bẻ nó thành 3 module: `Network`, `Components`, `App`. Xử lý các lỗi import và compiler.
* **Chủ nhật:** 💤 **Rest Day** (Nghỉ ngơi).

## 🗓 Tuần 2: Clean Architecture & State Management
* **Thứ 2:** Clean Architecture cơ bản.
  * **Lý thuyết:** 3 tầng rõ rệt: Domain (Entities, Usecase), Data (Repositories, API, DB), Presentation (View, ViewModel).
  * **Ví dụ:** Viết interface protocol ở Domain (`UserRepository`). Viết implement thực tế ở Data (`NetworkUserRepository`). Presentation chỉ tương tác với Domain Interface.
* **Thứ 3:** Coordinator Pattern (MVVM-C).
  * **Lý thuyết:** ViewController/View không nên chứa code nhảy màn hình (push/present). Coordinator đứng ngoài quản lý flow điều hướng.
  * **Ví dụ:** Xây dựng `AppCoordinator`, `LoginCoordinator`, `HomeCoordinator`. Điều phối luồng nếu login thành công -> xóa LoginCoordinator -> khởi tạo HomeCoordinator.
* **Thứ 4:** State Management: Reducer Pattern (UDF).
  * **Lý thuyết:** Luồng dữ liệu một chiều (Unidirectional Data Flow) bằng Combine/SwiftUI. Trạng thái (State) bị biến đổi bởi Action thông qua 1 hàm Reducer duy nhất.
  * **Ví dụ:** Viết 1 class Store. Khai báo enum `Action { load, success(Data) }`. Reducer nhận `state` hiện tại và `action`, trả ra `state` mới.
* **Thứ 5:** Dependency Injection (Manual DI).
  * **Lý thuyết:** DI (Inversion of Control) thay vì class tự khởi tạo (`let api = Network()`), nó yêu cầu truyền từ ngoài vào (`init(api: NetworkProtocol)`).
  * **Ví dụ:** Xoá bỏ Singleton trong project (`NetworkManager.shared`). Thay bằng Constructor Injection truyền từ Coordinator vào ViewModel.
* **Thứ 6:** DI Container (Service Locator).
  * **Lý thuyết:** Quản lý toàn bộ các dependency ở 1 chỗ (Container). Khi cần tạo màn hình, tự động resolve các tham số.
  * **Ví dụ:** Viết 1 class `DIContainer`. Có hàm `register<T>(type: T.Type, instance: T)` và `resolve<T>() -> T`. Hoặc sử dụng cơ chế `@propertyWrapper` (`@Inject`) để lấy.
* **Thứ 7:** Thực hành MVVM-C + DI.
  * **Ví dụ:** Thiết kế module Đăng nhập, truyền Mock API service vào qua DI. Coordinator quản lý việc đẩy sang màn hình Quên mật khẩu.
* **Chủ nhật:** 💤 **Rest Day**.

## 🗓 Tuần 3: Networking Deep Dive
* **Thứ 2:** URLSession Cấu trúc sâu.
  * **Lý thuyết:** `URLSessionConfiguration` (.default, .ephemeral, .background). Caching Policy (ReturnCacheDataElseLoad). `URLProtocol` để mock API.
  * **Ví dụ:** Dùng `.ephemeral` cho các request ẩn danh không để lại cache. Viết custom `URLProtocol` để chặn request thật và trả về file JSON mock cục bộ.
* **Thứ 3:** Viết JWT Interceptor (Xử lý HTTP 401).
  * **Lý thuyết:** Access Token hết hạn. Interceptor sẽ bắt lỗi 401, tự động hold lại các request đang pending, gọi API `/refresh-token`, sau đó tự động retry các request vừa bị hold.
  * **Ví dụ:** Tự build một class Networking Core (dùng Combine hoặc Async/Await) bọc lại cơ chế refresh token hoàn toàn vô hình (transparent) với UI.
* **Thứ 4:** Retry strategy.
  * **Lý thuyết:** Mạng chập chờn không nên báo lỗi ngay, cần Retry. Exponential Backoff (chờ 1s -> 2s -> 4s -> 8s) để không spam server sập mạng.
  * **Ví dụ:** Viết operator Combine `.retryWithBackoff(3, initialDelay: 1)` hoặc đệ quy async/await áp dụng cho API lấy danh sách.
* **Thứ 5:** Websocket.
  * **Lý thuyết:** HTTP là request/response 1 chiều. Websocket là 2 chiều realtime, mở connection liên tục (stateful). Cơ chế Ping/Pong để giữ kết nối không bị đóng.
  * **Ví dụ:** Sử dụng `URLSessionWebSocketTask`. Tạo file service quản lý logic connect, gửi message, và nhận tin nhắn qua luồng async/await `for await message in socket...`.
* **Thứ 6:** Background Session & Upload.
  * **Lý thuyết:** Tải/Upload file lớn khi app bị văng ra background.
  * **Ví dụ:** Cấu hình `URLSession(configuration: .background("id"))`. Bắt event trong `AppDelegate` `handleEventsForBackgroundURLSession` để báo file tải xong dù app tắt.
* **Thứ 7:** Offline-first Cache Strategy.
  * **Lý thuyết:** Hiển thị data cache ngay lập tức khi mở app, đồng thời call API background. Khi API về thành công -> ghi đè cache -> update UI.
  * **Ví dụ:** Viết logic kết hợp Generic Repositories. Luôn fetch data từ DB ra trước đẩy lên UI, sau đó trigger URLSession.
* **Chủ nhật:** 💤 **Rest Day**.

## 🗓 Tuần 4: Project Bắt Buộc - Production-ready App
* **Thứ 2:** Khởi tạo kiến trúc.
  * **Ví dụ:** Dựng Tuist/SPM với 3 modules: CoreNetwork, AppUI, FeatureSocial. Setup DI Container gốc.
* **Thứ 3:** Module Network + Auth.
  * **Ví dụ:** Code JWT Interceptor chuẩn. Code màn hình Login. Lưu Token vào Keychain an toàn (không dùng UserDefaults).
* **Thứ 4:** Tính năng Social Feed.
  * **Ví dụ:** Làm màn hình News Feed kết nối Network module, áp dụng Clean Architecture, MVVM-C và Pagination.
* **Thứ 5:** Websocket Notification.
  * **Ví dụ:** Kết nối Websocket. Khi có người like bài -> socket bắn về -> hiển thị Banner Toast dù user đang ở bất kỳ màn hình nào (Dùng luồng Coordinator gốc).
* **Thứ 6:** Offline Data logic.
  * **Ví dụ:** Viết logic lưu JSON response cục bộ. Khi ngắt wifi chạy lại, app vẫn hiển thị màn hình News feed thay vì báo "Mất kết nối".
* **Thứ 7:** Testing toàn diện & Dọn dẹp.
  * **Ví dụ:** Loại bỏ code rác, rà soát memory leak toàn bộ flow. Phân tách layer code hoàn chỉnh.
* **Chủ nhật:** 💤 **Rest Day**.
