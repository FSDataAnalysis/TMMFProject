### Code by S Santos March - 2015 
### Convert list of Igor Files in Folder into txt files for AFM

### INSTRUCTIONS 

### CHOOSE NAME SUBFOLDER (where Igor FILES are kept)
sub_folder_name<-"FILES"   
### This is where txt files will be added
unlink("./TXT", recursive = TRUE)

##### 
mainDir <- getwd()
subDir <- "TXT"

if (file.exists(subDir)){
  unlink("./TXT", recursive = TRUE)
} else {
  dir.create(file.path(mainDir, subDir))  
}

##########################3

sub_folder_tab<-"./"

sub_folder_path<-paste(sub_folder_tab,sub_folder_name, collapse =' ')

sub_folder_path<-gsub(" ","", sub_folder_path) 


### INSTALL the PACKAGE TO READ IGOR FILES IN MATRIX FORM

if("IgorR" %in% rownames(installed.packages()) == FALSE) {install.packages("IgorR")};
library(IgorR)

### LIST THE FILES IN DIRECTORY 'FILES' INSIDE CURRENT DIRECTORY
names_files<-list.files(path = sub_folder_path, pattern = NULL, all.files = FALSE,
                        full.names = FALSE, recursive = FALSE,
                        ignore.case = FALSE, include.dirs = FALSE, no.. = FALSE)

#for (iii in 1:length(names_files)) {

counter<-1;

iii<-1;

while (iii<length(names_files)+1) {
  
  dumb_name_file<-names_files[iii] 
  dumb_file_path<-paste(sub_folder_path,"/", dumb_name_file, collapse =' ')
  dumb_file_path_2<-gsub(" ","", dumb_file_path)
  
  file_dumb<-read.ibw(dumb_file_path_2, Verbose = FALSE, ReturnTimeSeries = FALSE,
           MakeWave = FALSE, HeaderOnly = FALSE)
  
  name_txt_file_dumb_1<-"./TXT/Text_File_"
  dumb_text_file_path<-paste(name_txt_file_dumb_1, counter,   ### if for loop then iii rather than counter
                             ".txt", collapse =' ')
  dumb_text_file_path<-gsub(" ","", dumb_text_file_path);
  
#   if ((sum(is.na(file_dumb))==0) && (sum(is.nan(file_dumb)))==0) {
#   
      write.table(file_dumb, file=dumb_text_file_path, 
                sep = "\t", row.names=FALSE, col.names=FALSE);
      counter<-counter+1;
#   
#   }

  iii<-iii+1;
}





