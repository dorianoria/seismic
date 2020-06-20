SegyJoin.pl
============================================================================================================================

1. Description

This script was programmed in PERL and allows to join SEG Y files, it does not matter if the SEG Y files represent 2D or 3D
seismic information. In many cases, due to the size of SEG Y files, the seismic processing centers give the information
spread in several files, but the final client wants the information in a singe file. This script is to solve this. This 
script can be run under Windows, Linux and Solaris. 


2. How does this script work ?

It is not necessary to edit the script. To avoid this, all information necessary to run the script must be added to a file
called SegyJoinSettings.txt. An example of this file comes with the release of this script.

Open the file SegyJoinSettings.txt and edit it to adjust it to your needs. The name of the file must include the full path.
The first line indicates the name of the final file, after having joined the SEG Y files. The names of the files 
to be joined must be put from third line. The script is able to join any files.

The final SEG Y file will contain the EBCDIC of the first input file.


3. Restrictions

In order to manipulate SEG Y files with big sizes (more than 2 Gb), it is necessary to run the script under PERL 5.8.xxxxx.
