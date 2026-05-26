# Swift Concurrency: Tổng Hợp Bài Tập Thực Hành

Danh sách các bài tập thực hành từ cơ bản đến nâng cao về Concurrency trong Swift. Bao gồm GCD (Grand Central Dispatch), OperationQueue, và Modern Swift Concurrency (async/await, Actor, Task).

---

## 🟢 Level 1: Soft (Cơ bản)
*Mục tiêu: Nắm vững khái niệm luồng (thread), cách chuyển luồng và cú pháp cơ bản của GCD / Async-Await.*

### Bài tập 1.1: Background to Main (GCD)
**Yêu cầu:** Viết một hàm giả lập việc tải dữ liệu (chạy trên background thread, block thread bằng `Thread.sleep(forTimeInterval: 2)`). Sau khi hoàn thành, hãy chuyển về Main Thread và in ra màn hình dòng chữ "Đã tải xong". Sử dụng `DispatchQueue`.

### Bài tập 1.2: Async/Await cơ bản
**Yêu cầu:** Làm lại bài 1.1 nhưng sử dụng cú pháp `async/await` và `Task`. 
*Lưu ý: Không dùng `Thread.sleep` (vì nó block luôn thread của hệ thống), hãy dùng `try await Task.sleep(nanoseconds:)`.*

### Bài tập 1.3: Deadlock với Sync
**Yêu cầu:** Giải thích tại sao đoạn code dưới đây gây ra lỗi crash (Deadlock) trên Main Thread và đưa ra cách sửa (ít nhất 2 cách):
```swift
DispatchQueue.main.sync {
    print("Hello World")
}
```

---

## 🟡 Level 2: Medium (Trung bình)
*Mục tiêu: Đồng bộ hoá nhiều tác vụ chạy song song, gộp kết quả, và chuyển đổi code Closure cũ sang Async/Await.*

### Bài tập 2.1: Tải nhiều tài nguyên cùng lúc (DispatchGroup)
**Yêu cầu:** Bạn có 3 URLs ảnh (giả lập 3 hàm tải tốn thời gian ngẫu nhiên 1-3s). Viết hàm tải 3 ảnh này **đồng thời**. Khi và CHỈ KHI cả 3 ảnh đều tải xong, in ra màn hình "Hoàn tất tải 3 ảnh". Sử dụng `DispatchGroup`.

### Bài tập 2.2: Structured Concurrency (TaskGroup)
**Yêu cầu:** Làm lại bài 2.1 nhưng sử dụng cơ chế mới của Swift 5.5+: `withTaskGroup` (hoặc `withThrowingTaskGroup`). Yêu cầu hàm phải trả về một mảng chứa kết quả của 3 ảnh (`[UIImage]`).

### Bài tập 2.3: Bọc Closure thành Async (Continuation)
**Yêu cầu:** Bạn đang làm việc với một thư viện cũ sử dụng completion handler như sau:
```swift
func fetchLegacyData(completion: @escaping (String?, Error?) -> Void) { ... }
```
Hãy viết một hàm bọc (wrapper function) sử dụng `withCheckedThrowingContinuation` để chuyển đổi hàm trên sang cú pháp hiện đại: `func fetchModernData() async throws -> String`.

---

## 🔴 Level 3: Hard (Khó)
*Mục tiêu: Quản lý luồng phức tạp, giải quyết Data Race, và quản lý vòng đời của Task (Cancellation).*

### Bài tập 3.1: Operation & Dependencies
**Yêu cầu:** Sử dụng `OperationQueue` và `BlockOperation` để thực hiện một quy trình xử lý ảnh có thứ tự như sau:
1. `Operation A`: Tải ảnh từ mạng (mất 2s).
2. `Operation B`: Áp dụng bộ lọc màu (Filter) cho ảnh (mất 1s). Yêu cầu: **B bắt buộc phải đợi A xong**.
3. `Operation C`: Lưu ảnh vào bộ nhớ máy (mất 1s). Yêu cầu: **C bắt buộc phải đợi B xong**.

### Bài tập 3.2: Race Condition & Data Race
**Vấn đề:** Đoạn code sau mô phỏng việc nhiều luồng cùng thay đổi giá trị của một biến, gây ra tình trạng mất mát dữ liệu (Race Condition). Biến `value` cuối cùng sẽ không đạt được 1000 như kỳ vọng.
```swift
class Counter {
    var value = 0
    func increment() { value += 1 }
}

let counter = Counter()
DispatchQueue.concurrentPerform(iterations: 1000) { _ in
    counter.increment()
}
```
**Nhiệm vụ:** Hãy sửa lỗi này bằng 2 cách độc lập:
- **Cách 1 (Cổ điển):** Dùng GCD (`DispatchQueue` với cờ `.barrier` hoặc dùng Serial Queue).
- **Cách 2 (Hiện đại):** Chuyển đổi class trên thành một `actor`.

### Bài tập 3.3: Task Cancellation & Nested Functions
**Yêu cầu:** 
Viết một hàm tìm kiếm `search(query: String) async throws -> [String]`. 
Giả lập hàm này gọi một API tốn 3s. Trong lúc đang search, nếu user gõ chữ mới, bạn phải huỷ (cancel) Task cũ và gọi Task mới.
- Làm thế nào để thiết kế một class quản lý việc giữ tham chiếu tới Task cũ và gọi `.cancel()`?
- Trong hàm `search`, làm sao để bắt được tín hiệu huỷ (thông qua `Task.checkCancellation()` hoặc `Task.isCancelled`) và ném ra lỗi `CancellationError` ngay lập tức để ngắt vòng lặp/công việc đang làm?

---

## 💀 Level 4: Very Hard (Cực Khó)
*Mục tiêu: Giải quyết các "cạm bẫy" kiến trúc (Reentrancy), Deadlock nâng cao, và xử lý luồng dữ liệu liên tục.*

### Bài tập 4.1: Cạm bẫy Actor Reentrancy (Tái xâm nhập)
**Bối cảnh:** Bạn viết một `actor ImageCache` có hàm `func getImage(url:) async -> Image`. 
Logic của hàm: 
1. Kiểm tra cache, có thì trả về. 
2. Chưa có thì gọi API tải (`await fetchNetwork(...)`). 
3. Tải xong thì lưu cache rồi trả về.
**Vấn đề Reentrancy:** Nếu có 10 chỗ trong app cùng gọi `getImage` cho 1 URL *cùng một lúc*, do tính chất nhường quyền (yield) tại điểm `await`, hàm `fetchNetwork` sẽ bị gọi dư thừa tới 10 lần.
**Nhiệm vụ:** Viết lại `ImageCache` để giải quyết vấn đề này. 
*(Gợi ý: Thay vì lưu trực tiếp `Image`, hãy thử lưu một Dictionary chứa `Task<Image, Error>`. Khi đó các request sau chỉ việc `await` vào Task đang chạy thay vì tạo request mạng mới).*

### Bài tập 4.2: Priority Inversion & Lợi ích của Swift Concurrency
**Yêu cầu (Lý thuyết kết hợp Code):** 
1. Tạo một tình huống gây ra "Priority Inversion" (Đảo ngược độ ưu tiên) bằng GCD: Một luồng High Priority bị kẹt chờ một Semaphore đang bị giữ bởi luồng Low Priority.
2. Giải thích tại sao cấu trúc `Task` và Actor của Swift Concurrency giải quyết được vấn đề này (thông qua cơ chế Priority Escalation tự động)? Viết code mô phỏng 1 Task cha (High priority) sinh ra 1 Task con, xem Task con có kế thừa priority không.

### Bài tập 4.3: Mô hình Producer - Consumer với AsyncStream
**Yêu cầu:**
Không dùng Notification Center hay Combine, hãy sử dụng `AsyncStream` để thiết kế một luồng dữ liệu một chiều liên tục:
- **Producer (Người tạo):** Sinh ra một số ngẫu nhiên mỗi 0.5 giây. Nếu sinh ra số chẵn chia hết cho 10 (vd 10, 20), thì kết thúc/đóng luồng phát (finish stream).
- **Consumer (Người nhận):** Một vòng lặp `for await num in stream` liên tục đón nhận các con số này, cập nhật UI (giả lập bằng hàm in ra console) trên MainActor. 
- Yêu cầu cấu trúc code sao cho hàm sinh số và hàm nhận số nằm ở 2 class/function hoàn toàn tách biệt.
