Rheumatoid   arthritis   (RA)—a   chronic,   inflam-matory  disease—causes  bone  as  well  as  joint  erosion,  and  ifuntreated,  it  can  lead  to  patients’  disabilities.  Early  detectionof RA can have a key role in prognosis of the disease.
Objectives:  We  aimed  to  develop  an  eXplainable  Decision  Sup-port  System  (XDSS)  to  assist  primary  care  providers  in  earlydetection of patients with RA.
Methods:   Based   on   the   Sparse   Fuzzy   Cognitive   Maps   andquantum-learning  algorithm,  we  developed  our  explainable  in-telligent  system—which  is  available  as  a  web  server—to  assistin  the  detection  of  RA  patients  at  early  stages  and  classify  theseverity  of  their  disease  into  six  different  levels,  collaboratingwith two specialists in rheumatology and orthopedic surgery. We collected anonymous data of real patients from Shohada Univer-sity Hospital, Tabriz, Iran and used for model development. 
We also  compared  the  results  of  our  model  with  machine  learning methods  (e.g.,  linear  discriminant  analysis,  Support  Vector  Ma-chines,  and  K-Nearest  Neighbours).  The  weights  obtained  fromour model were saved and deployed as part of a web app to give risk intensity scores based on the patient information. 
Results  and  Conclusions:Our  proposed  model  not  only  outper-formed other machine learning methods in terms of accuracy butalso,  in  contrast  to  the  others,  our  model  revealed  the  relationof the features with one another and gave higher explainability. 
For  future  studies,  we  are  suggesting  scaling  up  the  developedapp and identifying facilitators and barriers of using this app in clinical practice.

The website can be accessed from: https://rahimislab.ca/ra-dss



Please cite this paper if you use this method or codes:

```sh
@article{rahimi2022quantum,
  title={Quantum-Inspired Interpertable AI-Empowered Decision Support System for Detection of Early-Stage Rheumatoid Arthritis in Primary Care Using Scarce Dataset},
  author={Rahimi, Samira Abbasgholizadeh and Kolahdoozi, Mojtaba and Mitra, Arka and Salmeron, Jose L and Navali, Amir Mohammad and Sadeghpour, Alireza and Mir Mohammadi, Amir},
  journal={Mathematics},
  volume={10},
  number={3},
  pages={496},
  year={2022},
  publisher={Multidisciplinary Digital Publishing Institute}
}
