-- MACCHINA A STATI

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity project_reti_logiche is
    port (
       i_clk : in STD_LOGIC;
       i_rst : in STD_LOGIC;
       i_start : in STD_LOGIC;
       i_data : in STD_LOGIC_VECTOR (7 downto 0);
       o_address : out STD_LOGIC_VECTOR (15 downto 0);
       o_done : out STD_LOGIC;
       o_en : out STD_LOGIC;
       o_we : out STD_LOGIC;
       o_data : out STD_LOGIC_VECTOR (7 downto 0)
       );
end project_reti_logiche;

architecture Behavioral of project_reti_logiche is
component datapath is
    port(
        i_clk : in std_logic;
        i_rst : in std_logic;
        i_data : in std_logic_vector(7 downto 0);
        o_data : out std_logic_vector(7 downto 0);
        r1_load : in std_logic;
        res_load : in std_logic;
        state_load : in std_logic;
        to_count_load : in std_logic;
        counter_load : in std_logic;
        write_load : in std_logic;
        mux_sel_load : in std_logic;
        next_word_load : in std_logic;
        res_sel : in std_logic;
        state_sel : in std_logic;
        counter_sel : in std_logic;
        mux_sel_sel : in std_logic;
        o_addr_sel : in std_logic;
        o_sel : in std_logic;
        write_sel : in std_logic;
        next_word : out std_logic;
        next_address : out std_logic_vector(15 downto 0);
        o_end : out std_logic
    );
end component;

signal r1_load : STD_LOGIC;
signal res_load : STD_LOGIC;
signal state_load : STD_LOGIC;
signal to_count_load : STD_LOGIC;
signal counter_load : STD_LOGIC;
signal write_load : STD_LOGIC;
signal mux_sel_load : STD_LOGIC;
signal next_word_load : STD_LOGIC;
signal res_sel : STD_LOGIC;
signal state_sel : STD_LOGIC;
signal counter_sel : STD_LOGIC;
signal mux_sel_sel : STD_LOGIC;
signal o_addr_sel : STD_LOGIC;
signal o_sel : STD_LOGIC;
signal write_sel : std_logic;
signal next_word : std_logic;
signal next_address : std_logic_vector(15 downto 0);
signal o_end : STD_LOGIC;
type S is (S0,S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,S11,S12,S13);
signal cur_state, next_state : S;

begin
    DATAPATH0: datapath port map(
        i_clk,
        i_rst,
        i_data,
        o_data,
        r1_load,
        res_load,
        state_load,
        to_count_load,
        counter_load,
        write_load,
        mux_sel_load,    
        next_word_load, 
        res_sel,
        state_sel,
        counter_sel,
        mux_sel_sel,
        o_addr_sel,
        o_sel,
        write_sel,
        next_word,
        next_address,
        o_end
    );
    
    process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            cur_state <= S0;
        elsif rising_edge(i_clk) then
            cur_state <= next_state;
        end if;
    end process;
    
    process(cur_state, i_start, o_end, next_word)
    begin
        next_state <= cur_state;
        case cur_state is
            when S0 =>
                if i_start = '1' then
                    next_state <= S1;
                end if;
            when S1 =>
                next_state <= S2;
            when S2 =>
                next_state <= S13;
                    
            when S3 =>
                    next_state <= S4;
            when S4 =>
                next_state <= S5;
            when S5 =>
                next_state <= S6;
            when S6 =>
                next_state <= S11;
            when S7 =>
                next_state <= S12;
            when S8 =>
                next_state <= S9;
            when S9 =>
                if o_end = '1' then
                    next_state <= S10;
                else
                    next_state <= S3;
                end if;
           when S10 =>
                if i_start = '0' then
                    next_state <= S0;
                end if;
           when S11 =>   
                if next_word = '1' then
                    next_state <= S7;
                else
                    next_state <= S5;
                end if;  
           when S12 =>
                next_state <= S8;   
           when S13 =>
                if o_end = '1' then
                    next_state <= S10;
                else
                    next_state <= S3;
                end if;
        end case;
    end process;
    
    process(cur_state,next_address)
    begin
        r1_load <= '0';
        res_load <= '0';
        state_load <= '0';
        to_count_load <= '0';
        counter_load <= '0';
        write_load <= '0';
        mux_sel_load <= '0';   
        next_word_load <= '0'; 
        res_sel <= '0';
        state_sel <= '0';
        write_sel <= '1';
        counter_sel <= '0';
        mux_sel_sel <= '0';
        o_addr_sel <= '0';
        o_sel <= '0';
        o_done <= '0';
        o_address <= "0000000000000000";
        o_en <= '0';
        o_we <= '0';
    
        case cur_state is
            when S0 =>
                o_done <= '0';
            when S1 =>
                o_en <= '1';
                res_load <= '1';
                counter_load <= '1';
                state_load <= '1';
                write_sel <= '0';
                write_load <= '1';
            when S2 =>
                to_count_load <= '1';
            when S3 =>
                o_en <= '1';
                o_address <= next_address;
            when S4 =>
                r1_load <= '1';
            when S5 =>
                res_load <= '1';
                res_sel <= '1';
            when S6 =>
                state_load <= '1';
                state_sel <= '1';
                mux_sel_load <= '1';
                mux_sel_sel <= '1';

             when S7 =>
                o_addr_sel <= '1';
                o_en <= '1';
                o_we <= '1';
                o_address <= next_address;
                
             when S8 =>
                o_addr_sel <= '1';
                o_en <= '1';
                o_we <= '1';
                o_sel <= '1';
                o_address <= next_address;
                counter_load <= '1';
                counter_sel <= '1';
             when S9 =>
                --o_we <= '0';
                write_load <= '1';
             when S10 =>
                o_done <= '1';  
             when S11 => 
                next_word_load <= '1';
             when S12 => 
                write_load <= '1';
             when S13 =>
                mux_sel_load <= '1';        
        end case;
    end process;
    
end Behavioral;


-- DATAPATH

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_unsigned.ALL;

entity datapath is
    port(
        i_clk : in std_logic;
        i_rst : in std_logic;
        i_data : in std_logic_vector(7 downto 0);
        o_data : out std_logic_vector(7 downto 0);
        r1_load : in std_logic;
        res_load : in std_logic;
        state_load : in std_logic;
        to_count_load : in std_logic;
        counter_load : in std_logic;
        write_load : in std_logic;
        mux_sel_load : in std_logic;
        next_word_load : in std_logic;
        res_sel : in std_logic;
        state_sel : in std_logic;
        counter_sel : in std_logic;
        mux_sel_sel : in std_logic;
        o_addr_sel : in std_logic;
        o_sel : in std_logic;
        write_sel : in std_logic;
        next_word : out std_logic;
        next_address : out std_logic_vector(15 downto 0);
        o_end : out std_logic

    );
end datapath;

architecture Behavioral of datapath is
signal o_reg1 : std_logic_vector(7 downto 0); 
signal o_mux_pk : std_logic; 
signal pk1 : std_logic;
signal pk2 : std_logic;
signal o_result : std_logic_vector(15 downto 0);
signal o_result_shift1: std_logic_vector(15 downto 0);
signal o_result_shift2: std_logic_vector(15 downto 0);
signal o_result_pk1 : std_logic_vector(15 downto 0);
signal o_result_pk2 : std_logic_vector(15 downto 0);
signal mux_sel : std_logic_vector(2 downto 0);
signal mux_sel_sum : std_logic_vector(2 downto 0);
signal mux_sel_next : std_logic_vector(2 downto 0);
signal mux_res : std_logic_vector(15 downto 0);
signal sub : std_logic_vector(2 downto 0);
signal o_state : std_logic_vector(7 downto 0);
signal o_state_shift : std_logic_vector(7 downto 0);
signal new_state : std_logic_vector(7 downto 0);
signal mux_state : std_logic_vector(7 downto 0);

signal o_to_count : std_logic_vector(7 downto 0);
signal o_counter : std_logic_vector(7 downto 0);
signal next_counter : std_logic_vector(7 downto 0);
signal mux_counter : std_logic_vector(7 downto 0);

signal o_read : std_logic_vector(15 downto 0);
signal o_write : std_logic_vector(15 downto 0);
signal next_write : std_logic_vector(15 downto 0);
signal next_write_next : std_logic_vector(15 downto 0);

signal next_word_check : std_logic_vector(2 downto 0);
signal o_end_check : std_logic_vector(7 downto 0);
begin
-- registro 1
	process(i_clk,i_rst)
	begin
		if(i_rst = '1') then
			o_reg1 <= "00000000";
		elsif rising_edge(i_clk) then
			if(r1_load = '1') then
				o_reg1 <= i_data;
			end if;
		end if;
	end process;

-- mux bit
	with mux_sel select
		o_mux_pk <= o_reg1(7) when "000" ,
		          o_reg1(6) when "001" ,
		          o_reg1(5) when "010" ,
		          o_reg1(4) when "011" ,
		          o_reg1(3) when "100" ,
		          o_reg1(2) when "101" ,
		          o_reg1(1) when "110" ,
		          o_reg1(0) when "111" ,
		          'X' when others;
	
-- mux pk1 
    with o_state(1) select
        pk1 <= o_mux_pk when '0',
               not o_mux_pk when '1',
               'X' when others;      

-- mux pk2
    with o_state(0) select
        pk2 <= pk1 when '0',
               not pk1 when '1',
               'X' when others;	     
				    
-- registro risultato
	process(i_clk,i_rst)
	begin
		if(i_rst = '1') then
			o_result <= "0000000000000000";
		elsif rising_edge(i_clk) then
			if(res_load = '1') then
				o_result <= mux_res;
			end if;
		end if;
	end process;
	
-- shift left 1 
    o_result_shift1(15 downto 0) <= o_result(14 downto 0) & '0';

-- somma con pk1   
    o_result_pk1 <= o_result_shift1 + ("00000000" & pk1) ;

-- shift left 2
    o_result_shift2(15 downto 0) <= o_result_pk1(14 downto 0) & '0';

-- somma con pk2   
    o_result_pk2 <= o_result_shift2 + ("00000000" & pk2) ;	
    
-- mux res  
    with res_sel select
        mux_res <= "0000000000000000" when '0',
                  o_result_pk2 when '1',
                  "XXXXXXXXXXXXXXXX" when others;
    
-- mux output 
    with o_sel select
        o_data <= o_result(7 downto 0) when '1',
                  o_result(15 downto 8) when '0',
                  "XXXXXXXX" when others;
                  
-- registro stato 
    process(i_clk,i_rst)
	begin
		if(i_rst = '1') then
			o_state <= "00000000";
		elsif rising_edge(i_clk) then
			if(state_load = '1') then
				o_state <= mux_state;
			end if;
		end if;
	end process;
	
-- shift stato
    o_state_shift(7 downto 0) <= o_state(6 downto 0) & '0';
    
-- somma ultimo bit letto
    new_state <= o_state_shift + o_mux_pk;

-- mux stato 
    with state_sel select
        mux_state <= "00000000" when '0',
                  new_state when '1',
                  "XXXXXXXX" when others;
                  
-- registro parole da contare
    process(i_clk,i_rst)
	begin
		if(i_rst = '1') then
			o_to_count <= "00000000";
		elsif rising_edge(i_clk) then
			if(to_count_load = '1') then
				o_to_count <= i_data;
			end if;
		end if;
	end process;
               
-- registro parole contate	
    process(i_clk,i_rst)
	begin
		if(i_rst = '1') then
			o_counter <= "00000000";
		elsif rising_edge(i_clk) then
			if(counter_load = '1') then
				o_counter <= mux_counter;
			end if;
		end if;
	end process;

-- prossima parola contata  
    next_counter <= o_counter + '1';
    
-- mux counter
	with counter_sel select
        mux_counter  <= "00000000" when '0',
                      next_counter when '1',
                      "XXXXXXXX" when others;
                      
-- registro scrittura
    process(i_clk,i_rst)
	begin
		if(i_rst = '1') then
			o_write <= "0000001111101000";
		elsif rising_edge(i_clk) then
			if(write_load = '1') then
				o_write <= next_write;
			end if;
		end if;
	end process;
	
-- mux scrittura 
    with write_sel select
        next_write <= "0000001111101000" when '0',
                   next_write_next when '1',
                  "XXXXXXXXXXXXXXXX" when others;

-- indirizzo di lettura e scrittura
    o_read <= "0000000000000001" + ("00000000" & o_counter);
    next_write_next <= o_write + "0000000000000001";
-- mux indirizzo
	with o_addr_sel select
        next_address  <= o_read when '0',
                      o_write when '1',
                      "XXXXXXXXXXXXXXXX" when others;
                      
-- segnale selettore del mux 
--registro
    process(i_clk,i_rst)
        begin
            if(i_rst = '1') then
                mux_sel <= "000";
            elsif rising_edge(i_clk) then
                if(mux_sel_load = '1') then
                    mux_sel <= mux_sel_next;
                end if;
            end if;
        end process;
        
-- somma
   mux_sel_sum <= mux_sel + "001";
        
-- mux selezionatore 
    with mux_sel_sel select
        mux_sel_next  <= "000" when '0',
                      mux_sel_sum when '1',
                      "XXX" when others;

-- check next word
    --registro
    process(i_clk,i_rst)
        begin
            if(i_rst = '1') then
                next_word_check <= "111";
            elsif rising_edge(i_clk) then
                if(next_word_load = '1') then
                    next_word_check <= sub;
                end if;
            end if;
        end process;   
         
    sub <= "111" - mux_sel;
    next_word <= '1' when (next_word_check = "000") else '0';               

-- comparatore finale
    o_end_check <= o_to_count - o_counter;
    o_end <= '1' when o_end_check = "00000000" else '0';                

end Behavioral;