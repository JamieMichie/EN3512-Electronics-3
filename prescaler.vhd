----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.02.2020 18:36:50
-- Design Name: 
-- Module Name: prescaler - Behavioral
-- Project Name: 
-- Target Devices: 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity prescaler is
    Port ( clk    : in STD_LOGIC  := '0';
           reset  : in STD_LOGIC  := '0';
           clkOut : out STD_LOGIC := '0');
end prescaler;

architecture Behavioral of prescaler is
signal prescaler  : std_logic_vector(24 downto 0) := "0000000000000000000000000";

begin

    clk_proc : process(clk, reset)
    variable preLimit : natural := 1048575; --8388607
    begin
        if (reset = '1') then
            prescaler <= (others => '0');
            elsif (rising_edge(clk)) then
                prescaler <= prescaler + 1;
                if(prescaler >= preLimit) then
                    clkOut <= '1';
                    prescaler <= "0000000000000000000000000";
                elsif (prescaler < 2) then
                    clkOut <= '0';
                end if;
            end if;
 end process;
 
end Behavioral;
