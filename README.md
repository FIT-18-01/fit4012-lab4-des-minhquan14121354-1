[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/BJH8GGf3)
# FIT4012 - Lab 4: DES / TripleDES Starter Repository

Repo này là **starter repo** cho Lab 4 của FIT4012.  

## 1. Cấu trúc repo

```text
.
├── .github/
│   ├── scripts/
│   │   └── check_submission.sh
│   └── workflows/
│       └── ci.yml
├── logs/
│   ├── .gitkeep
│   └── README.md
├── scripts/
│   └── run_sample.sh
├── tests/
│   ├── test_des_sample.sh
│   ├── test_encrypt_decrypt_roundtrip.sh
│   ├── test_multiblock_padding.sh
│   ├── test_tamper_negative.sh
│   └── test_wrong_key_negative.sh
├── .gitignore
├── CMakeLists.txt
├── Makefile
├── README.md
├── des.cpp
└── report-1page.md
```

## 2. Cách chạy chương trình (How to run)

### Cách 1: Dùng Makefile

```bash
make
./des
```

### Cách 2: Biên dịch trực tiếp

```bash
g++ -std=c++17 -Wall -Wextra -pedantic des.cpp -o des
./des
```

### Cách 3: Dùng CMake

```bash
cmake -S . -B build
cmake --build build
./build/des
```

## 3. Input / Đầu vào

Chương trình này tuân thủ quy chuẩn nộp bài được sử dụng bởi hệ thống CI (Tích hợp liên tục). Chương trình sẽ đọc dữ liệu từ đầu vào tiêu chuẩn (stdin) theo thứ tự như sau:

- Giá trị đầu tiên: Chế độ (số nguyên)
  - 1 = Mã hóa DES
  - 2 = Giải mã DES
  - 3 = Mã hóa TripleDES (3DES)
  - 4 = Giải mã TripleDES (3DES)

Tùy thuộc vào chế độ bạn chọn ở trên, bạn sẽ cần nhập tiếp các thông tin tương ứng:

- Chế độ 1 (Mã hóa DES): văn bản gốc (chuỗi nhị phân, độ dài bất kỳ), khóa (chuỗi nhị phân 64-bit).
- Chế độ 2 (Giải mã DES): bản mã (chuỗi nhị phân, ưu tiên độ dài là bội số của 64), khóa (chuỗi nhị phân 64-bit).
- Chế độ 3 (Mã hóa TripleDES): văn bản gốc (chuỗi nhị phân 64-bit), khóa K1 (64-bit), khóa K2 (64-bit), khóa K3 (64-bit).
- Chế độ 4 (Giải mã TripleDES): bản mã (chuỗi nhị phân 64-bit), khóa K1, K2, K3.

Notes:
- Plaintext và các khóa (keys) phải được cung cấp dưới dạng các chuỗi chỉ chứa ký tự '0' và '1'. Các khóa nên có độ dài 64 bit để quá trình lập lịch khóa (key scheduling) diễn ra chính xác.
- Đối với Chế độ 1, chương trình chấp nhận văn bản gốc (plaintext) có độ dài bất kỳ và tự động chia văn bản đó thành các khối (blocks) 64-bit.

## 4. Output / Đầu ra

Chương trình in kết quả cuối cùng ra stdout dưới dạng một chuỗi nhị phân duy nhất (chỉ gồm ký tự '0' và '1'). Đây là chuỗi mà CI sẽ trích xuất và so sánh.

Chi tiết:
- DES mã hoá (Mode 1): in ra chuỗi ciphertext là kết quả nối các block (một chuỗi nhị phân). Không in thêm dòng debug hay prompt.
- DES giải mã (Mode 2): in ra plaintext đã phục hồi (nối các block đã giải mã). Lưu ý có thể có zero-padding ở cuối nếu plaintext gốc không chia hết cho 64.
- TripleDES (Mode 3 và 4): in ra một block 64-bit kết quả dưới dạng chuỗi nhị phân.

Quan trọng: chương trình không được in các dòng log thừa, prompt hay round keys ra stdout khi CI sử dụng; chỉ in chuỗi nhị phân kết quả cuối cùng.

## 5. Padding đang dùng

Triển khai này sử dụng zero-padding đơn giản cho block cuối cùng:

- Nếu plaintext dài hơn 64 bit, nó được chia thành các block 64 bit và xử lý tuần tự.
- Nếu block cuối thiếu bit, sẽ thêm các ký tự '0' để đầy đủ 64 bit.

Hạn chế:
- Zero-padding có thể gây nhầm lẫn nếu plaintext gốc kết thúc bằng bit '0'; chương trình hiện không lưu metadata về độ dài nên không luôn phân biệt được padding với bit 0 hợp lệ.
- Cách padding này chỉ phù hợp cho mục đích học tập; trong thực tế cần dùng chuẩn padding và/hoặc metadata về độ dài (ví dụ PKCS#7).

## 6. Tests bắt buộc

Repo này đã tạo sẵn **5 tên file test mẫu** để sinh viên điền nội dung:

- `tests/test_des_sample.sh`
- `tests/test_encrypt_decrypt_roundtrip.sh`
- `tests/test_multiblock_padding.sh`
- `tests/test_tamper_negative.sh`
- `tests/test_wrong_key_negative.sh`

Sinh viên phải tự hoàn thiện test và bổ sung minh chứng chạy.

## 7. Logs / Minh chứng

Thư mục `logs/` dùng để nộp minh chứng, ví dụ:
- ảnh chụp màn hình khi chạy chương trình
- output của test
- log thử đúng / sai key / tamper
- log cho mã hóa nhiều block

## 8. Ethics & Safe use

- Chỉ chạy và kiểm thử trên dữ liệu học tập hoặc dữ liệu giả lập.
- Không dùng repo này để tấn công hay can thiệp hệ thống thật.
- Không trình bày đây là công cụ bảo mật sẵn sàng cho môi trường sản xuất.
- Nếu tham khảo mã, tài liệu, công cụ hoặc AI, phải ghi nguồn rõ ràng.
- Khi cộng tác nhóm, cần trung thực học thuật và mô tả đúng phần việc của mình.
- Việc kiểm thử chỉ phục vụ học DES / TripleDES ở mức nhập môn.

## 9. Checklist nộp bài

Trước khi nộp, cần có:
- `des.cpp`
- `README.md` hoàn chỉnh
- `report-1page.md` hoàn chỉnh
- `tests/` với ít nhất 5 test
- có negative test cho `tamper` và `wrong key`
- `logs/` có ít nhất 1 file minh chứng thật
- không còn dòng `TODO_STUDENT`

## 10. Lưu ý về CI

CI sẽ **không chỉ kiểm tra file có tồn tại** mà còn kiểm tra:
- các mục bắt buộc trong README
- các mục bắt buộc trong report
- sự hiện diện của negative tests
- có minh chứng trong `logs/`
- repo **không còn placeholder `TODO_STUDENT`**

Vì vậy repo starter này sẽ **chưa pass CI** cho tới khi sinh viên hoàn thiện nội dung.


## 11. Submission contract để auto-check Q2 và Q4

Để GitHub Actions kiểm tra được **Q2** và **Q4**, repo này dùng **một contract nhập/xuất thống nhất**.
Sinh viên cần sửa `des.cpp` để chương trình nhận dữ liệu từ **stdin** theo đúng thứ tự sau:

```text
Chọn mode:
1 = DES encrypt
2 = DES decrypt
3 = TripleDES encrypt
4 = TripleDES decrypt
```

### Mode 1: DES encrypt 
Nhập lần lượt:
1. `1`
2. plaintext nhị phân
3. key 64-bit

Yêu cầu:
- nếu plaintext dài hơn 64 bit: chia block 64 bit và mã hóa tuần tự
- nếu block cuối thiếu bit: zero padding
- in ra **ciphertext cuối cùng** dưới dạng chuỗi nhị phân

### Mode 2: DES decrypt
Nhập lần lượt:
1. `2`
2. ciphertext nhị phân
3. key 64-bit

Yêu cầu:
- giải mã DES theo round keys đảo ngược
- in ra plaintext cuối cùng

### Mode 3: TripleDES encrypt 
Nhập lần lượt:
1. `3`
2. plaintext 64-bit
3. `K1`
4. `K2`
5. `K3`

Yêu cầu:
- thực hiện đúng chuỗi **E(K3, D(K2, E(K1, P)))**
- in ra ciphertext cuối cùng

### Mode 4: TripleDES decrypt 
Nhập lần lượt:
1. `4`
2. ciphertext 64-bit
3. `K1`
4. `K2`
5. `K3`

Yêu cầu:
- thực hiện giải mã TripleDES ngược lại
- in ra plaintext cuối cùng

### Lưu ý về output
- Có thể in prompt tiếng Việt hoặc tiếng Anh.
- Có thể in thêm round keys hay thông báo trung gian.
- Nhưng **kết quả cuối cùng phải xuất hiện dưới dạng một chuỗi nhị phân dài hợp lệ** để CI tách và đối chiếu.

## 14. CI hiện kiểm tra được gì

Ngoài checklist nộp bài, CI hiện còn kiểm tra tự động:
- chương trình thực sự nhận plaintext/key từ bàn phím và mã hóa multi-block với zero padding đúng.
- chương trình thực sự mã hóa và giải mã TripleDES đúng theo vector kiểm thử.

Nói cách khác, nếu sinh viên chỉ sửa README/tests cho đủ hình thức mà **không làm Q2 hoặc Q4**, CI sẽ vẫn fail.
