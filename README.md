# Complete-Enumeration
MATLAB files associatied with the manuscript "Combinatorial Optimization of Classification Decisions: An Application to Refine Psychiatric Diagnoses." The following files and their purposes are provided below. 

## Function/file descriptions
The following functions and syntax files were used for the demonstration and simulation provided in the manuscript. 

### Example
masterfile
  This file will execute the analyses from the Demonstration

### Data formatting
read_N3_AUD
  formats the Alcohol Use Disorder symptoms, necessary derivation variables, and demographic variables from   the NESARC-III dataset

### Optimization files
complete_enum
  Creates clusters from the the symptoms and calcuates the separation on the derivation variable,   consumption for every diagnostic rule. 
Opt_CV 
  Performs cross-validation (CV), utilizing the complete_enum function
opt_mult_it
  Executes the CV of the complete enumeration program for the number of iterations input
combinations
  Calculates the total number of rules possible from the number of symptoms input
enumerate_rules
  Produces a the completely enumerated rules from the input symptom set

### Simulation files
N3AUD_sim
  masterfile to run the simulation provided in the paper
genDerivationVar
  Function to randomly select an optimal diagnostic rule, create diagnostic clusterings, and generate the     derivation variable with a set degree of overlap



masterfile: The masterfile will utilize the functions opt_mult_it, combinations, enumerate_rules, 
