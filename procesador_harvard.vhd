library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity procesador_harvard is
    port (
        clk_i : std_logic;
        reset : std_logic
    );
end entity procesador_harvard;

architecture Behavioral of procesador_harvard is
    -- señales internas
    signal read_reg_w  : std_logic;
    signal write_reg_w : std_logic;
    signal mem_read_w  : std_logic;
    signal mem_write_w : std_logic;
    signal is_branch_w  : std_logic;
    signal branch_taken: std_logic;
    signal sel_b_w     : std_logic;

    signal zero_flag_w     : std_logic;
    signal carry_flag_w    : std_logic;
    signal sign_flag_w     : std_logic;
    signal overflow_flag_w : std_logic;
    

    signal pc_i_w : STD_LOGIC_VECTOR(8 downto 0);
    signal pc_o_w : STD_LOGIC_VECTOR(8 downto 0);
    signal instruccion_w : STD_LOGIC_VECTOR(31 downto 0);
    signal ALU_control_w : std_logic_vector(4 downto 0);
    signal dato_C_w : STD_LOGIC_VECTOR(31 downto 0);
    signal dato_C_seleccionado_w : STD_LOGIC_VECTOR(31 downto 0);
    signal dato_A_w : STD_LOGIC_VECTOR(31 downto 0);
    signal dato_B_w : STD_LOGIC_VECTOR(31 downto 0);
    signal dato_B_seleccionado_w : STD_LOGIC_VECTOR(31 downto 0);
    signal inmediato_w : STD_LOGIC_VECTOR(31 downto 0);
    signal res_ALU_w: std_logic_vector(31 downto 0);
    signal dato_mem_w : STD_LOGIC_VECTOR(31 downto 0);
begin
    --AND DE SALTO
    branch_taken <= is_branch_w and (zero_flag_w or carry_flag_w or sign_flag_w or overflow_flag_w);

    -- INSTANCIA DE NUESTRO PC
    PC: entity work.contador_programa
        port map(
            clk_i       =>  clk_i,
            reset_i     =>  reset,
            isbranch_i  =>  branch_taken,
            pc_i        =>  pc_i_w,
            pc_o        =>  pc_o_w
        );

    -- INSTANCIA DE LA MEMORIA DE INSTRUCCIONES (ROM)
    MEM_INST: entity work.memoria_de_instrucciones
        port map(
            pc_actual   =>  pc_o_w,
            instruccion =>  instruccion_w
        );
    
    -- INSTANCIA DE NUESTRO DECODIFICADOR
    DEC: entity work.decodificador
        port map(
            opcode         =>  instruccion_w(4 downto 0),
            bit_control_b  =>  instruccion_w(15),
            ALU_control    =>  ALU_control_w,
            read_reg       =>  read_reg_w,
            write_reg      =>  write_reg_w,
            mem_read       =>  mem_read_w,
            mem_write      =>  mem_write_w,
            is_branch      =>  is_branch_w,
            sel_b          =>  sel_b_w
        );

    --MULTIPLEXOR DE SELECCION DE ORIGEN DE DATOS MEM TO REG
    dato_C_w <= res_ALU_w when  mem_read_w = '0' else dato_mem_w;

    --MULTIPLEXOR DE SELECCION DE DATO A INGRESAR A REGISTROS
    dato_C_seleccionado_w <= dato_C_w when is_branch_w = '0' else "000000000000000000000000" & pc_o_w;
    
    --INSTANCIA DE NUESTRO BANCO DE REGISTROS
    REGFILE: entity work.banco_de_registros
        port map(
            direccion_A =>  instruccion_w(14 downto 10),
            direccion_B =>  instruccion_w(20 downto 16),
            direccion_C =>  instruccion_w(9 downto 5),
            dato_C      =>  dato_C_seleccionado_w,
            read_reg    =>  read_reg_w,
            write_reg   =>  write_reg_w,
            dato_A      =>  dato_A_w,
            dato_B      =>  dato_B_w,
            clk_i       =>  clk_i
        );

    --EXTENSION DE SIGNO
    EXT_SIGN: entity work.extension_signo
        port map(
            instruccion_i =>  instruccion_w(31 downto 0),
            inmediato_o   =>  inmediato_w(31 downto 0)
        );
    
    --MULTIPLEXOR DE SELECCION DE OPERANDO B
    dato_B_seleccionado_w <= dato_B_w when sel_b_w = '0' else inmediato_w;

    --INSTANCIA DE LA ALU
    ALU1: entity work.ALU
        port map(
            operando_A    =>  dato_A_w,
            operando_B    =>  dato_B_seleccionado_w,
            ALU_control   =>  ALU_control_w,
            res_ALU       =>  res_ALU_w,
            zero_flag     =>  zero_flag_w,
            carry_flag    =>  carry_flag_w,
            sign_flag     =>  sign_flag_w,
            overflow_flag =>  overflow_flag_w
        );

    --INSTANCIA DE LA MEMORIA DE DATOS
    MEM_DATA: entity work.memoria_datos
        port map(
            dato_mem_i =>  dato_B_w,
            dir_mem_i  =>  res_ALU_w,
            clk_i      =>  clk_i,
            mem_read   =>  mem_read_w,
            mem_write  =>  mem_write_w,
            dato_mem_o =>  dato_mem_w
        );
    
end Behavioral;