----------------------------------------------------------------------------------
-- Company: RGU
-- Engineer: James Philp
-- 
-- Create Date:    11:01:58 10/08/2018 
-- Design Name: 
-- Module Name:    foursseg - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: Accepts a 16-bit bus, drives the 4 7-seg displays on Basys boards
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity foursseg is
    Port ( bcdIn  : in  STD_LOGIC_VECTOR (15 downto 0); -- 16-bit input 'number'
           segSel : out  STD_LOGIC_VECTOR (3 downto 0); -- 4-bit common-anode output
           dout   : out  STD_LOGIC_VECTOR (6 downto 0); -- 7-bit 7 segment signals
           mclk   : in  STD_LOGIC;
           sync   : in std_logic;   -- used to reset state machine when dabble complete.
           loadLine : in std_logic  --Used to synchronise s0 with start of bcd data. 
           ); 
end foursseg;

architecture Behavioral of foursseg is


component sseg is -- 4-bit binary to 7-segment decoder
 Port (    din : in  STD_LOGIC_VECTOR (3 downto 0); -- 4-bit binary number
           dout : out  STD_LOGIC_VECTOR (6 downto 0)); -- 7-bit 7 seg hex version
end component;

type state_type is (s0, s1, s2, s3);
signal current_s, next_s: state_type;
signal seg_dat : std_logic_vector (3 downto 0); -- signal to feed sseg lookup table


begin
decoder : sseg port map (seg_dat, dout); -- instanciate sseg lookup table

process(mclk) -- state machine
begin
if rising_edge(mclk) then
	current_s <= next_s; -- when the clock edge comes, change state
end if;
end process;

process (current_s, bcdIn)
begin
   -- if (loadLine = '1') then
    --    current_s <= s0;
    --end if;
	case current_s is		--When in state(n), do this
		when s0 =>
		segSel <= "1110"; --"0111"; -- for first sseg digit
		seg_dat <= bcdIn(3 downto 0); -- set seg dat to least significant nibble
		next_s <= s1; -- change to next digit
		
		when s1 =>
		segSel <= "1101"; -- for second sseg digit
		seg_dat <= bcdIn(7 downto 4);
		next_s <= s2;
		
		when s2 =>
		segSel <= "1011"; -- for third sseg digit
		seg_dat <= bcdIn(11 downto 8);
		next_s <= s3;
		
		when s3 =>
		segSel <= "0111"; -- for fourth sseg digit
		seg_dat <= bcdIn(15 downto 12);
		next_s <= s0;
		
	end case;
end process;

process(loadLine)
begin
   -- if (loadLine = '1') then
    --    next_s <= s0;
   -- end if;   
end process;

end Behavioral;

