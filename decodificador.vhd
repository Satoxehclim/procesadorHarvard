library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity decodificador is
    port (
        opcode        : in std_logic_vector(4 downto 0);
        bit_control_b : in std_logic;
        ALU_control   : out std_logic_vector(4 downto 0);
        read_reg      : out std_logic;
        write_reg     : out std_logic;
        mem_read      : out std_logic;
        mem_write     : out std_logic;
        is_branch     : out std_logic;
        sel_b         : out std_logic
    );
end entity decodificador;

architecture Behavioral of decodificador is 
begin
    process(opcode, bit_control_b)
    begin
        ALU_control <= opcode;
        read_reg <= '0';
        write_reg <= '0';
        mem_read <= '0';
        mem_write <= '0';
        is_branch <= '0';
        sel_b <= '0';

        case opcode is
            when "00000" | --ADD 
                 "00001" | --ADC 
                 "00111" | --AND 
                 "01000" | --OR 
                 "01001" | --XOR 
                 "01010" | --NAND 
                 "01011" | --NOR 
                 "01100" => --XNOR 
                sel_b <= bit_control_b;
                read_reg <= '1';
                write_reg <= '1';
            when "00110" => --LDI
                sel_b <= '1';
                read_reg <= '1';
                write_reg <= '1';
            when "00010" | --SUB 
                 "00011" | --INC 
                 "00100" | --DEC 
                 "00101" | --MOV 
                 "01101" | --NOT 
                 "01110" | --SHR 
                 "01111" | --SHL 
                 "10000" | --ROR 
                 "10001" => --ROL 
                read_reg <= '1';
                write_reg <= '1';
            when "10010" => -- CMP
                read_reg <= '1';
            when "10011" => -- ST
                sel_b <= '1';
                read_reg <= '1';
                mem_write <= '1';
            when "10100" => --LD
                sel_b <= '1';
                read_reg <= '1';
                write_reg <= '1';
                mem_read <= '1';
            when "10101" | --JMP
                 "10110" | --JC
                 "10111" | --JNC
                 "11000" | --JS
                 "11001" | --JNS
                 "11010" | --JV
                 "11011" | --JNV
                 "11100" | --JZ
                 "11101" => --JNZ
                 sel_b <= '1';
                 is_branch <= '1';
            when others =>
                null;
        end case;
    end process;
end Behavioral;