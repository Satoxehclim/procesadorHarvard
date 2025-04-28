library IEEE;
use IEEE.std_logic_1164.all;
use STD.textio.all;
use IEEE.numeric_std.all;

entity memoria_de_instrucciones is
    port(
        pc_actual   : in  STD_LOGIC_VECTOR(8 downto 0);
        instruccion : out STD_LOGIC_VECTOR(31 downto 0)
    );
end memoria_de_instrucciones;

architecture Behavioral of memoria_de_instrucciones is type rom_type is array (0 to 511) of STD_LOGIC_VECTOR(31 downto 0);

    impure function init_rom_from_file(filename : string) return rom_type is
        file rom_file : text open read_mode is filename;
        variable rom_line : line;
        variable rom_value : bit_vector(31 downto 0);
        variable temp_rom : rom_type;
        begin
            for i in rom_type'range loop
                readline(rom_file, rom_line);
                read(rom_line, rom_value);
                temp_rom(i) := to_stdlogicvector(rom_value);
            end loop;
            return temp_rom;
        end function;

        signal rom : rom_type := init_rom_from_file("datos.bin");
begin
    instruccion <= rom(to_integer(unsigned(pc_actual)));
end Behavioral;