# LoRa-STM8S103

1.IDE       : ST Visual developer

2.Toolchain : Cosmic tools

3.Processor : STM8S103K3

4.LoRa module:SFM-1L

5.Function  : Master->Sned Message

              Slave->Receive Message-> Send Message back to Master
              
6.Payload   : 32bytes 
  
  0~6 ->EXOSITE 
  
  7~27->Chip ID
  
  28  ->Fan
  
  29  ->Humidity
  
  30  ->Tempeature
  
  31  ->Checksum

Note: SFM-1L module has 26MHz crystal on board, not 32MHz. RegFrf= 
  #
