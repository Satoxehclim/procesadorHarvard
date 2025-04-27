library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity extension_signo is
    port(
        instruccion_i : STD_LOGIC_VECTOR(31 downto 0);
        inmediato_o  : STD_LOGIC_VECTOR(31 downto 0)
    );
end extension_signo;

architecture Behavioral of extension_signo is
begin
    --opcode = instruccion_i(4 downto 0)
    process(instruccion_i(4 downto 0))
    begin
        --opcode = instruccion_i(4 downto 0)
        case instruccion_i(4 downto 0) is
            when "00000" | "00001" | "00111" | "01000" | "01001" | "01010" | "01011" | "01100" =>
                inmediato_o <= (31 downto 16 => instruccion_i(31)) & instruccion_i(31 downto 16);
            when "00110" =>
                inmediato_o <= (31 downto 17 => instruccion_i(31)) & instruccion_i(31 downto 15);
            when "10011" | "10100" =>
                inmediato_o <= (31 downto 22 => instruccion_i(31)) & instruccion_i(31 downto 10);
            when "10110" | "10111" | "11000" | "11001" | "11010" | "11011"| "11100" | "11101" =>
                inmediato_o <= (31 downto 26 => instruccion_i(31)) & instruccion_i(31 downto 5);
            when others => 
            inmediato_o <= (others => '0')
        end case;
    end process;
end Behavioral;
