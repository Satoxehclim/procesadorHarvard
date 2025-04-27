library library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity memoria_datos is
    port(
        dato_mem_i : STD_LOGIC_VECTOR(31 downto 0);
        dir_mem_i  : STD_LOGIC_VECTOR(31 downto 0);
        clk_i      : STD_LOGIC;
        mem_read   : STD_LOGIC;
        mem_write  : STD_LOGIC;
        dato_mem_o : STD_LOGIC_VECTOR(31 downto 0)
    );
end memoria_datos;

architecture Behavioral of memoria_datos is type ram_type is array (0 to 1023) of STD_LOGIC_VECTOR(31 downto 0);
signal ram : ram_type := (others => (others => '0'));
begin
    process(clk_i)
    begin
        if rising_edge(clk_i) then
            if mem_write = '1' then
                ram(to_integer(unsigned(dir_mem_i(9 downto 0)))) <= dato_mem_i;
            end if;
        end if;
    end process;

    dato_mem_o <= ram(to_integer(unsigned(dir_mem_i(9 downto 0)))) when mem_read = '1' else (others => '0');
end Behavioral;