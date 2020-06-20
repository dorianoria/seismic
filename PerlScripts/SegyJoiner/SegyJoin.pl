#Este script permite unir archivos segy.

#Lectura de las variables desde el archivo SegyJoinSettings.txt ubbicado en la carpeta donde
#se ejecuta este script
use File::stat;
#Cuerpo principal del programa
#####################LECTURA DE LOS SETTINGS##########################################
$FileSettings='SegyJoinSettings.txt';
$numeroLineasSettings=0;
$noFiles=0;
open (settings,$FileSettings);
$lineSettings=<settings>;
while ($lineSettings) {
  $numeroLineasSettings++;
  @arraySettings=split(' ',$lineSettings);
  if ($numeroLineasSettings==1) {
    $FinalFile=$arraySettings[1];         #byte to read Inline
  }
  if ($numeroLineasSettings>2) {
    @array=split(' ',$lineSettings);
    $arrayFiles[$noFiles]=$array[0];  #files to join
    $noFiles++;
  }
  $lineSettings=<settings>;
} #end while that reads SEGYJOINSETTINGS.TXT
close settings;
###########################FIN DE LECTURA DE LOS SETTINGS################################

###########################CAPTURA DE EBCDIC Y BINARY HEADER############################
open (IN,$arrayFiles[0]);
read (IN,$EBCDIC,3200);
if (read (IN,$BINARY,400)) {
  $sr=unpack("n",substr($BINARY,16,2));#lee el sample rate del binary header
  $sample=unpack("n",substr($BINARY,20,2));#lee el numero de muestras del binary header
  $code=unpack("n",substr($BINARY,24,2));#lee el formato del archivo (8,16 0 32 bits)
  $btr=4;                          #establece el numero de bytes por muestra (4:32 bits,2:16 bits,1:8 bits)
  if ($code==8){
    $btr=1;
  }
  if ($code==3){
    $btr=2;
  }
}
close IN;
$sizetrace=($sample*$btr)+240;  #size of the trace in bytes
###########################FIN DE CAPTURA DE EBCDIC Y BINARY HEADER############################
open (OUT,'>'.$FinalFile);      #open to write the SEG Y 2D for every inline
binmode(OUT);                 #establece que el archivo de salida se escribira como binario
###########################LECTURA DE LOS SEGY FILES A JUNTAR##################################
for ($i=0;$i<$noFiles;$i++) {
  open (IN2,$arrayFiles[$i]);              #open SEG Y 3D
  binmode(IN2);                  #establece que el archivo de entrada se leera como binario
  read (IN2,$EBCDIC1,3200);          #lee el EBCDIC y lo almacena en $buf para posterior escritura
  read (IN2,$BINARY1,400);
  if ($i==0) {
    syswrite OUT,$EBCDIC;            #escribe en el archivo de salida el EBCDIC del archivo de entrada
    syswrite OUT,$BINARY;          #escribe en la salida el binary header del archivo de entrada
  }
  while (read (IN2,$buf,$sizetrace)) {
    syswrite OUT,$buf,$sizetrace;
  }
  close IN2;
} #end del for
close OUT;
