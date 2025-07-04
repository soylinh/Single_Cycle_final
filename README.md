# RISC-V Single Cycle CPU (SC1 & SC2)


## **Components**

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

##  **Function**

- **Dùng chung cho cả SC1 và SC2:**  
  Không cần đổi code, chỉ cần cấp đúng file `.hex` tương ứng với từng test.
- **Memory tự động nhận file:**  
  - SC1: dùng `imem.hex`, `dmem_init.hex` (thường 128 dòng).
  - SC2: dùng `imem2.hex`, `dmem_init2.hex` (đủ 256 dòng).
- **Khắc phục lỗi timeout:**  
  Khi truy cập quá vùng lệnh có thật, sẽ trả về lệnh halt (`beq x0, x0, 0`), đảm bảo không bị mô phỏng vô hạn.

---

## **Hướng dẫn chạy/submit code**

- **SC1:**  
  - Đặt các file: `./mem/imem.hex`, `./mem/dmem_init.hex`, `./mem/golden_output.txt`
- **SC2:**  
  - Đặt các file: `./mem/imem2.hex`, `./mem/dmem_init2.hex`, `./mem/golden_output2.txt`


### ** Chạy lệnh test**
python3 /srv/calab_grade/CA_Lab-2025/scripts/calab_grade.py sc1 ALU.v  ALU_decoder.v  Branch_Comp.v  DMEM.v  IMEM.v  Imm_Gen.v  RISCV_Single_Cycle.v  RegisterFile.v  control_unit.v

python3 /srv/calab_grade/CA_Lab-2025/scripts/calab_grade.py sc2 ALU.v  ALU_decoder.v  Branch_Comp.v  DMEM.v  IMEM.v  Imm_Gen.v  RISCV_Single_Cycle.v  RegisterFile.v  control_unit.v


## **Check result in sim.log**

Sau khi chạy lệnh chấm điểm, ngoài thông báo pass/fail trên màn hình, bạn nên kiểm tra chi tiết file log kết quả tại:

- **Đường dẫn file log:**  
  `/tmp/grade_<tên_user>/sim.log`  
  (Ví dụ: `/tmp/grade_toannguyen/sim.log`)

### **Cách kiểm tra**

1. **Mở file sim.log bằng lệnh:**
    ```bash
    cat /tmp/grade_<tên_user>/sim.log
    ```
    Hoặc dùng bất kỳ trình soạn thảo văn bản nào (nano, vim, less...).

2. **Attention!!:**
    - Nếu có lỗi sẽ thấy các dòng báo mismatch ví dụ:
      ```
      ❗ PC mismatch at cycle 25: DUT = 00000050, Golden = 00000054
      ❗ x3 mismatch at cycle 38: DUT = 0000000a, Golden = 0000000b
      ❗ Dmem[7] mismatch at cycle 77: DUT = 00000000, Golden = 0000000f
      ```
      *Các thông báo này chỉ ra chính xác cycle nào, thanh ghi nào, ô nhớ nào bị sai.*

    - Nếu bị timeout do chương trình không dừng đúng, sẽ báo:
      ```
      ❗ ERROR: Simulation timed out after 10000 cycles!
      ```


---
