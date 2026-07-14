# x86 MASM Assembly Big Number Addition (Arbitrary Precision)

An optimized 32-bit x86 Assembly algorithm built using MASM that performs arbitrary-precision addition on extremely large numbers. Since standard CPU registers cannot hold massive integers directly, this program processes numbers of any size by handling them as text strings.

## ⚙️ Core Logic & Algorithm Flow

The program executes the addition using a low-level, step-by-step pipeline:
1. **ASCII to Numeric Conversion:** It reads individual character bytes from two string variables and converts them into raw numeric digits.
2. **Digit-by-Digit Addition:** It performs manual low-level addition on these digits from right to left, carefully calculating and propagating carry-overs.
3. **Numeric to ASCII Conversion:** The accumulated sums are converted back into valid ASCII text characters.
4. **Buffer Storage:** The final formatted text result is written and returned into a distinct third variable (`sum` buffer) for output.

## 🚀 Key Features

* **Infinite-Length Addition:** Bypasses standard 32-bit/64-bit integer limits by dynamically using string variables.
* **Low-Level Carry Handling:** Implements precise conditional logic to handle multi-stage carries during accumulation.
* **Leading Zero Suppression:** Automatically skips unnecessary padding or leading zeros before printing the final result.

## 📁 File Structure

* `big_number_addition.asm` - The main source code containing string parsing, mathematical processing, and ASCII formatting routines.

## 🛠️ Requirements & Setup

* **Assembler:** MASM (Microsoft Macro Assembler)
* **Environment:** Microsoft Visual Studio (configured for x86/MASM) or Linker with `msvcrt.lib` / `ucrt.lib`.
