ptf $
#Script for PLPROC

#Read SUTRA element information file
cl_Discretization = read_list_file(skiplines=1,dimensions=2, &
  plist=p_x;column=2, &
  plist=p_y;column=3, &
  plist=p_EN2D;column=4, &
  id_type='indexed',file='RmaSutraNodeTest.c_ele')

#Read data to modify
# Read Unsaturated Zone
read_list_file(reference_clist='cl_Discretization',skiplines=1, &
  slist=s_LREG1;column=2, &
  file='RmaSutraNodeTest.Unsat_Region_Elements')

# Read Maximum_Hydraulic_Conductivity
  p_PMAX1=new_plist(reference_clist='cl_Discretization',value=1.0)
  p_PMAX1.read_list_as_array(file='arrays\RmaSutraNodeTest.Maximum_Hydraulic_Conductivity_1.arrays')
  s_PMAXPar1=new_slist(reference_clist='cl_Discretization',value=1)

# Read Minimum_Hydraulic_Conductivity
  p_PMIN1=new_plist(reference_clist='cl_Discretization',value=1.0)
  p_PMIN1.read_list_as_array(file='arrays\RmaSutraNodeTest.Minimum_Hydraulic_Conductivity_1.arrays')
  s_PMINPar1=new_slist(reference_clist='cl_Discretization',value=1)

# Read Angle_Horizontal
read_list_file(reference_clist='cl_Discretization',skiplines=1, &
  plist=p_ANGLE11;column=2, &
  slist=s_ANGLE1Par1;column=3, &
  file='RmaSutraNodeTest.Angle_Horizontal')

# Read Longitudinal_Dispersivity_Max_Dir
read_list_file(reference_clist='cl_Discretization',skiplines=1, &
  plist=p_ALMAX1;column=2, &
  slist=s_ALMAXPar1;column=3, &
  file='RmaSutraNodeTest.Longitudinal_Dispersivity_Max_Dir')

# Read Longitudinal_Dispersivity_Min_Dir
read_list_file(reference_clist='cl_Discretization',skiplines=1, &
  plist=p_ALMIN1;column=2, &
  slist=s_ALMINPar1;column=3, &
  file='RmaSutraNodeTest.Longitudinal_Dispersivity_Min_Dir')

# Read Transverse_Dispersivity_Max_Dir
read_list_file(reference_clist='cl_Discretization',skiplines=1, &
  plist=p_ATMAX1;column=2, &
  slist=s_ATMAXPar1;column=3, &
  file='RmaSutraNodeTest.Transverse_Dispersivity_Max_Dir')

# Read Transverse_Dispersivity_Min_Dir
read_list_file(reference_clist='cl_Discretization',skiplines=1, &
  plist=p_ATMIN1;column=2, &
  slist=s_ATMINPar1;column=3, &
  file='RmaSutraNodeTest.Transverse_Dispersivity_Min_Dir')

#Read parameter values
Seepage = $                        Seepage$
#Seepage = 1

# applying parameter values
temp=new_plist(reference_clist=cl_Discretization,value=0.0)
# applying parameter K

# applying parameter Seepage
    # Substituting parameter values in zones
p_PMAX1(select=(s_PMAXPar1 == 2)) = p_PMAX1 * Seepage
    # Substituting parameter values in zones
p_PMIN1(select=(s_PMINPar1 == 2)) = p_PMIN1 * Seepage
    # Substituting parameter values in zones
p_ANGLE11(select=(s_ANGLE1Par1 == 2)) = p_ANGLE11 * Seepage
    # Substituting parameter values in zones
p_ALMAX1(select=(s_ALMAXPar1 == 2)) = p_ALMAX1 * Seepage
    # Substituting parameter values in zones
p_ALMIN1(select=(s_ALMINPar1 == 2)) = p_ALMIN1 * Seepage
    # Substituting parameter values in zones
p_ATMAX1(select=(s_ATMAXPar1 == 2)) = p_ATMAX1 * Seepage
    # Substituting parameter values in zones
p_ATMIN1(select=(s_ATMINPar1 == 2)) = p_ATMIN1 * Seepage

# Write new data values
write_column_data_file(header = 'no', &
  file='RmaSutraNodeTest.15B';delim="space", &
  clist_spec='id', &
  slist=s_LREG1, &
  plist=p_PMAX1, &
  plist=p_PMIN1, &
  plist=p_ANGLE11, &
  plist=p_ALMAX1, &
  plist=p_ALMIN1, &
  plist=p_ATMAX1, &
  plist=p_ATMIN1)