# Báo cáo 1 trang - Lab 4 DES / TripleDES

## Mục tiêu

Triển khai DES và TripleDES theo hợp đồng đầu vào/đầu ra để CI có thể kiểm tra. Hỗ trợ mã hoá/giải mã DES (multi-block với zero-padding) và TripleDES (E(K3, D(K2, E(K1,P))) / ngược lại).

## Cách làm / Phương pháp

- Thêm logic đọc stdin để nhận mode và dữ liệu theo README.
- Hoàn thiện KeyGenerator để sinh 16 round key theo PC-1/PC-2 và dịch trái.
- Dùng lớp DES để thực hiện 16 vòng Feistel với expansion, S-box và permutation.
- Tái sử dụng hàm encrypt với round key đảo chiều để thực hiện giải mã.

## Kết quả

- Chương trình in kết quả cuối cùng ở dạng chuỗi nhị phân, phù hợp cho CI.
- Đã thêm test mẫu trong thư mục tests/ để kiểm tra: mẫu encrypt, round-trip, multi-block/padding, tamper negative, wrong-key negative.

## Kết luận

Triển khai đã đáp ứng các yêu cầu cơ bản để CI kiểm tra. Hạn chế: dùng zero-padding (không an toàn cho production); TripleDES hiện chỉ hỗ trợ single-block theo hợp đồng; không lưu metadata độ dài plaintext. Hướng mở rộng: thêm padding PKCS, hỗ trợ TripleDES multi-block, cải thiện giao diện.
