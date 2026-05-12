# 📅 THÁNG 5: Advanced iOS (AVFoundation & Metal)

*Mục tiêu: Sở hữu chuyên môn sâu (Domain expertise). Media xử lý là mảng rất ít người làm giỏi.*

---

## 🗓 Tuần 1: Camera Pipeline
* **Thứ 2:** Kiến trúc cơ bản AVFoundation.
  * **Lý thuyết:** Mô hình luồng dữ liệu (Data Pipeline). Trái tim là `AVCaptureSession`, lấy data từ Input (ống kính, mic) và đẩy sang Output.
  * **Ví dụ:** Tạo một session đơn giản, xin quyền truy cập camera (Privacy permission). Chạy session trên một DispatchQueue riêng để không lock UI.
* **Thứ 3:** Cấu hình Input & Output.
  * **Lý thuyết:** `AVCaptureDeviceInput` (Thiết lập độ phân giải 1080p/4K, fps 30/60). `AVCaptureVideoDataOutput` (Nhận từng khung hình dạng raw data). `AVCapturePhotoOutput` (Chụp ảnh tĩnh phân giải gốc).
  * **Ví dụ:** Viết code tìm thiết bị camera mặt trước góc rộng, cấu hình khóa focus (AF) và exposure (AE), sau đó connect vào session.
* **Thứ 4:** Khung hình thô (Sample Buffer).
  * **Lý thuyết:** `CMSampleBuffer` là lõi của cấu trúc media. Nó chứa thời gian (timestamp) và dữ liệu hình ảnh thô (`CVPixelBuffer` - Core Video Buffer).
  * **Ví dụ:** Implement delegate của data output. Ép kiểu CMSampleBuffer sang CVPixelBuffer. Đọc kích thước chiều dài, rộng thực tế của ảnh (VD: 1920x1080).
* **Thứ 5:** Hiển thị Preview thủ công.
  * **Lý thuyết:** Native có `AVCaptureVideoPreviewLayer`, nhưng nếu muốn áp dụng filter hoặc tự vẽ, cần đọc buffer và chuyển thành Image gắn lên UIImageView, hoặc vẽ bằng CoreGraphics (tệ).
  * **Ví dụ:** Trong delegate, convert CVPixelBuffer -> CIImage -> UIImage. Cập nhật UI image view liên tục 30 FPS. Chú ý luồng cập nhật UI (main thread).
* **Thứ 6:** `AVAssetWriter` (Ghi video ra tệp).
  * **Lý thuyết:** Lưu data raw xuống đĩa. Cấu hình codec (H.264, HEVC), bit rate để nén. Sử dụng WriterInput để "đút" từng buffer ảnh và âm thanh vào.
  * **Ví dụ:** Mở file mp4 mới, nhận buffer từ Camera, ghi đè timestamp và append vào AVAssetWriterInput liên tục.
* **Thứ 7:** Thực hành: Camera Raw.
  * **Ví dụ:** Code app bật camera, in log tốc độ nhận khung hình. Bấm nút thu hình, ghi trực tiếp ra 1 file `.mp4` vào bộ nhớ máy, sau đó lưu ra Photo Library.
* **Chủ nhật:** 💤 **Rest Day**.

## 🗓 Tuần 2: Media Processing & Export
* **Thứ 2:** Audio/Video Synchronization.
  * **Lý thuyết:** Micro và Camera thu hình ở 2 luồng độc lập, thời gian trễ. Phải ghép đúng Presentation Timestamp (PTS) nếu không video sẽ bị lệch mồm (hình đi trước tiếng).
  * **Ví dụ:** Handle cả 2 đường `AVCaptureAudioDataOutput` và `AVCaptureVideoDataOutput`. Dựa theo timestamp để feed đúng thứ tự vào AssetWriter.
* **Thứ 3:** Đọc và Xử lý video có sẵn.
  * **Lý thuyết:** Đọc video từ Photos (`AVAsset`). Sử dụng `AVAssetReader` lấy từng buffer ngược trở ra bộ nhớ để tuỳ chỉnh.
  * **Ví dụ:** Load một video cũ trong máy. Đọc từng frame qua Reader, in log PTS để xem thứ tự khung hình.
* **Thứ 4:** Composition (Cắt/Ghép cơ bản).
  * **Lý thuyết:** `AVMutableComposition` cho phép tạo "timeline dựng phim". Xếp Track hình, Track tiếng của video A tiếp nối video B.
  * **Ví dụ:** Code tính năng nối 2 video quay rời rạc vào thành 1 video duy nhất.
* **Thứ 5:** Export Video (Nén dung lượng).
  * **Lý thuyết:** `AVAssetExportSession` là wrapper đơn giản nhất để render video. Tuỳ chỉnh preset (VD: `AVAssetExportPreset1280x720`).
  * **Ví dụ:** Lấy video ở Thứ 4, chạy lệnh export ra độ phân giải thấp hơn để gửi qua mạng.
* **Thứ 6:** Background Task for Export.
  * **Lý thuyết:** Export video 5 phút rất lâu, user ẩn app sẽ bị hệ điều hành kill. Cần cấu hình `UIApplication.shared.beginBackgroundTask` để xin iOS kéo dài thời gian sống thêm 3 phút.
  * **Ví dụ:** Xử lý background task trong quá trình lưu video. In log báo thành công kể cả khi app đã vuốt ẩn.
* **Thứ 7:** Thực hành: Trình cắt video (Trimmer).
  * **Ví dụ:** Nhập 1 video 60s. Viết code cắt bỏ 10 giây đầu và 10 giây cuối. Tăng tốc độ đoạn giữa x2 lần (Dùng `scaleTimeRange` của Composition).
* **Chủ nhật:** 💤 **Rest Day**.

## 🗓 Tuần 3: Core Image & GPU Rendering Basics
* **Thứ 2:** Giới thiệu Core Image (`CIImage`, `CIFilter`).
  * **Lý thuyết:** Dùng GPU để lọc hình ảnh siêu tốc. `CIContext` phân công việc xuống GPU (thông qua Metal phía dưới).
  * **Ví dụ:** Cấu hình khởi tạo 1 filter `CIFilter.sepiaTone()`. Truyền CIImage từ camera vào, lấy kết quả xuất ra màn hình.
* **Thứ 3:** CI Filter Pipeline (Chuỗi bộ lọc).
  * **Lý thuyết:** Kết nối Filter A output cắm vào Filter B input. Ưu điểm của Core Image là nó tự tổng hợp nhiều filter thành 1 quy trình (Single pass) tính toán trên GPU để tối ưu.
  * **Ví dụ:** Áp dụng màu Đen Trắng, sau đó chèn 1 cái Vignette (tối bốn góc) lên chung 1 hình ảnh.
* **Thứ 4:** Realtime rendering với MetalKit (`MTKView`).
  * **Lý thuyết:** Hiển thị UIImage liên tục rất tốn CPU RAM. Dùng MTKView, kết hợp `CIContext` vẽ trực tiếp `CIImage` xuất ra màn hình bằng sức mạnh GPU thuần.
  * **Ví dụ:** Config `MTKView`, delegate `draw(in:)`. Gọi `context.render(ciImage, to: currentDrawable.texture)` để tạo camera preview siêu mượt, không tốn chút RAM Heap nào.
* **Thứ 5:** Giới thiệu cấu trúc Metal thô.
  * **Lý thuyết:** Hiểu các khái niệm gốc đồ hoạ. Texture (Bản đồ điểm ảnh), Command Queue (Hàng đợi lệnh CPU nhét xuống GPU), Render Pipeline.
  * **Ví dụ:** Đọc tài liệu, vẽ diagram cách GPU xử lý song song hàng triệu Pixel thay vì xử lý tuần tự vòng lặp for của CPU.
* **Thứ 6:** Compute Shader Basics (Tuỳ chọn).
  * **Lý thuyết:** Shader là code C++ đặc biệt chạy trực tiếp trên card đồ hoạ. Giúp bạn tự code các thuật toán nén, filter tuỳ chỉnh.
  * **Ví dụ:** Tải project mẫu chạy thử Shader nhân đôi độ sáng của ảnh trên Metal C++. Không cần đi sâu.
* **Thứ 7:** Thực hành: Realtime LUT Filter.
  * **Ví dụ:** Dùng công nghệ Core Image `CIColorCube`, truyền một file ảnh LUT màu tải trên mạng để áp dụng bộ lọc màu điện ảnh thời gian thực lên MTKView.
* **Chủ nhật:** 💤 **Rest Day**.

## 🗓 Tuần 4: Project Bắt Buộc - Camera App Production
* **Thứ 2:** Tự xây dựng Custom Camera UI.
  * **Ví dụ:** Không dùng Picker. Vẽ các nút Shutter bấm quay video. Vuốt ngang trên màn hình mờ ảo đổi filter qua lại bằng Swipe Gesture.
* **Thứ 3:** Integrate Luồng Realtime + MTKView.
  * **Ví dụ:** Kết nối AVCaptureSession ra buffer, ném buffer qua filter LUT, rồi vẽ lên MTKView. Duy trì ổn định 60 fps.
* **Thứ 4:** Nhận diện Khuôn mặt (Vision).
  * **Ví dụ:** Lấy khung hình CVPixelBuffer, chạy qua framework `Vision` bắt toạ độ hình chữ nhật khuôn mặt. Vẽ một cái box vuông màu vàng bám theo khuôn mặt thời gian thực.
* **Thứ 5:** Ghi hình Video có chứa Filter.
  * **Ví dụ:** Nút quay video được ấn -> Thay vì ném frame thô gốc vào AVAssetWriter, thì lấy ảnh CIImage ĐÃ BỊ APPLY FILTER, render ngược lại thành CVPixelBuffer rồi mới ném vào lưu ra MP4.
* **Thứ 6:** Track Thermal & Memory leak.
  * **Ví dụ:** Render CVPixelBuffer CỰC KỲ DỄ bị rò rỉ RAM (Vì nó là ngôn ngữ C-Pointer). Nếu quay video bị dội RAM lên 1GB và máy nóng ran, hãy chạy tool Leaks kiểm tra việc quên dùng `CVPixelBufferRelease` hoặc quên block `autoreleasepool`.
* **Thứ 7:** Hoàn thiện App, Cleanup code.
  * **Ví dụ:** Refactor tách class CameraManager riêng, FilterManager riêng. Đảm bảo clean architecture nhất có thể.
* **Chủ nhật:** 💤 **Rest Day**.
