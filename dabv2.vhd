----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.02.2020 18:40:21
-- Design Name: 
-- Module Name: dabv2 - Behavioral
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
use IEEE.numeric_std.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dabv2 is
Port (     dclk     : std_logic;
           binIn    : in STD_LOGIC_VECTOR (15 downto 0);
           load     : in STD_LOGIC;
           reset    : in STD_LOGIC;
           dabout   : out STD_LOGIC_VECTOR (15 downto 0) := "0000000000000000";
           sync     : out std_logic --sync up the output to the input of the seven segment decoder
           );
  
end dabv2;

architecture Behavioral of dabv2 is
    type state_type is (LOADDATA, SHIFT, TEST, BCDCOMP, START); -- STATES FOR FSM
    signal PS : state_type;                          --STATE SIGNAL
    signal shiftCount : integer := 0;                   -- used to track the number of shifts carried out
begin

load_proc : process(dclk)
                variable tempData : unsigned(15 downto 0); --Storing binary in value from counter
                variable newData  : unsigned(15 downto 0) := "0000000000000000"; --New dabble value
                variable unitD    : unsigned(3 downto 0);
                variable tensD    : unsigned(3 downto 0);
                variable hunsD    : unsigned(3 downto 0);
                variable thouD    : unsigned(3 downto 0);
                constant SHIFTMAX : natural := 16;
            begin
            if (rising_edge(dclk)) then    
                case PS is
                
                    when START => --reset
                        shiftCount <= 0;
                        tempData := "0000000000000000";
                        newData  := "0000000000000000";
                       -- dabOut   <= "0000000000000000";
                        PS       <= LOADDATA;
                        
                    when LOADDATA =>
                        if (load = '1') then --load = '1'
                            tempData := unsigned(binIn); 
                            sync <= '0';
                            PS <= SHIFT;
                        elsif (load = '0') then
                            tempData := "0000000000000000";
                            shiftCount <= 0;
                            PS <= LOADDATA; -- loop until data is ready to load
                        end if;
                    
                    when SHIFT =>
                        if( shiftCount < SHIFTMAX) then -- Test against tempData "0000000000000000" means shifting complete bcdCOMP
                            
                            --Move all the bits left one
                            newData(15) := newData(14);
                            newData(14) := newData(13);
                            newData(13) := newData(12);
                            newData(12) := newData(11);
                            newData(11) := newData(10);
                            newData(10) := newData(9);
                            newData(9) := newData(8);
                            newData(8) := newData(7);
                            newData(7) := newData(6);
                            newData(6) := newData(5);
                            newData(5) := newData(4);
                            newData(4) := newData(3);
                            newData(3) := newData(2);
                            newData(2) := newData(1);
                            newData(1) := newData(0);
                            newData(0) := tempData(15); -- take the msb from the reg and make it lsb of newData
                            -- Move along all the binary register bits left 1. Pad 0s in at the lsb
                            -- When tempData is all 0s then the bcd should be complete
                            tempData(15) := tempData(14);
                            tempData(14) := tempData(13);
                            tempData(13) := tempData(12);
                            tempData(12) := tempData(11);
                            tempData(11) := tempData(10);
                            tempData(10) := tempData(9);
                            tempData(9)  := tempData(8);
                            tempData(8)  := tempData(7);
                            tempData(7)  := tempData(6);
                            tempData(6)  := tempData(5);
                            tempData(5)  := tempData(4);
                            tempData(4)  := tempData(3);
                            tempData(3)  := tempData(2);
                            tempData(2)  := tempData(1);
                            tempData(1)  := tempData(0);
                            tempData(0) := '0';
                            
                            if (shiftCount = SHIFTMAX) then
                                PS <= BCDCOMP; -- finished
                            end if;
                            if (shiftCount < SHIFTMAX) THEN
                            shiftCount <= shiftCount + 1;
                            PS <= TEST;
                            end if;
                        elsif (shiftCount = SHIFTMAX) then                       
                            PS <= BCDCOMP;                     
                        end if;
                        
                     when TEST =>
                        if (shiftCount = SHIFTMAX) then
                            PS <= BCDCOMP;
                        elsif (shiftCount < SHIFTMAX) then
                        ----------- test each nibble --------------
                        ---------  UNITS  --------------------------------
                        unitD := newData(3 downto 0);
                        if (unitD > 4) then
                                newData := newData + "0000000000000011";
                         end if;
                        -------- Tens -----------------------------
                        tensD := newData(7 downto 4);
                        if (tensD > 4) then
                            newData:= newData + "0000000000110000";
                        end if;
                        ------- Hundreds --------------------------
                        hunsD := newData(11 downto 8);
                        if (hunsD > 4) then
                            newData := newData + "0000001100000000";
                        end if;
                        ---thousands------------------------------
                        thouD := newData(15 downto 12);
                        if (thouD > 4) then
                        newData := newData + "0011000000000000";
                        end if;
                        -------------------------------------------
                        
                        PS <= SHIFT;
                        end if;

                      when BCDCOMP =>
                          dabOut <= std_logic_vector(newData);
                          sync <= '1';
                          PS <= START;
                  end case;
              end if;
end process;
end Behavioral;
