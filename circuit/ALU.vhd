library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
    port (
        A       : in  std_logic_vector(31 downto 0);
        B       : in  std_logic_vector(31 downto 0);
        ALU_OP  : in  std_logic_vector(2 downto 0);
        RESULT  : out std_logic_vector(31 downto 0);
        ZERO    : out std_logic
    );
end entity ALU;

architecture RTL of ALU is

    signal res_internal : std_logic_vector(31 downto 0);

begin

    process (A, B, ALU_OP)
        variable signed_a   : signed(31 downto 0);
        variable signed_b   : signed(31 downto 0);
        variable unsigned_b : unsigned(31 downto 0);
        variable shift_amt  : integer range 0 to 31;
    begin

        signed_a   := signed(A);
        signed_b   := signed(B);
        unsigned_b := unsigned(B);
        shift_amt  := to_integer(unsigned(A(4 downto 0)));

        case ALU_OP is

            when "000" =>
                res_internal <= std_logic_vector(signed_a + signed_b);

            when "001" =>
                res_internal <= std_logic_vector(signed_a - signed_b);

            when "010" =>
                res_internal <= A and B;

            when "011" =>
                res_internal <= A or B;

            when "100" =>
                if signed_a < signed_b then
                    res_internal <= x"00000001";
                else
                    res_internal <= x"00000000";
                end if;

            when "101" =>
                res_internal <= std_logic_vector(
                    shift_left(unsigned_b, shift_amt)
                );

            when "110" =>
                res_internal <= std_logic_vector(
                    shift_right(unsigned_b, shift_amt)
                );

            when others =>
                res_internal <= (others => '0');

        end case;

    end process;

    RESULT <= res_internal;

    ZERO <= '1' when res_internal = x"00000000" else '0';

end architecture RTL;