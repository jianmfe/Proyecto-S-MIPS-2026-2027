library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
    port (
        -- Entradas de operandos y control
        A       : in  std_logic_vector(31 downto 0);
        B       : in  std_logic_vector(31 downto 0);
        ALU_OP  : in  std_logic_vector(2 downto 0);

        -- Salidas de resultado y estado
        RESULT  : out std_logic_vector(31 downto 0);
        ZERO    : out std_logic
    );
end entity ALU;

architecture RTL of ALU is

    signal res_internal : std_logic_vector(31 downto 0);

begin

    process (all)
        variable signed_a, signed_b : signed(31 downto 0);
        variable unsigned_b         : unsigned(31 downto 0);
        variable shift_amt          : integer range 0 to 31;
    begin
        -- Conversiones auxiliares para operaciones con signo y desplazamientos
        signed_a   := signed(A);
        signed_b   := signed(B);
        unsigned_b := unsigned(B);
        shift_amt  := to_integer(unsigned(A(4 downto 0))); -- El operando A o B inferior define el shamt

        case ALU_OP is
            -- 000: Suma (add, addi, lw, sw, cálculo de direcciones y PC)
            when "000" =>
                res_internal <= std_logic_vector(signed_a + signed_b);

            -- 001: Resta (sub, beq, bne)
            when "001" =>
                res_internal <= std_logic_vector(signed_a - signed_b);

            -- 010: AND (and, andi)
            when "010" =>
                res_internal <= A and B;

            -- 011: OR (or, ori)
            when "011" =>
                res_internal <= A or B;

            -- 100: Set on Less Than con signo (slt, slti)
            when "100" =>
                if signed_a < signed_b then
                    res_internal <= x"00000001";
                else
                    res_internal <= x"00000000";
                end if;

            -- 101: Shift Left Logical (sll)
            when "101" =>
                res_internal <= std_logic_vector(unsigned_b sll shift_amt);

            -- 110: Shift Right Logical (srl)
            when "110" =>
                res_internal <= std_logic_vector(unsigned_b srl shift_amt);

            -- Caso por defecto de seguridad
            when others =>
                res_internal <= (others => '0');
        end case;
    end process;

    -- Asignación de la salida de datos
    RESULT <= res_internal;

    -- Salida ZERO: se activa en 1 si el resultado es exactamente cero (útil para saltos y comparaciones)
    ZERO <= '1' when res_internal = x"00000000" else '0';

end architecture RTL;