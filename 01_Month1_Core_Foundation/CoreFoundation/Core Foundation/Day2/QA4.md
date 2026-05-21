# Stack vs Heap trong Swift

  ## 1. Khái niệm nhanh
  - `Stack`: vùng nhớ cấp phát theo **scope hàm**, cơ chế **LIFO** (Last In, First Out).
  - `Heap`: vùng nhớ cấp phát **động**, vòng đời không phụ thuộc trực tiếp vào scope hàm.

  ## 2. Ai quyết định object nằm ở đâu?
  - Chủ yếu là **Swift compiler** (compile-time optimization, escape analysis).
  - **Runtime/ARC** thực thi ở lúc chạy (retain/release, cấp phát/giải phóng heap).
  - Developer không “chọn tay” stack/heap trực tiếp trong đa số trường hợp.

  ## 3. Vì sao stack thường nhanh hơn heap?
  - Cấp phát/thu hồi stack chỉ là tăng/giảm con trỏ (`push/pop`) -> O(1), rất rẻ.
  - Stack có locality tốt hơn, dễ tận dụng CPU cache.
  - Heap cần allocator, metadata, quản lý phân mảnh, đôi khi lock đa luồng.
  - Heap thường đi kèm chi phí vòng đời object (ARC retain/release).

  ## 4. Cách lưu trữ
  - Stack lưu theo từng `stack frame` của hàm.
  - Mỗi frame thường chứa: local vars đơn giản, params, return address, register tạm.
  - Heap lưu theo các block cấp phát động, truy cập qua reference/pointer.
  - Block heap có metadata để allocator quản lý.

  ## 5. Vòng đời dữ liệu
  - Stack: sống trong scope hiện tại, thoát scope là thu hồi gần như ngay.
  - Heap: sống đến khi không còn strong reference (với Swift ARC).

  ## 6. Swift specifics (rất quan trọng)
  - `class` instance: thường ở heap.
  - `struct`, `enum`, tuple: value type, thường có lợi thế về locality; nhưng không có nghĩa luôn nằm stack.
  - `Array`, `String`, `Dictionary`: là value type nhưng storage bên dưới thường ở heap (copy-on-write).
  - Escaping closure thường cần heap; non-escaping closure có thể được tối ưu tốt hơn.

  ## 7. ARC vs autoreleasepool
  - `ARC` quản lý retain/release theo reference counting.
  - `autoreleasepool` là nơi “xả” các object autoreleased theo lô.
  - Trong app thường ngày, run loop đã có pool ngầm nên ít thấy dùng thủ công.
  - Dùng `autoreleasepool` khi có loop lớn/tác vụ batch tạo nhiều object tạm để giảm peak memory.

  ## 8. Khi nào gọi là object “lớn/phức tạp”?
  - Dữ liệu nhiều MB (ảnh/video/Data lớn).
  - Object graph sâu, nhiều object con.
  - Tạo/hủy/copy tốn CPU.
  - Gây triệu chứng thực tế: tăng peak memory, lag, memory warning/OOM.

  ## 9. Hiểu lầm phổ biến
  - “Value type = luôn stack”: sai.
  - “Reference type = luôn chậm”: sai.
  - “Phải tối ưu bằng cách ép stack”: thường không khả thi/không đúng hướng.
  - Hướng đúng: thiết kế semantics chuẩn, sau đó đo đạc.

  ## 10. Best practices thực dụng
  - Ưu tiên `struct` khi không cần shared identity hoặc inheritance.
  - Dùng `class` khi cần identity, shared mutable state, hoặc object lifecycle rõ ràng.
  - Tránh tạo object tạm quá nhiều trong loop nóng.
  - Thêm `autoreleasepool` có chủ đích ở batch nặng.
  - Luôn đo bằng `Instruments` (Allocations, Leaks, Time Profiler) trước khi kết luận.

  ## 11. Kết luận ngắn
  - Stack: nhanh, đơn giản, vòng đời ngắn theo scope.
  - Heap: linh hoạt, phù hợp dữ liệu sống lâu/chia sẻ, nhưng chi phí quản lý cao hơn.
  - Trong Swift, hãy tối ưu theo **semantics + measurement**, không tối ưu theo cảm tính stack/heap.
