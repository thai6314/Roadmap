# 📅 THÁNG 4: Persistence + Testing + CI/CD

*Mục tiêu: Đảm bảo chất lượng bằng Test, hiểu sâu về Database, tự động hóa quy trình release.*

---

## 🗓 Tuần 1: Persistence (Local Database)
* **Thứ 2:** Core Data Deep Dive.
  * **Lý thuyết:** Cấu trúc `.xcdatamodeld`. Khác biệt giữa main queue context (`viewContext`) dành cho UI và background context (`performBackgroundTask`) dành cho xử lý data nặng.
  * **Ví dụ:** Viết hàm parse 10,000 dòng JSON và save vào Core Data. Thực hiện save trực tiếp trên main context (làm app đơ) và thử lại với background context để thấy app mượt.
* **Thứ 3:** Core Data Migration & Indexing.
  * **Lý thuyết:** Thêm sửa bảng cột phải migrate (Lightweight cho đổi nhẹ, Custom cho phức tạp). Đánh Indexing cho các cột hay dùng để search (`NSPredicate`) nhanh hơn.
  * **Ví dụ:** Đổi tên một thuộc tính của Model cũ, sinh ra model version mới. Map Lightweight migration. Thử search 10,000 bản ghi có dùng index và không dùng index.
* **Thứ 4:** Cơ chế Faulting.
  * **Lý thuyết:** Khi fetch data, CoreData không load toàn bộ properties vào RAM ngay, mà chỉ tạo cái khung mồi (Fault). Chỉ khi truy cập property `.name`, data mới load từ disk.
  * **Ví dụ:** Fetch danh sách user, quan sát vùng nhớ. Thử in thuộc tính ra để trigger quá trình Fire Faults. Xem batch size giúp giới hạn memory.
* **Thứ 5:** Realm Database.
  * **Lý thuyết:** So sánh với CoreData: Dễ học hơn, tốc độ ghi siêu nhanh. Nhược điểm: Object bị ghim cứng vào thread sinh ra nó (Trừ Realm mới đã hỗ trợ Actor).
  * **Ví dụ:** Cài thư viện Realm, khởi tạo `Object` data model, viết CRUD (Create, Read, Update, Delete) cơ bản cho ứng dụng Todo.
* **Thứ 6:** SwiftData (Modern DB của Apple).
  * **Lý thuyết:** Bọc trên lõi Core Data nhưng thiết kế hoàn toàn cho Swift/SwiftUI. Khai báo dễ dàng với macro `@Model` thay vì cấu hình bằng giao diện Xcode cũ kỹ.
  * **Ví dụ:** Convert 1 project nhỏ sang dùng SwiftData. Sử dụng `@Query` trực tiếp trong màn hình SwiftUI để list data tự update khi DB thay đổi.
* **Thứ 7:** Thực hành: Offline Cache App.
  * **Ví dụ:** Viết logic lấy JSON từ API, lưu vào Realm / SwiftData ở background, sau đó query ra để hiển thị lên màn hình. Đảm bảo dữ liệu không bị lặp đúp.
* **Chủ nhật:** 💤 **Rest Day** (Nghỉ ngơi).

## 🗓 Tuần 2: Testing (Chất lượng là vàng)
* **Thứ 2:** Tư duy Dependency Inversion (DI) cho Test.
  * **Lý thuyết:** Bạn không thể test 1 hàm gọi mạng HTTP thật. Bạn phải trỏ hàm đó tới một interface (Protocol). Khi test, truyền vào một fake class trả data giả lập lập tức.
  * **Ví dụ:** Đổi `class UserViewModel { var api = Network() }` thành `class UserViewModel { var api: NetworkProtocol }`.
* **Thứ 3:** Các loại Mocking (Mock/Stub/Spy/Fake).
  * **Lý thuyết:** Stub (cứng trả data), Spy (ghi lại lịch sử gọi hàm), Mock (có logic verify assert behavior).
  * **Ví dụ:** Viết một class `SpyNetworkService: NetworkProtocol`. Ghi lại xem hàm `fetchData` có được ViewModel gọi vào đúng thời điểm bấm nút không, và gửi parameter gì.
* **Thứ 4:** XCTest Unit Test.
  * **Lý thuyết:** Khung test `XCTestCase`. Vòng đời hàm `setUpWithError` (chuẩn bị) và `tearDownWithError` (dọn dẹp). Các hàm `XCTAssertEqual`, `XCTAssertNil`.
  * **Ví dụ:** Viết bài test logic format tiền tệ (Nhập 1000000 -> Ra chuỗi "1,000,000 đ"). Test case null, test case số âm.
* **Thứ 5:** Test mã bất đồng bộ (Async).
  * **Lý thuyết:** Chờ đợi kết quả bằng `XCTestExpectation` (dành cho closure/GCD) hoặc viết test trực tiếp bằng `func testAPI() async throws`.
  * **Ví dụ:** Viết bài test giả lập call network lấy data, dùng delay 2s. Sử dụng expectation để bắt code chờ đủ thời gian trước khi assert.
* **Thứ 6:** Snapshot Testing (Test giao diện).
  * **Lý thuyết:** Unit test không kiểm tra được UI có bị vỡ chữ hay lệch padding không. Snapshot capture màn hình thành ảnh, các lần test sau lấy ảnh màn hình hiện tại so với ảnh gốc để báo đỏ nếu sai lệch.
  * **Ví dụ:** Cài package `swift-snapshot-testing`. Chụp lại 1 Custom View lúc khởi tạo thành công và 1 cái lúc báo lỗi.
* **Thứ 7:** Thực hành: Unit Test ViewModel.
  * **Ví dụ:** Viết bài test cho LoginViewModel. Test case: (1) Nhập pass ngắn -> Nút submit disable, báo text đỏ; (2) Pass đúng -> API giả lập báo thành công -> state chuyển sang `.success`.
* **Chủ nhật:** 💤 **Rest Day**.

## 🗓 Tuần 3: CI/CD (Automation)
* **Thứ 2:** CI/CD Concepts & Fastlane.
  * **Lý thuyết:** CI (Continuous Integration - Tự động test khi push code), CD (Continuous Deployment - Tự build và đẩy lên store). Fastlane dùng script Ruby gom cụm dòng lệnh build.
  * **Ví dụ:** Cài đặt fastlane (`brew install fastlane`). Chạy `fastlane init` trong folder app.
* **Thứ 3:** Viết Fastlane Lane: Test & Lint.
  * **Lý thuyết:** Lane là kịch bản chạy. Cấu hình tự động quét lỗi format code.
  * **Ví dụ:** Viết lane `test_and_lint`. Tích hợp SwiftLint. Chạy lệnh `scan` (alias của xcodebuild test) tự động chạy Unit Test báo lỗi qua console.
* **Thứ 4:** Viết Fastlane Lane: Release TestFlight.
  * **Lý thuyết:** Ký tự động chứng chỉ số (Certificates / Provisioning profile) bằng công cụ `match`. Đẩy file .ipa lên server Apple.
  * **Ví dụ:** Cấu hình lane `beta`. Sử dụng tool `increment_build_number`, chạy tool `gym` (build archive), gọi tool `pilot` để tự động đẩy app thẳng lên Testflight cho QA test.
* **Thứ 5:** Giới thiệu GitHub Actions.
  * **Lý thuyết:** Runner tự động hóa đám mây được kích hoạt khi có sự kiện (Push nhánh, tạo PR). Cấu trúc file `.yaml` trong `.github/workflows`.
  * **Ví dụ:** Hiểu các thông số: `on: pull_request`, `runs-on: macos-latest`.
* **Thứ 6:** Tích hợp GitHub Action x Fastlane.
  * **Lý thuyết:** Chạy kịch bản Fastlane trực tiếp trên máy chủ đám mây Github thay vì máy tính cá nhân.
  * **Ví dụ:** Viết file `ci.yml` ra lệnh cho Github Runner checkout code, sau đó gõ `fastlane test_and_lint`.
* **Thứ 7:** Thực hành Rule bảo vệ Code.
  * **Ví dụ:** Commit file yml. Đặt thiết lập Branch Protection Rule trên Github bắt buộc phải chạy pass "Test Action" mới cho hiện nút Merge xanh. Thử push một đoạn code Unit Test lỗi để xem Github báo chặn.
* **Chủ nhật:** 💤 **Rest Day**.

## 🗓 Tuần 4: Project Bắt Buộc - Automation & Code Coverage
* **Thứ 2:** Code Coverage (Độ phủ code).
  * **Lý thuyết:** Đo xem các đoạn test của bạn đã chạy qua bao nhiêu % số dòng code thực tế trong hệ thống.
  * **Ví dụ:** Bật "Gather coverage for" trong Edit Scheme Xcode. Chạy Test, xem cột Coverage các logic hàm đạt bn %.
* **Thứ 3:** Test module Network.
  * **Ví dụ:** Tạo mock session hứng mọi loại status code HTTP 200, 401, 500. Viết test để đảm bảo JWT Interceptor xử lý đúng chuẩn refresh.
* **Thứ 4:** Test module ViewModel.
  * **Ví dụ:** Viết toàn bộ test cho App Social đã code tháng 3. Target KPI: Đạt được màu xanh cover **> 70%** cho các logic file.
* **Thứ 5:** Push to Github Actions.
  * **Ví dụ:** Đẩy project có chứa test hoàn chỉnh lên Github, kiểm tra các luồng CI có trigger đúng và pass không.
* **Thứ 6:** Xử lý Flaky Tests (Test lúc đúng lúc sai).
  * **Lý thuyết:** Code test do dùng thread hoặc thời gian chờ không chuẩn sẽ thi thoảng fail hên xui trên máy chủ.
  * **Ví dụ:** Tìm lỗi Flaky, khử bỏ việc dùng delay time cứng, thay vào bằng Expectation để đồng bộ luồng test chính xác.
* **Thứ 7:** Document Setup CI/CD.
  * **Ví dụ:** Viết hướng dẫn ngắn gọn cho đồng nghiệp vào dự án cách chạy script để build app chỉ bằng 1 dòng lệnh.
* **Chủ nhật:** 💤 **Rest Day**.
