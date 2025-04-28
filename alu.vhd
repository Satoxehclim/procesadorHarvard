library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ALU is
    port (
        operando_A    : in STD_LOGIC_VECTOR(31 downto 0);
        operando_B    : in STD_LOGIC_VECTOR(31 downto 0);
        ALU_control   : in std_logic_vector(4 downto 0);
        res_ALU       : out std_logic_vector(31 downto 0);
        zero_flag     : out std_logic;
        carry_flag    : out std_logic;
        sign_flag     : out std_logic;
        overflow_flag : out std_logic
    );
end entity ALU;

architecture Behavioral of ALU is
    signal A                 : unsigned(31 downto 0);
    signal B                 : unsigned(31 downto 0);
    signal res               : unsigned(31 downto 0);
    signal temp_res          : unsigned(32 downto 0);
    signal carry_internal    : std_logic := '0';
    signal overflow_internal : std_logic := '0';
begin

    A <= unsigned(operando_A);
    B <= unsigned(operando_B);
    process(A, B, ALU_control)
    begin
        res <= (others => '0');
        temp_res  <= (others => '0');
        carry_internal <= '0';
        overflow_internal <= '0';

        case ALU_control is
            when "00000" => --ADD
                temp_res <= ('0' & A) + ('0' & B);
                res <= temp_res(31 downto 0);
                carry_internal <= temp_res(32);
                overflow_internal <= (A(31) and B(31) and (not res(31))) or ((not A(31)) and (not B(31)) and res(31));
            when "00001" => --ADC
                temp_res <= ('0' & A) + ('0' & B) + ("0000000000000000000000000000000" & carry_internal);
                res <= temp_res(31 downto 0);
                carry_internal <= temp_res(32);
                overflow_internal <= (A(31) and B(31) and (not res(31))) or ((not A(31)) and (not B(31)) and res(31));
            when "00010" => --SUB
                temp_res <=('0' & A) - ('0' & B);
                res <= temp_res(31 downto 0);
                carry_internal <= temp_res(32);
            when "00011" => --INC
                temp_res <= ('0' & A) + 1;
                res <= temp_res(31 downto 0);
                carry_internal <= temp_res(32);
            when "00100" => --DEC
                temp_res <= ('0' & A) - 1;
                res <= temp_res(31 downto 0);
                carry_internal <= temp_res(32);
            when "00101" => --MOV
                res <= B;
            when "00110" => --LDI
                res <= B;
            when "00111" => --AND
                res <= A and B;
            when "01000" => --OR
                res <= A or B;
            when "01001" => --XOR
                res <= A xor B;
            when "01010" => --NAND
                res <= not (A and B);
            when "01011" => --NOR
                res <= not (A or B);
            when "01100" => --XNOR
                res <= not (A xor B);
            when "01101" => --NOT
                res <= not A;
            when "01110" => --SHR
                res <= '0' & A(31 downto 1);
            when "01111" => --SHL
                res <= A(30 downto 0) & '0';
            when "10000" => --ROR
                res <= A(0) & A(31 downto 1);
            when "10001" => --ROL
                res <= A(30 downto 0) & A(31);
            when "10010" => --CMP
                temp_res <= ('0' & A) - ('0' & B);
                res <= temp_res(31 downto 0);
                carry_internal <= temp_res(32);
                overflow_internal <= (A(31) and B(31) and (not res(31))) or ((not A(31)) and (not B(31)) and res(31));
            when others =>
                res <= (others => '0');
        end case;
    end process;
    
    res_ALU <= std_logic_vector(res);
    zero_flag <= '1' when res = 0 else '0';
    sign_flag <= res(31);
    carry_flag <= carry_internal;
    overflow_flag <= overflow_internal;
end Behavioral;