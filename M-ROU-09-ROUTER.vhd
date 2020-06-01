
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


subtype flag1bit is std_logic;
subtype data8bit is std_logic_vector(7 downto 0);

type array4x8 is array(1 to 4) of data8bit;

type array4x1 is array(1 to 4) of flag1bit;

signal deciderFlag: array4x1;
signal DeMuxToFIFO1,DeMuxToFIFO2,DeMuxToFIFO3,DeMuxToFIFO4,FIFOtoSch1,FIFOtoSch2,FIFOtoSch3,FIFOtoSch4,output: array4x8;
signal EmptyFifo1,EmptyFifo2,EmptyFifo3,EmptyFifo4,FullFifo1,FullFifo2,FullFifo3,FullFifo4,fifo_wreq1,fifo_wreq2,fifo_wreq3,fifo_wreq4: array4x1;
signal IBtoDeMux:array4x8;




--signal scToOB1,scToOB2, scToOB3, scToOB4:  std_logic_vector(7 downto 0);


type data_io is array (1 to 4) of std_logic_vector(7 downto 0);
type packettype is array (1 to 4) of std_logic;
type flagType is array (1 to 4) of std_logic;
signal dataos1,dataos2,dataos3,dataos4: std_logic_Vector(7 downto 0 );

signal dataos: data_io := (dataos1,dataos2,dataos3,dataos4);
 
signal wr: packettype;
signal datai: data_io;
--variable count : integer := 0;
BEGIN
wr <= (wr1,wr2,wr3,wr4);

datai <= (datai1,datai2,datai3,datai4);

GEN_out: for I in 1 to 4 generate

FOR ALL: DeMux USE ENTITY WORK.Modulee2 (Behavv2);
FOR ALL: IOBuffer USE ENTITY WORK.Module1 (behav1);

FOR ALL: fifo_8 USE ENTITY WORK.fifo (behavioral);

FOR ALL: scheduler USE ENTITY WORK.M_ROU_08 (ARCH_M_ROU_08);
FOR ALL: decider USE ENTITY WORK.decider (behaveofdecider);

fifo_wreq1(I) <='1' when (wr1= '1' and  IBtoDeMux(I)(1 downto 0) = "00") 
else '0';
fifo_wreq2(I) <='1' when (wr2= '1' and  IBtoDeMux(I)(1 downto 0) = "01") 
else '0';
fifo_wreq3(I) <='1' when (wr3= '1' and  IBtoDeMux(I)(1 downto 0) = "10") 
else '0';
fifo_wreq4(I) <='1' when (wr4= '1' and  IBtoDeMux(I)(1 downto 0) = "11") 
else '0';

 
ib : IOBuffer PORT MAP(Datat_in =>datai(I), Data_Out =>IBtoDeMux(I), clk =>wclock, Clock_En =>wr(I), Reset =>rst); 
    
    
    dm: DeMux PORT MAP(d_in =>IBtoDeMux(I), d_out1 =>DeMuxToFIFO1(I) , d_out2 =>DeMuxToFIFO2(I) , d_out3=>DeMuxToFIFO3(I), d_out4 =>DeMuxToFIFO4(I), SEL=>IBtoDeMux(I)(1 downto 0), En=> wr(I) );
    	 
		--and selected by sch 
		fifo1 :fifo_8 PORT MAP(rreq=>deciderFlag(I) ,wreq=> fifo_wreq1(I) ,empty=>EmptyFifo1(I), full=>FullFifo1(I), reset => rst, rclk =>rclock, wclk=>wclock,datain=> DeMuxToFIFO1(I)  , dataout=>FIFOtoSch1(I));
		
fifo2 :fifo_8 PORT MAP(rreq=>deciderFlag(I) ,wreq=>fifo_wreq2(I), empty=>EmptyFifo2(I), full=>FullFifo2(I), reset => rst, rclk =>rclock, wclk=>wclock,datain=> DeMuxToFIFO2(I)  , dataout=>FIFOtoSch2(I));
fifo3 :fifo_8 PORT MAP(rreq=>deciderFlag(I) ,wreq=>fifo_wreq3(I), empty=>EmptyFifo3(I), full=>FullFifo3(I), reset => rst, rclk =>rclock, wclk=>wclock,datain=> DeMuxToFIFO3(I)  , dataout=>FIFOtoSch3(I));
fifo4 :fifo_8 PORT MAP(rreq=>deciderFlag(I) ,wreq=>fifo_wreq4(I), empty=>EmptyFifo4(I), full=>FullFifo4(I), reset => rst, rclk =>rclock, wclk=>wclock,datain=> DeMuxToFIFO4(I)  , dataout=>FIFOtoSch4(I));
		
    sch :scheduler PORT MAP(clock =>rclock, din1=> FIFOtoSch1(I), din2=> FIFOtoSch2(I), din3=>FIFOtoSch3(I), din4=>FIFOtoSch4(I), dout=>output(I) );
    dec :decider PORT MAP(clock=>rclock, Eflag1=>EmptyFifo1(I),Eflag2=>EmptyFifo2(I),Eflag3=>EmptyFifo3(I),Eflag4=>EmptyFifo4(I), outFlag =>deciderFlag(I) );
    

end generate GEN_out;



end ARCHITECTURE ROUTER ;
