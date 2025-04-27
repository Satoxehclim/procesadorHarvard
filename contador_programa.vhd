library library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity contador_programa is
    port(
        clk_i       : in STD_LOGIC;
        reset_i     : in STD_LOGIC;
        isbranch_i  : in STD_LOGIC;
        pc_i        : in STD_LOGIC_VECTOR(8 downto 0);
        pc_o        : out STD_LOGIC_VECTOR(8 downto 0)
    );
end contador_programa;

architecture Behavioral of contador_programa is signal pc_reg : STD_LOGIC_VECTOR(8 downto 0) := (others => '0');
begin
    process(clk_i, reset_i)
    begin
        if reset_i = '1' then
            pc_reg <= (others => '0');
        elsif rising_edge(clk_i) then
            if isbranch_i = '1' then
                pc_reg <= pc_i;
            else
                pc_reg <= STD_LOGIC_VECTOR(unsigned(pc_reg)+1);
            end if;
        end if;
    end process;
    pc_out <= pc_reg;
end Behavioral;