----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Jamie Michie
-- 
-- Create Date: 21.02.2020 15:44:13
-- Design Name: Counter16
-- Module Name: counter16 - Behavioral
-- Project Name: EN3512 Electronics 3
-- Target Devices: Basys3 - Artix 7
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity counter16 is
    Port ( 
           clk      : in std_logic;
           reset    : in std_logic;
           binOut   : out std_logic_vector(15 downto 0);
           load     : out std_logic
           );
           
end counter16;

architecture Behavioral of counter16 is
begin
 
    countProc : process(clk, reset)
       variable prescaler : unsigned(24 downto 0) := "0000000000000000000000000";
       variable counter   : unsigned(15 downto 0) := "0000000000000000";
       variable limit     : natural := 9999;
       variable prescaleLimit : natural := 33554431; --33554431
                begin
            
                    if (reset = '1') then
                        counter := "0000000000000000"; 
                        load <= '0';
                    elsif (rising_edge(clk)) then
                       if(prescaler < prescaleLimit) then 
                            prescaler := prescaler + 1;
                            load <= '0';
                        elsif (prescaler = prescaleLimit) then
                            prescaler := "0000000000000000000000000";
                            if (counter = limit) then
                                counter := "0000000000000000"; 
                                binOut <= std_logic_vector(counter);
                                load <= '0';
                            elsif ( counter < limit) then
                                counter := counter + 1;
                                binOut <= std_logic_vector(counter);
                                load <= '1';
                          end if;  
                        end if;
                     end if;
       end process countProc;

end Behavioral;
