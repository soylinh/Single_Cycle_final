# RISC-V Single Cycle CPU - Universal Code (SC1 & SC2)

## 📚 **Giới thiệu**

Đây là bộ code **RISC-V Single Cycle** hoàn chỉnh, có thể chạy pass cả **SC1** và **SC2** trên hệ thống tự động chấm điểm của trường/công cụ chuẩn.


---

## 🏗️ **Cấu trúc các file**

- `RISCV_Single_Cycle.v`         : Top module của CPU.
- `ALU.v`                        : Khối thực hiện các phép toán số học & logic.
- `ALU_decoder.v`                : Bộ giải mã ALU control từ opcode/funct.
- `Branch_Comp.v`                : So sánh nhánh các điều kiện (beq, bne, blt...).
- `DMEM.v`                       : Data Memory (Bộ nhớ dữ liệu, 256 words, tự động đọc file cho đúng test).
- `IMEM.v`                       : Instruction Memory (Bộ nhớ lệnh, 256 words, tự động đọc file cho đúng test).
- `Imm_Gen.v`                    : Sinh giá trị Immediate theo định dạng lệnh.
- `RegisterFile.v`               : Bộ thanh ghi, hỗ trợ reset & cấm ghi x0.
- `control_unit.v`               : Điều khiển tổng, xuất ra các tín hiệu control chuẩn cho từng loại lệnh.

---

## 🔎 **Chức năng nổi bật**

- **Dùng chung cho cả SC1 và SC2:**  
  Không cần đổi code, chỉ cần cấp đúng file `.hex` tương ứng với từng test.
- **Memory tự động nhận file:**  
  - SC1: dùng `imem.hex`, `dmem_init.hex` (thường 128 dòng).
  - SC2: dùng `imem2.hex`, `dmem_init2.hex` (đủ 256 dòng).
- **Khắc phục lỗi timeout:**  
  Khi truy cập quá vùng lệnh có thật, sẽ trả về lệnh halt (`beq x0, x0, 0`), đảm bảo không bị mô phỏng vô hạn.

---

## 🚀 **Hướng dẫn chạy/submit code**

### **1. Chuẩn bị code**
- Copy toàn bộ các file `.v` này vào một folder mới (không để sót file nào).
- Không cần chỉnh sửa gì thêm, mọi thứ đã sẵn sàng để nộp.

### **2. Đảm bảo các file dữ liệu cho đúng test**
- **SC1:**  
  - Đặt các file: `./mem/imem.hex`, `./mem/dmem_init.hex`, `./mem/golden_output.txt`
- **SC2:**  
  - Đặt các file: `./mem/imem2.hex`, `./mem/dmem_init2.hex`, `./mem/golden_output2.txt`

> Nếu chấm trên autograder của trường, các file này sẽ được cấp sẵn hoặc copy đúng vào thư mục chấm.

### **3. Chạy lệnh chấm điểm**
python3 /srv/calab_grade/CA_Lab-2025/scripts/calab_grade.py sc1 ALU.v  ALU_decoder.v  Branch_Comp.v  DMEM.v  IMEM.v  Imm_Gen.v  RISCV_Single_Cycle.v  RegisterFile.v  control_unit.v

python3 /srv/calab_grade/CA_Lab-2025/scripts/calab_grade.py sc2 ALU.v  ALU_decoder.v  Branch_Comp.v  DMEM.v  IMEM.v  Imm_Gen.v  RISCV_Single_Cycle.v  RegisterFile.v  control_unit.v


