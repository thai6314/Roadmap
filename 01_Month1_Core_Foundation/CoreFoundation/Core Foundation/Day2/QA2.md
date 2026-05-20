# Phân biệt `weak` & `unowned`?

Các biến được đánh dấu `weak` sẽ là Optional, sẽ tự gán bằng `nil` khi object bị hủy.
Các biến được đánh dấu `unowned` đảm bảo biến đó không bao giờ `nil`. Nếu object gốc bị chết (`nil`) sẽ gây ra crash khi runtime.

**Vậy câu hỏi đặt ra:**
- Tại sao phải sử dụng `unowned` mà không sử dụng `weak` cho an toàn? Mục đích tồn tại của `unowned` là gì?

## Trả lời

- `unowned` tồn tại với mục đích là để thể hiện rõ ý đồ thiết kế phần mềm (semantics & domain logic):
    - **`weak`**: Đối tượng A có vòng đời độc lập với B, A có thể biến mất bất cứ lúc nào.
    - **`unowned`**: A và đối tượng B có mối quan hệ phụ thuộc chặt chẽ (thường là Cha-Con). Đối tượng A chắc chắn phải sống lâu hơn, hoặc chết cùng lúc với B.
- **Fail-fast (Phát hiện lỗi sớm)**: Ý tưởng dùng `unowned` để crash và phát hiện lỗi logic ngay trong lúc phát triển (development environment). Thà ứng dụng crash ngay lập tức để sửa, còn hơn dùng `weak` để nó âm thầm trở thành `nil`, dẫn đến những logic sai lệch (silent bugs) cực kỳ khó debug sau này.
- **Clean code (Loại bỏ Optional)**: Nếu sử dụng `weak` thì liên tục phải dùng `if let`, `guard let` hoặc optional chaining (`?.`) khi muốn sử dụng $\rightarrow$ sinh ra boilerplate code.
- **Tối ưu hiệu suất (Performance Overhead)**:
    - **`weak`**: Khi bạn gán một biến `weak`, Swift Memory Management (ARC) phải sử dụng một cấu trúc dữ liệu bổ sung gọi là **Side Table** để theo dõi. Khi đối tượng gốc bị `deinit`, hệ thống phải chạy một tác vụ để dò tìm tất cả các biến `weak` đang trỏ tới nó và set chúng về `nil`. Quá trình này an toàn nhưng tốn kém (dù rất nhỏ) chi phí vận hành.
    - **`unowned`**: Không cần Optional, không cần tự động gán `nil`. Khi đối tượng gốc chết, vùng nhớ của nó bị thu hồi nhưng con trỏ `unowned` vẫn trỏ về địa chỉ đó. Khi truy cập vào, hệ thống chỉ kiểm tra cờ (flag) xem vùng nhớ còn hợp lệ không, nếu không thì ném ra crash. Việc này nhẹ và có hiệu suất cao hơn `weak`.

### Ví dụ: Customer và CreditCard

Một người dùng (`Customer`) có thể có hoặc chưa có thẻ tín dụng. Nhưng một cái thẻ tín dụng (`CreditCard`) được tạo ra thì bắt buộc phải thuộc về một người dùng cụ thể. Không thể có cái thẻ nào tồn tại mà không có chủ.

```swift
class Customer {
    let name: String
    var card: CreditCard? // Customer có thể chưa có thẻ (Optional)
    
    init(name: String) { 
        self.name = name 
    }
}

class CreditCard {
    let number: UInt64
    
    // Thẻ bắt buộc phải có chủ. Nếu chủ bị huỷ, thẻ cũng vô giá trị.
    // Dùng unowned ở đây phản ánh chính xác logic nghiệp vụ
    unowned let customer: Customer

    init(number: UInt64, customer: Customer) {
        self.number = number
        self.customer = customer
    }
}
```
