# Closure Capture: Hiểu đúng về `[weak self]` và `[unowned self]`

## 1. Khái niệm cốt lõi: Closure Capture & Retain Cycle

Mặc định, Closure trong Swift sẽ **tự động "chụp" (strongly capture)** tất cả các biến từ phạm vi bên ngoài mà nó sử dụng (bao gồm cả `self`). 

**Lưu ý quan trọng về Retain Cycle:**
Việc closure capture mạnh `self` **chưa chắc** đã tạo ra Retain Cycle (vòng lặp tham chiếu). Retain Cycle *chỉ xảy ra* khi và chỉ khi có đủ 2 điều kiện:
1. Class (thông qua `self`) giữ tham chiếu mạnh tới Closure (ví dụ: gán closure vào một property).
2. Closure giữ tham chiếu mạnh ngược lại Class (thông qua `self`).

> [!NOTE]
> **Ví dụ KHÔNG có cycle (Delayed Deallocation):**
> `DispatchQueue.main.async { self.doSomething() }`
> Lệnh này capture `self` strongly, nhưng class của bạn không sở hữu closure của `DispatchQueue`, nên không có vòng lặp. Nó chỉ làm `self` sống lâu thêm một chút cho đến khi block chạy xong.
> 
> **Ví dụ CÓ cycle:**
> `self.onCompletion = { self.doSomething() }`
> Class sở hữu closure thông qua property `onCompletion`, Closure lại giữ Class thông qua `self` $\rightarrow$ Vòng lặp.

## 2. Capture List là gì?

**Capture list** (cặp ngoặc vuông `[...]` ở đầu closure) là công cụ để chúng ta **phá vỡ** hoặc **điều khiển** hành vi capture mặc định của closure, nhằm tránh Retain Cycle.

### Sử dụng `[weak self]`

- **Bản chất:** Closure giữ tham chiếu **yếu (weak)** tới `self`.
- **Hệ quả:** 
  - `self` bên trong closure tự động trở thành một biến **Optional** (`Self?`).
  - Nếu `self` bị huỷ (deallocated) trước khi closure chạy, biến này tự động trở thành `nil`. Rất an toàn.
- **Cách dùng chuẩn:** Thường kết hợp với `guard let` để unwrap và bảo vệ luồng thực thi code.
  
```swift
self.onCompletion = { [weak self] in
    guard let self = self else { return }
    self.doSomething() // An toàn thực thi
}
```

### Sử dụng `[unowned self]`

- **Bản chất:** Closure giữ tham chiếu **unowned** tới `self`. Không làm tăng retain count giống như `weak`.
- **Hệ quả:**
  - `self` **không** bị ép thành kiểu Optional.
  - Nó **giả định (assume)** rằng `self` sẽ luôn luôn tồn tại chừng nào cái Closure này còn tồn tại.
- **Rủi ro (Crash):** Nếu `self` đã bị giải phóng mà closure này lại tình cờ được thực thi (ví dụ callback mạng trả về muộn khi màn hình đã bị đóng), ứng dụng sẽ **CRASH runtime ngay lập tức**.
- **Khi nào nên dùng:** Chỉ được phép dùng khi **chắc chắn 100%** closure và `self` có cùng vòng đời, hoặc closure luôn chạy trước khi `self` chết. 

```swift
class SomeClass {
    var someValue = 10
    
    // Dùng unowned an toàn ở đây vì closure này do chính class tạo ra 
    // và vòng đời của nó phụ thuộc 100% vào class này.
    lazy var someClosure: () -> Int = { [unowned self] in
        return self.someValue * 2
    }
}
```

## 3. Tóm tắt cho Phỏng vấn

> "Để cắt đứt Retain Cycle do Closure sinh ra, ta sử dụng **Capture List**. 
> - Dùng **`[weak self]`** an toàn vì nó biến `self` thành Optional và tự động thành `nil` nếu object bị huỷ. 
> - Dùng **`[unowned self]`** giúp code sạch hơn (không cần unwrap Optional) nhưng nguy hiểm, chỉ dùng khi ta **kiểm soát được 100% vòng đời**, đảm bảo closure không bao giờ chạy sau khi `self` đã bị deallocated."
