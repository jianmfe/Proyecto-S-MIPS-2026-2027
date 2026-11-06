library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Register_File is
    port (
        clk : in  std_logic;
        rst : in  std_logic;
        we  : in  std_logic;                      -- Write Enable
        wa  : in  std_logic_vector(4 downto 0);   -- Dirección de escritura (rd / rt)
        wd  : in  std_logic_vector(31 downto 0);  -- Dato a escribir
        ra1 : in  std_logic_vector(4 downto 0);   -- Dirección de lectura 1 (rs)
        ra2 : in  std_logic_vector(4 downto 0);   -- Dirección de lectura 2 (rt)
        rd1 : out std_logic_vector(31 downto 0);  -- Dato leído 1
        rd2 : out std_logic_vector(31 downto 0)   -- Dato leído 2
    );
end entity Register_File;

architecture RTL of register_file is

    -- Definición del banco de 32 registros de 32 bits
    type reg_array is array (0 to 31) of std_logic_vector(31 downto 0);
    signal regs : reg_array;

begin

    -- Puerto de lectura 1 (asíncrono con protección para $zero)
    process(ra1, regs)
    begin
        if to_integer(unsigned(ra1)) = 0 then
            rd1 <= (others => '0');
        else
            rd1 <= regs(to_integer(unsigned(ra1)));
        end if;
    end process;

    -- Puerto de lectura 2 (asíncrono con protección para $zero)
    process(ra2, regs)
    begin
        if to_integer(unsigned(ra2)) = 0 then
            rd2 <= (others => '0');
        else
            rd2 <= regs(to_integer(unsigned(ra2)));
        end if;
    end process;

    -- Puerto de escritura (síncrono al flanco de subida)
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                -- Limpiamos todo el banco al reiniciar
                for i in 0 to 31 loop
                    regs(i) <= (others => '0');
                end loop;
                -- Valores iniciales para $gp y $sp
                regs(28) <= x"00001800"; 
                regs(29) <= x"00003FFC"; 
            else
                -- Escritura condicional (evitamos tocar el registro $zero)
                if we = '1' and to_integer(unsigned(wa)) /= 0 then
                    regs(to_integer(unsigned(wa))) <= wd;
                end if;
                
                -- Asegurarnos de que $zero se mantenga blindado en 0
                regs(0) <= (others => '0');
            end if;
        end if;
    end process;

end architecture RTL;