---
title: "Markdown"
author: "The Mendeleev-Meyer Force Project (TMMFP)"
date: "Wednesday, May 18, 2016"
---

<!--( Detailed usage of the R and Matlab scripts employed to produce
the data first presented in May 2016 for TMMFP


Laboratory for Energy and NanoScience (LENS), Institute Center for Future Energy (iFES), Masdar Institute of Science and Technology, Abu Dhabi, UAE

www.lens-online.net
https://www.masdar.ac.ae/faculty-top/list-of-faculty/item/5697-matteo-chiesa

Future Synthesis (www.future-synthesis.com)

)--> 


# Information and Beta version for:

**The Mendeleev-Meyer Force Project (TMMFP)**


Laboratory for Energy and NanoScience (LENS), Institute Center for Future Energy (iFES), Masdar Institute of Science and Technology, Abu Dhabi, UAE

www.lens-online.net
https://www.masdar.ac.ae/faculty-top/list-of-faculty/item/5697-matteo-chiesa

Future Synthesis (www.future-synthesis.com)



##  What this Beta version does:

Presentation to the project:

The Mendeleev-Meyer Force Project (TMMFP) aims at tabulating all materials and substances in a fashion similar to that in which the periodic table was originally constructed. The MMPF will further be assisted computer science similarly to the way in which bioinformatics assists biology today, for example, in the human genome project, proteomics and metagenomics, providing 

1) relational databases, 

2) automated experimental design automation and tutorials, 

3) referenced and cross-referenced information, 

4) open source codes to algorithms, 

5) collaboration/s with private companies assisting in the design and generation of libraries, algorithms and experimental design. 

The final aim is to mimick successful current advanced forms of computer science assisted biology. 


##  The methodology in Beta version 

The current version of the project is the TMMFP.Beta.1. This version contains all the work carried out to produce a manuscript submitted in May 2016. 

All codes and raw data are provided [in a dedicated dropbox account](https://www.dropbox.com/TMMFProject) and the codes are also stored in a dedicated github repository [here](https://github.com/TMMFProject) and [here](https://github.com/fsdataanalysis). 

Contents:

- Raw data from amplitude versus distance profiles aquired in standard atomic force microscopy. 

  An example of raw data aquisition is given [here under ForceMaps](https://www.dropbox.com/TMMFProject). 
  
  
  This example illustrates cantilever calibration and raw data adquisition for force reconstruction 
  in amplitude mode atmic force microscopy. 
  
  STEPS
  
  * The data is aquired with an Asylum Research instrument, i.e. Cypher AFM, and in the Igor format.
  
  * First the cantilever is calibrated
  
  * Then the data is aquired for further processing


- The Raw data is then converted into Force versus distance profiles and employed to build
 feature libraries and model libraries. 



  An example of converting the raw data into force versus distance data and making feature libraries and model libraries is given [here under RawDataAndForceCurves](https://www.dropbox.com/TMMFProject).  
  
  
  - Model libraries can then be emploied to identify materials pixel per pixel.
  
  
  
  An example of converting the raw data into force versus distance data and making feature libraries    and model libraries is given [here under TMMFP_IdentificationExample](https://www.dropbox.com/TMMFProject). The model library used in this example can discriminate between calcipe phase 1 and 2.
  
  
  
  

- Codes (matlab) 


At this point all the codes and raw data can be downloaded directly and require a Matlab interpreter and license to be run. Future releases will be more flexible and allow computing directly by cloud access.  

  