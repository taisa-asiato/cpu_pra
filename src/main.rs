// simple cpu isa mnemonic整数値対応
const MOV:  u16 =   0;
const ADD:  u16 =   1;
const SUB:  u16 =   2;
const AND:  u16 =   3;
const OR:   u16 =   4;
const SL:   u16 =   5;
const SR:   u16 =   6;
const SRA:  u16 =   7;
const LDL:  u16 =   8;
const LDH:  u16 =   9;
const CMP:  u16 =   10;
const JE:   u16 =   11;
const JMP:  u16 =   12;
const LD:   u16 =   13;
const ST:   u16 =   14;
const HLT:  u16 =   15;

// レジスタ
const REG0: u16 =   0;
const REG1: u16 =   1;
const REG2: u16 =   2;
const REG3: u16 =   3;
const REG4: u16 =   4;
const REG5: u16 =   5;
const REG6: u16 =   6;
const REG7: u16 =   7;
// 汎用レジスタ・メインメモリ（プログラム:rom, データ:ram)
static mut reg: [u16; 8]    = [0x0000; 8];
static mut rom: [u16; 256]  = [0x0000; 256];
static mut ram: [u16; 256]  = [0x0000; 256];

fn main() {
    let mut pc:u16;
    let mut ir:u16;
    let mut flag_eq:bool;

    assembler();

    ir = 0x0000;
    pc = 0x0000;
    flag_eq = false;
    unsafe{
        loop {
            ir = rom[pc as usize];
            println!("{:<5} {:<5x} {:<5} {:<5} {:<5} {:<5}", pc, ir, reg[0], reg[1], reg[2], reg[3]);
            pc += 1;

            match op_code(ir) {
                MOV => reg[op_regA(ir) as usize] = reg[op_regB(ir) as usize],
                ADD => reg[op_regA(ir) as usize] = reg[op_regA(ir) as usize] + reg[op_regB(ir) as usize],
                SUB => reg[op_regB(ir) as usize] = reg[op_regA(ir) as usize] - reg[op_regB(ir) as usize],
                AND => reg[op_regA(ir) as usize] = reg[op_regA(ir) as usize] & reg[op_regB(ir) as usize],
                OR  => reg[op_regA(ir) as usize] = reg[op_regA(ir) as usize] | reg[op_regB(ir) as usize],
                SL  => reg[op_regA(ir) as usize] = reg[op_regA(ir) as usize] >> 1,
                SR  => reg[op_regA(ir) as usize] = reg[op_regA(ir) as usize] << 1,
                SRA => reg[op_regA(ir) as usize] = (reg[op_regA(ir) as usize] & 0x8000) | (reg[op_regA(ir) as usize] << 1),
                LDL => reg[op_regA(ir) as usize] = (reg[op_regA(ir) as usize] & 0xff00) | (op_data(ir) & 0x00ff),
                LDH => reg[op_regA(ir) as usize] = (reg[op_regA(ir) as usize] & 0x00ff) | (op_data(ir) & 0xff00),
                CMP => if reg[op_regA(ir) as usize] == reg[op_regB(ir) as usize] { flag_eq = true; } else { flag_eq = false; },
                JE  => if flag_eq { pc = op_addr(ir); },
                JMP => pc = op_addr(ir),
                LD  => reg[op_regA(ir) as usize] = ram[op_addr(ir) as usize],
                ST  => ram[op_addr(ir) as usize] = reg[op_regA(ir) as usize],
                HLT => break,
                _   => break,
            }
        }
        println!("ram[64] = {}", ram[64]);
    }
}

fn op_code(ir: u16) -> u16 {
    ir >> 11
}

fn op_regA(ir: u16) -> u16 {
    (ir >> 8) & 0x0007
}

fn op_regB(ir: u16) -> u16 {
    (ir >> 5) & 0x0007
}

fn op_data(ir: u16) -> u16 {
    (ir & 0x00ff)
}

fn op_addr(ir: u16) -> u16 {
    (ir & 0x00ff)
}

fn assembler() {
    // REG0和の値
    unsafe {
        rom[0] = ldh(REG0, 0);
        rom[1] = ldl(REG0, 0);
        // インクリメントの値
        rom[2] = ldh(REG1, 0);
        rom[3] = ldl(REG1, 1);
        //　和算の回数
        rom[4] = ldh(REG2, 0);
        rom[5] = ldl(REG2, 0);
        // 回数
        rom[6] = ldh(REG3, 0);
        rom[7] = ldl(REG3, 10);
        rom[8] = add(REG2, REG1);
        rom[9] = add(REG0, REG2);
        rom[10] = st(REG0, 64);
        rom[11] = cmp(REG2, REG3);
        rom[12] = je(14);
        rom[13] = jmp(8);
        rom[14] = hlt();
    }
}

fn mov(ra:u16, rb:u16) -> u16 {
     (MOV << 11 | ra << 8 | rb << 5)
}

fn add(ra:u16, rb:u16) -> u16 {
     (ADD << 11 | ra << 8 | rb << 5)
}

fn sub(ra:u16, rb:u16) -> u16 {
     (SUB << 11 | ra << 8 | rb << 5)
}

fn or(ra:u16, rb:u16) -> u16 {
     (OR << 11 | ra << 8 | rb << 5)
}

fn and(ra: u16, rb: u16) -> u16 {
     (AND << 11 | ra << 8 | rb << 5)
}

fn sl(ra: u16) -> u16 {
     (SL << 11 | ra << 8)
}

fn sr(ra: u16) -> u16 {
     (SR << 11 | ra << 8)
}

fn sra(ra: u16) -> u16 {
     (SRA << 11 | ra << 8)
}

fn ldl(ra: u16, ival:u16) -> u16 {
     (LDL << 11 | ra << 8 | (ival & 0x00ff))
}

fn ldh(ra: u16, ival: u16) -> u16 {
     (LDH << 11 | ra << 8 | (ival & 0x00ff))
}

fn cmp(ra: u16, rb: u16) -> u16 {
     (CMP << 11 | ra << 8 | rb << 5)
}

fn je(addr: u16) -> u16 {
     (JE << 11 | (addr & 0x00ff))
}

fn jmp(addr: u16) -> u16 {
     (JMP << 11 | (addr & 0x00ff))
}

fn ld(ra: u16, addr: u16) -> u16 {
     (LD << 11 | ra << 8 | (addr & 0x00ff))
}

fn st(ra: u16, addr: u16) -> u16 {
     (ST << 11 | ra << 8 | (addr & 0x00ff))
}

fn hlt() -> u16 {
     (HLT << 11)
}
