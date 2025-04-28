library IEEE;
use IEEE.std_logic_1164.all;

entity tb_procesador_harvard is
end tb_procesador_harvard;

architecture behavior of tb_procesador_harvard is
    signal clk_tb   : std_logic := '0';
    signal reset_tb : std_logic := '1';
begin

    -- Instancia del procesador
    UUT: entity work.procesador_harvard
        port map(
            clk_i => clk_tb,
            reset => reset_tb
        );

    -- Generador de clock (periodo de 10ns)
    clk_process : process
    begin
        while true loop
            clk_tb <= '0';
            wait for 5 ns;
            clk_tb <= '1';
            wait for 5 ns;
        end loop;
    end process;

    -- Reset inicial
    reset_process : process
    begin
        wait for 20 ns;
        reset_tb <= '0';
        wait;
    end process;

end behavior;
