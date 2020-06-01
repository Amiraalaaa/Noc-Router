
Library ieee;
USE ieee.std_logic_1164.ALL;
ENTITY M9 is
	port(	wclock, rclock, rst: IN std_logic;
		datai1,datai2, datai3, datai4: IN std_logic_vector ( 7 DOWNTO 0);
		wr1, wr2, wr3, wr4: IN std_logic;
		datao1,datao2, datao3, datao4: OUT std_logic_vector ( 7 DOWNTO 0));

end M9;


ARCHITECTURE ROUTER of M9 is
COMPONENT IOBuffer IS
port (
      Datat_in : in std_logic_vector(7 downto 0);
      Data_out : out std_logic_vector(7 downto 0);
      clk : in std_logic;
      Clock_En : in std_logic ;
      Reset : in std_logic
      );
END COMPONENT ;

COMPONENT DeMux IS
port (
       d_in : in std_logic_vector(7 downto 0);
       d_out1 : out std_logic_vector(7 downto 0);
       d_out2 : out std_logic_vector(7 downto 0);
       d_out3 : out std_logic_vector(7 downto 0);
       d_out4 : out std_logic_vector(7 downto 0);
       SEL : in std_logic_vector(1 downto 0);
       En : in std_logic
      );

END COMPONENT ;

COMPONENT fifo_8 IS
PORT( 	reset, rclk, wclk, rreq, wreq: IN std_logic;
	datain:in std_logic_vector(7 downto 0);
	dataout:out std_logic_vector(7 downto 0);
	empty,full: OUT std_logic  );


END COMPONENT ;

COMPONENT scheduler IS
	port(clock: in std_logic;
	     din1: in std_logic_vector(7 downto 0);
	     din2: in std_logic_vector(7 downto 0);
	     din3: in std_logic_vector(7 downto 0);
	     din4: in std_logic_vector(7 downto 0);
	     dout: out std_logic_vector(7 downto 0)
	     --SelectedPort: out std_logic_vector(1 downto 0)
);
END COMPONENT ;

COMPONENT decider IS
port (	     clock: in std_logic;
	     Eflag1,Eflag2,Eflag3,Eflag4: in std_logic;
	     outFlag: out std_logic
      );

END COMPONENT ;



signal IBtoDeMux1,IBtoDeMux2,IBtoDeMux3,IBtoDeMux4:  std_logic_vector(7 downto 0);
signal deciderFlag1,deciderFlag2,deciderFlag3,deciderFlag4:  std_logic;

signal DeMuxToFIFO11,DeMuxToFIFO12,DeMuxToFIFO13,DeMuxToFIFO14:  std_logic_vector(7 downto 0);
signal DeMuxToFIFO21,DeMuxToFIFO22,DeMuxToFIFO23,DeMuxToFIFO24:  std_logic_vector(7 downto 0);
signal DeMuxToFIFO31,DeMuxToFIFO32,DeMuxToFIFO33,DeMuxToFIFO34:  std_logic_vector(7 downto 0);
signal DeMuxToFIFO41,DeMuxToFIFO42,DeMuxToFIFO43,DeMuxToFIFO44:  std_logic_vector(7 downto 0);


signal EmptyFifo11,EmptyFifo12,EmptyFifo13,EmptyFifo14:  std_logic;
signal EmptyFifo21,EmptyFifo22,EmptyFifo23,EmptyFifo24:  std_logic;
signal EmptyFifo31,EmptyFifo32,EmptyFifo33,EmptyFifo34:  std_logic;
signal EmptyFifo41,EmptyFifo42,EmptyFifo43,EmptyFifo44:  std_logic;

signal FullFifo11,FullFifo12,FullFifo13,FullFifo14:  std_logic;
signal FullFifo21,FullFifo22,FullFifo23,FullFifo24:  std_logic;
signal FullFifo31,FullFifo32,FullFifo33,FullFifo34:  std_logic;
signal FullFifo41,FullFifo42,FullFifo43,FullFifo44:  std_logic;


signal fifo_wreq11,fifo_wreq12,fifo_wreq13,fifo_wreq14: std_logic;
signal fifo_wreq21,fifo_wreq22,fifo_wreq23,fifo_wreq24: std_logic;
signal fifo_wreq31,fifo_wreq32,fifo_wreq33,fifo_wreq34: std_logic;
signal fifo_wreq41,fifo_wreq42,fifo_wreq43,fifo_wreq44: std_logic;


signal FIFOtoSch11, FIFOtoSch12, FIFOtoSch13, FIFOtoSch14 : std_logic_vector(7 downto 0);
signal FIFOtoSch21, FIFOtoSch22, FIFOtoSch23, FIFOtoSch24 : std_logic_vector(7 downto 0);
signal FIFOtoSch31, FIFOtoSch32, FIFOtoSch33, FIFOtoSch34 : std_logic_vector(7 downto 0);
signal FIFOtoSch41, FIFOtoSch42, FIFOtoSch43, FIFOtoSch44 : std_logic_vector(7 downto 0);


signal scToOB1,scToOB2, scToOB3, scToOB4:  std_logic_vector(7 downto 0);


type data_io is array (1 to 4) of std_logic_vector(7 downto 0);
type packettype is array (1 to 4) of std_logic;
type flagType is array (1 to 4) of std_logic;
signal dataos1,dataos2,dataos3,dataos4: std_logic_Vector(7 downto 0 );

signal dataos: data_io := (dataos1,dataos2,dataos3,dataos4);
signal IBtoDeMux: data_io := (IBtoDeMux1,IBtoDeMux2,IBtoDeMux3,IBtoDeMux4);
signal scToOB: data_io := (scToOB1,scToOB2,scToOB3,scToOB4);
--signal wr: packettype := (wr1,wr2,wr3,wr4);

signal deciderFlag: flagType := (deciderFlag1,deciderFlag2,deciderFlag3,deciderFlag4);

signal EmptyFifo1: flagType := (EmptyFifo11,EmptyFifo12,EmptyFifo13,EmptyFifo14);
signal EmptyFifo2: flagType := (EmptyFifo21,EmptyFifo22,EmptyFifo23,EmptyFifo24);
signal EmptyFifo3: flagType := (EmptyFifo31,EmptyFifo32,EmptyFifo33,EmptyFifo34);
signal EmptyFifo4: flagType := (EmptyFifo41,EmptyFifo42,EmptyFifo43,EmptyFifo44);


signal FullFifo1: flagType := (FullFifo11,FullFifo12,FullFifo13,FullFifo14);
signal FullFifo2: flagType := (FullFifo21,FullFifo22,FullFifo23,FullFifo24);
signal FullFifo3: flagType := (FullFifo31,FullFifo32,FullFifo33,FullFifo34);
signal FullFifo4: flagType := (FullFifo41,FullFifo42,FullFifo43,FullFifo44);


signal fifo_wreq1: flagType := (fifo_wreq11,fifo_wreq12,fifo_wreq13,fifo_wreq14);
signal fifo_wreq2: flagType := (fifo_wreq21,fifo_wreq22,fifo_wreq23,fifo_wreq24);
signal fifo_wreq3: flagType := (fifo_wreq31,fifo_wreq32,fifo_wreq33,fifo_wreq34);
signal fifo_wreq4: flagType := (fifo_wreq41,fifo_wreq42,fifo_wreq43,fifo_wreq44);


signal DeMuxToFIFO1 : data_io := (DeMuxToFIFO11,DeMuxToFIFO12,DeMuxToFIFO13,DeMuxToFIFO14);
signal DeMuxToFIFO2 : data_io := (DeMuxToFIFO21,DeMuxToFIFO22,DeMuxToFIFO23,DeMuxToFIFO24);
signal DeMuxToFIFO3 : data_io := (DeMuxToFIFO31,DeMuxToFIFO32,DeMuxToFIFO33,DeMuxToFIFO34);
signal DeMuxToFIFO4 : data_io := (DeMuxToFIFO41,DeMuxToFIFO42,DeMuxToFIFO43,DeMuxToFIFO44);


signal FIFOtoSch1 : data_io := (FIFOtoSch11,FIFOtoSch21,FIFOtoSch31,FIFOtoSch41);
signal FIFOtoSch2 : data_io := (FIFOtoSch12,FIFOtoSch22,FIFOtoSch32,FIFOtoSch42);
signal FIFOtoSch3 : data_io := (FIFOtoSch13,FIFOtoSch23,FIFOtoSch33,FIFOtoSch43);
signal FIFOtoSch4 : data_io := (FIFOtoSch14,FIFOtoSch24,FIFOtoSch34,FIFOtoSch44);


--signal datai: data_io := (datai1,datai2,datai3,datai4);
signal wr: packettype;
signal datai: data_io;
--signal wr: packettype := (wr1,wr2,wr3,wr4);
BEGIN
wr <= (wr1,wr2,wr3,wr4);

datai <= (datai1,datai2,datai3,datai4);
--ib1 : IOBuffer PORT MAP(Datat_in =>datai1, Data_Out =>IBtoDeMux1, clk =>wclock, Clock_En =>wr1, Reset =>rst); --5/5 --done
---ib2 : IOBuffer PORT MAP(Datat_in =>datai2, Data_Out =>IBtoDeMux2, clk =>wclock, Clock_En =>wr2, Reset =>rst); --5/5 --done
--ib3 : IOBuffer PORT MAP(Datat_in =>datai3, Data_Out =>IBtoDeMux3, clk =>wclock, Clock_En =>wr3, Reset =>rst); --5/5 --done
--ib4 : IOBuffer PORT MAP(Datat_in =>datai4, Data_Out =>IBtoDeMux4, clk =>wclock, Clock_En =>wr4, Reset =>rst); --5/5 --done
GEN_out: for I in 1 to 4 generate
FOR ALL: DeMux USE ENTITY WORK.Modulee2 (Behavv2);
FOR ALL: IOBuffer USE ENTITY WORK.Module1 (behav1);

FOR ALL: fifo_8 USE ENTITY WORK.fifo (behavioral);

FOR ALL: scheduler USE ENTITY WORK.M_ROU_08 (ARCH_M_ROU_08);
FOR ALL: decider USE ENTITY WORK.decider (behaveofdecider);
ib : IOBuffer PORT MAP(Datat_in =>datai(I), Data_Out =>IBtoDeMux(I), clk =>wclock, Clock_En =>wr(I), Reset =>rst); 
    
    
    dm: DeMux PORT MAP(d_in =>IBtoDeMux(I), d_out1 =>DeMuxToFIFO1(I) , d_out2 =>DeMuxToFIFO2(I) , d_out3=>DeMuxToFIFO3(I), d_out4 =>DeMuxToFIFO4(I), SEL=>IBtoDeMux(I)(1 downto 0), En=> wr(I) );
    	 
		--and selected by sch 
		fifo1 :fifo_8 PORT MAP(rreq=>deciderFlag(I) ,wreq=> fifo_wreq1(I) ,empty=>EmptyFifo1(I), full=>FullFifo1(I), reset => rst, rclk =>rclock, wclk=>wclock,datain=> DeMuxToFIFO1(I)  , dataout=>FIFOtoSch1(I));
		
fifo2 :fifo_8 PORT MAP(rreq=>deciderFlag(I) ,wreq=>fifo_wreq2(I), empty=>EmptyFifo2(I), full=>FullFifo2(I), reset => rst, rclk =>rclock, wclk=>wclock,datain=> DeMuxToFIFO2(I)  , dataout=>FIFOtoSch2(I));
fifo3 :fifo_8 PORT MAP(rreq=>deciderFlag(I) ,wreq=>fifo_wreq3(I), empty=>EmptyFifo3(I), full=>FullFifo3(I), reset => rst, rclk =>rclock, wclk=>wclock,datain=> DeMuxToFIFO3(I)  , dataout=>FIFOtoSch3(I));
fifo4 :fifo_8 PORT MAP(rreq=>deciderFlag(I) ,wreq=>fifo_wreq4(I), empty=>EmptyFifo4(I), full=>FullFifo4(I), reset => rst, rclk =>rclock, wclk=>wclock,datain=> DeMuxToFIFO4(I)  , dataout=>FIFOtoSch4(I));
		
    sch :scheduler PORT MAP(clock =>rclock, din1=> FIFOtoSch1(I), din2=> FIFOtoSch2(I), din3=>FIFOtoSch3(I), din4=>FIFOtoSch4(I), dout=>scToOB(I) );
    dec :decider PORT MAP(clock=>rclock, Eflag1=>EmptyFifo1(I),Eflag2=>EmptyFifo2(I),Eflag3=>EmptyFifo3(I),Eflag4=>EmptyFifo4(I), outFlag =>deciderFlag(I) );
    

	ib2 : IOBuffer PORT MAP(Datat_in =>scToOB(I), Data_Out =>dataos(I), clk=>rclock, Reset => rst, Clock_En =>deciderFlag(I));--4/5

fifo_wreq1(I) <='1' when (wr1= '1' and  IBtoDeMux(I)(1 downto 0) = "00") 
else '0';
fifo_wreq2(I) <='1' when (wr2= '1' and  IBtoDeMux(I)(1 downto 0) = "01") 
else '0';
fifo_wreq3(I) <='1' when (wr3= '1' and  IBtoDeMux(I)(1 downto 0) = "10") 
else '0';
fifo_wreq4(I) <='1' when (wr4= '1' and  IBtoDeMux(I)(1 downto 0) = "11") 
else '0';

end generate GEN_out;



end ARCHITECTURE ROUTER ;
