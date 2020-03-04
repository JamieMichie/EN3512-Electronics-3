----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.03.2020 17:58:23
-- Design Name: 
-- Module Name: fullCircuit - Behavioral
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

entity fullCircuit is
    Port ( debug   : out std_logic_vector(15 downto 0); -- leds to show counting 
           clockIn : in STD_LOGIC;
           reset   : in std_logic;
           digiOut : out STD_LOGIC_VECTOR (6 downto 0) := "0000000";
           cs      : out STD_LOGIC_VECTOR (3 downto 0));
end fullCircuit;



architecture Behavioral of fullCircuit is

component counter16 
     Port ( 
           clk      : in std_logic;
           reset    : in std_logic;
           binOut   : out std_logic_vector(15 downto 0);
           load     : inout std_logic
           );
end component;

component dabv2
    Port ( dclk     : std_logic;
           binIn    : inout STD_LOGIC_VECTOR (15 downto 0);
           load     : inout STD_LOGIC := '0';
           reset    : in STD_LOGIC := '0';
           dabout   : out STD_LOGIC_VECTOR (15 downto 0);
           sync     : out std_logic
           );
end component;

component foursseg
    Port ( bcdIn    : in   STD_LOGIC_VECTOR (15 downto 0); -- 16-bit input 'number'
           segSel   : out  STD_LOGIC_VECTOR (3 downto 0); -- 4-bit common-anode output
           dout     : out  STD_LOGIC_VECTOR (6 downto 0); -- 7-bit 7 segment signals
           mclk     : in   STD_LOGIC; -- master clock
           sync     : in std_logic;
           loadLine : in std_logic);
end component;

component prescaler
    Port ( clk    : in STD_LOGIC  := '0';
           reset  : in STD_LOGIC  := '0';
           clkOut : out STD_LOGIC := '0');
end component;

-- instance of prescaler
   -- signal clkCon    : std_logic; --clock signal
    signal binNumber : std_logic_vector(15 downto 0) := "0000000000000000"; -- binOut Signal
    signal resetAll  : std_logic := '0'; -- reset signal for all blocks
    signal loadBin   : std_logic := '0'; -- signal to connect load between counter and dabble
    signal dabBCD    : STD_LOGIC_VECTOR (15 downto 0);
    signal dabSig    : std_logic_vector(15 downto 0); --- signal between dabv2 and foursseg
    signal binSig    : std_logic_vector(15 downto 0) := "0000000000000000"; --signal between binNumber and binIn
    signal syncLine  : std_logic;
    signal sevClk    : std_logic; -- Connect prescaler clock output to foursseg mclk
   
begin

count : counter16 port map (
                         clk    => clockIn,
                         binOut => binNumber,
                         reset  => reset,
                         load   => loadBin
                         );
dabble : dabv2 port map (
                        dclk   => clockIn,
                        binIn  => binSig,
                        load   => loadBin,
                        reset  => resetAll,
                        dabOut => dabBCD,
                        sync   => syncLine
                        );
seven : foursseg port map (
                        bcdIn  => dabSig,
                        segSel => cs,
                        dout   => digiOut,
                        mclk   => sevClk,
                        sync   => syncLine,
                        loadLine => loadBin
                        );
                        
 pre  : prescaler port map (
                        clk    => clockIn,
                        reset  => resetAll,
                        clkOut => sevClk);
 -- Connect signals to signals/inputs/outputs                           
binSig   <= binNumber;
resetAll <= reset;
dabSig   <= dabBCD;
debug    <= binNumber;
end Behavioral;
