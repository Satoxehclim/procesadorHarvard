library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity banco_de_registros is
    port(
        direccion_A : in STD_LOGIC_VECTOR(4 downto 0);
        direccion_B : in STD_LOGIC_VECTOR(4 downto 0);
        direccion_C : in STD_LOGIC_VECTOR(4 downto 0);
        dato_C      : in STD_LOGIC_VECTOR(31 downto 0);
        read_reg    : in std_logic;
        write_reg   : in std_logic;
        dato_A      : out STD_LOGIC_VECTOR(31 downto 0);
        dato_B      : out STD_LOGIC_VECTOR(31 downto 0);
        clk_i       : in  std_logic;
    );
end banco_de_registros;

architecture Behavioral of banco_de_registros is type reg_array is array (0 to 31) of STD_LOGIC_VECTOR(31 downto 0);
signal registros : reg_array := (others => (others => '0'));

    constant ZERO_REG : natural := 0;
begin 
    process(clk_i)
    begin
        if (rising_edge(clk_i)) then
            if write_reg = '1' and to_integer(unsigned(direccion_C)) /= ZERO_REG then
                registros(to_integer(unsigned(direccion_C))) <= dato_C;
            end if;
        end if;
    end process;

    dato_A <= registros(to_integer(unsigned(direccion_A)));
    dato_B <= registros(to_integer(unsigned(direccion_B)));
end Behavioral;