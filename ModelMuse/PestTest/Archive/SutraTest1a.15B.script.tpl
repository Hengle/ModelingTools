ptf $
#Script for PLPROC

#Read SUTRA element information file
cl_Discretization = read_list_file(skiplines=1,dimensions=2, &
  plist=p_x;column=2, &
  plist=p_y;column=3, &
  plist=p_EN2D;column=4, &
  id_type='indexed',file='SutraTest1a.c_ele')
read_list_file(reference_clist='cl_Discretization',skiplines=1, &
  plist=p_z1;column=5, &
  slist=s_EN3D1;column=6, &
  slist=s_Active_1;column=7, &
  id_type='indexed',file='SutraTest1a.c_ele')
read_list_file(reference_clist='cl_Discretization',skiplines=1, &
  plist=p_z2;column=8, &
  slist=s_EN3D2;column=9, &
  slist=s_Active_2;column=10, &
  id_type='indexed',file='SutraTest1a.c_ele')
read_list_file(reference_clist='cl_Discretization',skiplines=1, &
  plist=p_z3;column=11, &
  slist=s_EN3D3;column=12, &
  slist=s_Active_3;column=13, &
  id_type='indexed',file='SutraTest1a.c_ele')


#Read pilot point data

#Read data to modify
# Read Unsaturated Zone
read_list_file(reference_clist='cl_Discretization',skiplines=1, &
  slist=s_LREG1;column=4, &
  file='SutraTest1a.Unsat_Region_Elements')
read_list_file(reference_clist='cl_Discretization',skiplines=1, &
  slist=s_LREG2;column=7, &
  file='SutraTest1a.Unsat_Region_Elements')
read_list_file(reference_clist='cl_Discretization',skiplines=1, &
  slist=s_LREG3;column=10, &
  file='SutraTest1a.Unsat_Region_Elements')

# Read Maximum_Permeability
read_list_file(reference_clist='cl_Discretization',skiplines=1, &
  plist=p_PMAX1;column=4, &
  slist=s_PMAXPar1;column=5, &
  file='SutraTest1a.Maximum_Permeability')
read_list_file(reference_clist='cl_Discretization',skiplines=1, &
  plist=p_PMAX2;column=8, &
  slist=s_PMAXPar2;column=9, &
  file='SutraTest1a.Maximum_Permeability')
read_list_file(reference_clist='cl_Discretization',skiplines=1, &
  plist=p_PMAX3;column=12, &
  slist=s_PMAXPar3;column=13, &
  file='SutraTest1a.Maximum_Permeability')

# Read Middle_Permeability
read_list_file(reference_clist='cl_Discretization',skiplines=1, &
  plist=p_PMID1;column=4, &
  slist=s_PMIDPar1;column=5, &
  file='SutraTest1a.Middle_Permeability')
read_list_file(reference_clist='cl_Discretization',skiplines=1, &
  plist=p_PMID2;column=8, &
  slist=s_PMIDPar2;column=9, &
  file='SutraTest1a.Middle_Permeability')
read_list_file(reference_clist='cl_Discretization',skiplines=1, &
  plist=p_PMID3;column=12, &
  slist=s_PMIDPar3;column=13, &
  file='SutraTest1a.Middle_Permeability')

# Read Minimum_Permeability
read_list_file(reference_clist='cl_Discretization',skiplines=1, &
  plist=p_PMIN1;column=4, &
  slist=s_PMINPar1;column=5, &
  file='SutraTest1a.Minimum_Permeability')
read_list_file(reference_clist='cl_Discretization',skiplines=1, &
  plist=p_PMIN2;column=8, &
  slist=s_PMINPar2;column=9, &
  file='SutraTest1a.Minimum_Permeability')
read_list_file(reference_clist='cl_Discretization',skiplines=1, &
  plist=p_PMIN3;column=12, &
  slist=s_PMINPar3;column=13, &
  file='SutraTest1a.Minimum_Permeability')

# Read Angle_Horizontal
read_list_file(reference_clist='cl_Discretization',skiplines=1, &
  plist=p_ANGLE11;column=4, &
  slist=s_ANGLE1Par1;column=5, &
  file='SutraTest1a.Angle_Horizontal')
read_list_file(reference_clist='cl_Discretization',skiplines=1, &
  plist=p_ANGLE12;column=8, &
  slist=s_ANGLE1Par2;column=9, &
  file='SutraTest1a.Angle_Horizontal')
read_list_file(reference_clist='cl_Discretization',skiplines=1, &
  plist=p_ANGLE13;column=12, &
  slist=s_ANGLE1Par3;column=13, &
  file='SutraTest1a.Angle_Horizontal')

# Read Angle_Vertical
read_list_file(reference_clist='cl_Discretization',skiplines=1, &
  plist=p_ANGLE21;column=4, &
  slist=s_ANGLE2Par1;column=5, &
  file='SutraTest1a.Angle_Vertical')
read_list_file(reference_clist='cl_Discretization',skiplines=1, &
  plist=p_ANGLE22;column=8, &
  slist=s_ANGLE2Par2;column=9, &
  file='SutraTest1a.Angle_Vertical')
read_list_file(reference_clist='cl_Discretization',skiplines=1, &
  plist=p_ANGLE23;column=12, &
  slist=s_ANGLE2Par3;column=13, &
  file='SutraTest1a.Angle_Vertical')

# Read Angle_Rotational
read_list_file(reference_clist='cl_Discretization',skiplines=1, &
  plist=p_ANGLE31;column=4, &
  slist=s_ANGLE3Par1;column=5, &
  file='SutraTest1a.Angle_Rotational')
read_list_file(reference_clist='cl_Discretization',skiplines=1, &
  plist=p_ANGLE32;column=8, &
  slist=s_ANGLE3Par2;column=9, &
  file='SutraTest1a.Angle_Rotational')
read_list_file(reference_clist='cl_Discretization',skiplines=1, &
  plist=p_ANGLE33;column=12, &
  slist=s_ANGLE3Par3;column=13, &
  file='SutraTest1a.Angle_Rotational')

# Read Longitudinal_Dispersivity_Max_Dir
read_list_file(reference_clist='cl_Discretization',skiplines=1, &
  plist=p_ALMAX1;column=4, &
  slist=s_ALMAXPar1;column=5, &
  file='SutraTest1a.Longitudinal_Dispersivity_Max_Dir')
read_list_file(reference_clist='cl_Discretization',skiplines=1, &
  plist=p_ALMAX2;column=8, &
  slist=s_ALMAXPar2;column=9, &
  file='SutraTest1a.Longitudinal_Dispersivity_Max_Dir')
read_list_file(reference_clist='cl_Discretization',skiplines=1, &
  plist=p_ALMAX3;column=12, &
  slist=s_ALMAXPar3;column=13, &
  file='SutraTest1a.Longitudinal_Dispersivity_Max_Dir')

# Read Longitudinal_Dispersivity_Mid_Dir
read_list_file(reference_clist='cl_Discretization',skiplines=1, &
  plist=p_ALMID1;column=4, &
  slist=s_ALMIDPar1;column=5, &
  file='SutraTest1a.Longitudinal_Dispersivity_Mid_Dir')
read_list_file(reference_clist='cl_Discretization',skiplines=1, &
  plist=p_ALMID2;column=8, &
  slist=s_ALMIDPar2;column=9, &
  file='SutraTest1a.Longitudinal_Dispersivity_Mid_Dir')
read_list_file(reference_clist='cl_Discretization',skiplines=1, &
  plist=p_ALMID3;column=12, &
  slist=s_ALMIDPar3;column=13, &
  file='SutraTest1a.Longitudinal_Dispersivity_Mid_Dir')

# Read Longitudinal_Dispersivity_Min_Dir
read_list_file(reference_clist='cl_Discretization',skiplines=1, &
  plist=p_ALMIN1;column=4, &
  slist=s_ALMINPar1;column=5, &
  file='SutraTest1a.Longitudinal_Dispersivity_Min_Dir')
read_list_file(reference_clist='cl_Discretization',skiplines=1, &
  plist=p_ALMIN2;column=8, &
  slist=s_ALMINPar2;column=9, &
  file='SutraTest1a.Longitudinal_Dispersivity_Min_Dir')
read_list_file(reference_clist='cl_Discretization',skiplines=1, &
  plist=p_ALMIN3;column=12, &
  slist=s_ALMINPar3;column=13, &
  file='SutraTest1a.Longitudinal_Dispersivity_Min_Dir')

# Read Transverse_Dispersivity_Max_Dir
read_list_file(reference_clist='cl_Discretization',skiplines=1, &
  plist=p_ATMAX1;column=4, &
  slist=s_ATMAXPar1;column=5, &
  file='SutraTest1a.Transverse_Dispersivity_Max_Dir')
read_list_file(reference_clist='cl_Discretization',skiplines=1, &
  plist=p_ATMAX2;column=8, &
  slist=s_ATMAXPar2;column=9, &
  file='SutraTest1a.Transverse_Dispersivity_Max_Dir')
read_list_file(reference_clist='cl_Discretization',skiplines=1, &
  plist=p_ATMAX3;column=12, &
  slist=s_ATMAXPar3;column=13, &
  file='SutraTest1a.Transverse_Dispersivity_Max_Dir')

# Read Transverse_Dispersivity_Mid_Dir
read_list_file(reference_clist='cl_Discretization',skiplines=1, &
  plist=p_ATMID1;column=4, &
  slist=s_ATMIDPar1;column=5, &
  file='SutraTest1a.Transverse_Dispersivity_Mid_Dir')
read_list_file(reference_clist='cl_Discretization',skiplines=1, &
  plist=p_ATMID2;column=8, &
  slist=s_ATMIDPar2;column=9, &
  file='SutraTest1a.Transverse_Dispersivity_Mid_Dir')
read_list_file(reference_clist='cl_Discretization',skiplines=1, &
  plist=p_ATMID3;column=12, &
  slist=s_ATMIDPar3;column=13, &
  file='SutraTest1a.Transverse_Dispersivity_Mid_Dir')

# Read Transverse_Dispersivity_Min_Dir
read_list_file(reference_clist='cl_Discretization',skiplines=1, &
  plist=p_ATMIN1;column=4, &
  slist=s_ATMINPar1;column=5, &
  file='SutraTest1a.Transverse_Dispersivity_Min_Dir')
read_list_file(reference_clist='cl_Discretization',skiplines=1, &
  plist=p_ATMIN2;column=8, &
  slist=s_ATMINPar2;column=9, &
  file='SutraTest1a.Transverse_Dispersivity_Min_Dir')
read_list_file(reference_clist='cl_Discretization',skiplines=1, &
  plist=p_ATMIN3;column=12, &
  slist=s_ATMINPar3;column=13, &
  file='SutraTest1a.Transverse_Dispersivity_Min_Dir')

#Read parameter values
a = $                        a$
#a = 1.1
conc1 = $                        conc1$
#conc1 = 0.1
conc2 = $                        conc2$
#conc2 = 0.2

# applying parameter values
temp=new_plist(reference_clist=cl_Discretization,value=0.0)
# applying parameter a
    # Substituting parameter values in zones
p_PMAX1(select=(s_PMAXPar1 == 1)) = p_PMAX1 * a
    # Substituting parameter values in zones
p_PMAX2(select=(s_PMAXPar2 == 1)) = p_PMAX2 * a
    # Substituting parameter values in zones
p_PMAX3(select=(s_PMAXPar3 == 1)) = p_PMAX3 * a
    # Substituting parameter values in zones
p_PMID1(select=(s_PMIDPar1 == 1)) = p_PMID1 * a
    # Substituting parameter values in zones
p_PMID2(select=(s_PMIDPar2 == 1)) = p_PMID2 * a
    # Substituting parameter values in zones
p_PMID3(select=(s_PMIDPar3 == 1)) = p_PMID3 * a
    # Substituting parameter values in zones
p_PMIN1(select=(s_PMINPar1 == 1)) = p_PMIN1 * a
    # Substituting parameter values in zones
p_PMIN2(select=(s_PMINPar2 == 1)) = p_PMIN2 * a
    # Substituting parameter values in zones
p_PMIN3(select=(s_PMINPar3 == 1)) = p_PMIN3 * a
    # Substituting parameter values in zones
p_ANGLE11(select=(s_ANGLE1Par1 == 1)) = p_ANGLE11 * a
    # Substituting parameter values in zones
p_ANGLE12(select=(s_ANGLE1Par2 == 1)) = p_ANGLE12 * a
    # Substituting parameter values in zones
p_ANGLE13(select=(s_ANGLE1Par3 == 1)) = p_ANGLE13 * a
    # Substituting parameter values in zones
p_ANGLE21(select=(s_ANGLE2Par1 == 1)) = p_ANGLE21 * a
    # Substituting parameter values in zones
p_ANGLE22(select=(s_ANGLE2Par2 == 1)) = p_ANGLE22 * a
    # Substituting parameter values in zones
p_ANGLE23(select=(s_ANGLE2Par3 == 1)) = p_ANGLE23 * a
    # Substituting parameter values in zones
p_ANGLE31(select=(s_ANGLE3Par1 == 1)) = p_ANGLE31 * a
    # Substituting parameter values in zones
p_ANGLE32(select=(s_ANGLE3Par2 == 1)) = p_ANGLE32 * a
    # Substituting parameter values in zones
p_ANGLE33(select=(s_ANGLE3Par3 == 1)) = p_ANGLE33 * a
    # Substituting parameter values in zones
p_ALMAX1(select=(s_ALMAXPar1 == 1)) = p_ALMAX1 * a
    # Substituting parameter values in zones
p_ALMAX2(select=(s_ALMAXPar2 == 1)) = p_ALMAX2 * a
    # Substituting parameter values in zones
p_ALMAX3(select=(s_ALMAXPar3 == 1)) = p_ALMAX3 * a
    # Substituting parameter values in zones
p_ALMID1(select=(s_ALMIDPar1 == 1)) = p_ALMID1 * a
    # Substituting parameter values in zones
p_ALMID2(select=(s_ALMIDPar2 == 1)) = p_ALMID2 * a
    # Substituting parameter values in zones
p_ALMID3(select=(s_ALMIDPar3 == 1)) = p_ALMID3 * a
    # Substituting parameter values in zones
p_ALMIN1(select=(s_ALMINPar1 == 1)) = p_ALMIN1 * a
    # Substituting parameter values in zones
p_ALMIN2(select=(s_ALMINPar2 == 1)) = p_ALMIN2 * a
    # Substituting parameter values in zones
p_ALMIN3(select=(s_ALMINPar3 == 1)) = p_ALMIN3 * a
    # Substituting parameter values in zones
p_ATMAX1(select=(s_ATMAXPar1 == 1)) = p_ATMAX1 * a
    # Substituting parameter values in zones
p_ATMAX2(select=(s_ATMAXPar2 == 1)) = p_ATMAX2 * a
    # Substituting parameter values in zones
p_ATMAX3(select=(s_ATMAXPar3 == 1)) = p_ATMAX3 * a
    # Substituting parameter values in zones
p_ATMID1(select=(s_ATMIDPar1 == 1)) = p_ATMID1 * a
    # Substituting parameter values in zones
p_ATMID2(select=(s_ATMIDPar2 == 1)) = p_ATMID2 * a
    # Substituting parameter values in zones
p_ATMID3(select=(s_ATMIDPar3 == 1)) = p_ATMID3 * a
    # Substituting parameter values in zones
p_ATMIN1(select=(s_ATMINPar1 == 1)) = p_ATMIN1 * a
    # Substituting parameter values in zones
p_ATMIN2(select=(s_ATMINPar2 == 1)) = p_ATMIN2 * a
    # Substituting parameter values in zones
p_ATMIN3(select=(s_ATMINPar3 == 1)) = p_ATMIN3 * a

# applying parameter conc1
    # Substituting parameter values in zones
p_PMAX1(select=(s_PMAXPar1 == 2)) = p_PMAX1 * conc1
    # Substituting parameter values in zones
p_PMAX2(select=(s_PMAXPar2 == 2)) = p_PMAX2 * conc1
    # Substituting parameter values in zones
p_PMAX3(select=(s_PMAXPar3 == 2)) = p_PMAX3 * conc1
    # Substituting parameter values in zones
p_PMID1(select=(s_PMIDPar1 == 2)) = p_PMID1 * conc1
    # Substituting parameter values in zones
p_PMID2(select=(s_PMIDPar2 == 2)) = p_PMID2 * conc1
    # Substituting parameter values in zones
p_PMID3(select=(s_PMIDPar3 == 2)) = p_PMID3 * conc1
    # Substituting parameter values in zones
p_PMIN1(select=(s_PMINPar1 == 2)) = p_PMIN1 * conc1
    # Substituting parameter values in zones
p_PMIN2(select=(s_PMINPar2 == 2)) = p_PMIN2 * conc1
    # Substituting parameter values in zones
p_PMIN3(select=(s_PMINPar3 == 2)) = p_PMIN3 * conc1
    # Substituting parameter values in zones
p_ANGLE11(select=(s_ANGLE1Par1 == 2)) = p_ANGLE11 * conc1
    # Substituting parameter values in zones
p_ANGLE12(select=(s_ANGLE1Par2 == 2)) = p_ANGLE12 * conc1
    # Substituting parameter values in zones
p_ANGLE13(select=(s_ANGLE1Par3 == 2)) = p_ANGLE13 * conc1
    # Substituting parameter values in zones
p_ANGLE21(select=(s_ANGLE2Par1 == 2)) = p_ANGLE21 * conc1
    # Substituting parameter values in zones
p_ANGLE22(select=(s_ANGLE2Par2 == 2)) = p_ANGLE22 * conc1
    # Substituting parameter values in zones
p_ANGLE23(select=(s_ANGLE2Par3 == 2)) = p_ANGLE23 * conc1
    # Substituting parameter values in zones
p_ANGLE31(select=(s_ANGLE3Par1 == 2)) = p_ANGLE31 * conc1
    # Substituting parameter values in zones
p_ANGLE32(select=(s_ANGLE3Par2 == 2)) = p_ANGLE32 * conc1
    # Substituting parameter values in zones
p_ANGLE33(select=(s_ANGLE3Par3 == 2)) = p_ANGLE33 * conc1
    # Substituting parameter values in zones
p_ALMAX1(select=(s_ALMAXPar1 == 2)) = p_ALMAX1 * conc1
    # Substituting parameter values in zones
p_ALMAX2(select=(s_ALMAXPar2 == 2)) = p_ALMAX2 * conc1
    # Substituting parameter values in zones
p_ALMAX3(select=(s_ALMAXPar3 == 2)) = p_ALMAX3 * conc1
    # Substituting parameter values in zones
p_ALMID1(select=(s_ALMIDPar1 == 2)) = p_ALMID1 * conc1
    # Substituting parameter values in zones
p_ALMID2(select=(s_ALMIDPar2 == 2)) = p_ALMID2 * conc1
    # Substituting parameter values in zones
p_ALMID3(select=(s_ALMIDPar3 == 2)) = p_ALMID3 * conc1
    # Substituting parameter values in zones
p_ALMIN1(select=(s_ALMINPar1 == 2)) = p_ALMIN1 * conc1
    # Substituting parameter values in zones
p_ALMIN2(select=(s_ALMINPar2 == 2)) = p_ALMIN2 * conc1
    # Substituting parameter values in zones
p_ALMIN3(select=(s_ALMINPar3 == 2)) = p_ALMIN3 * conc1
    # Substituting parameter values in zones
p_ATMAX1(select=(s_ATMAXPar1 == 2)) = p_ATMAX1 * conc1
    # Substituting parameter values in zones
p_ATMAX2(select=(s_ATMAXPar2 == 2)) = p_ATMAX2 * conc1
    # Substituting parameter values in zones
p_ATMAX3(select=(s_ATMAXPar3 == 2)) = p_ATMAX3 * conc1
    # Substituting parameter values in zones
p_ATMID1(select=(s_ATMIDPar1 == 2)) = p_ATMID1 * conc1
    # Substituting parameter values in zones
p_ATMID2(select=(s_ATMIDPar2 == 2)) = p_ATMID2 * conc1
    # Substituting parameter values in zones
p_ATMID3(select=(s_ATMIDPar3 == 2)) = p_ATMID3 * conc1
    # Substituting parameter values in zones
p_ATMIN1(select=(s_ATMINPar1 == 2)) = p_ATMIN1 * conc1
    # Substituting parameter values in zones
p_ATMIN2(select=(s_ATMINPar2 == 2)) = p_ATMIN2 * conc1
    # Substituting parameter values in zones
p_ATMIN3(select=(s_ATMINPar3 == 2)) = p_ATMIN3 * conc1

# applying parameter conc2
    # Substituting parameter values in zones
p_PMAX1(select=(s_PMAXPar1 == 3)) = p_PMAX1 * conc2
    # Substituting parameter values in zones
p_PMAX2(select=(s_PMAXPar2 == 3)) = p_PMAX2 * conc2
    # Substituting parameter values in zones
p_PMAX3(select=(s_PMAXPar3 == 3)) = p_PMAX3 * conc2
    # Substituting parameter values in zones
p_PMID1(select=(s_PMIDPar1 == 3)) = p_PMID1 * conc2
    # Substituting parameter values in zones
p_PMID2(select=(s_PMIDPar2 == 3)) = p_PMID2 * conc2
    # Substituting parameter values in zones
p_PMID3(select=(s_PMIDPar3 == 3)) = p_PMID3 * conc2
    # Substituting parameter values in zones
p_PMIN1(select=(s_PMINPar1 == 3)) = p_PMIN1 * conc2
    # Substituting parameter values in zones
p_PMIN2(select=(s_PMINPar2 == 3)) = p_PMIN2 * conc2
    # Substituting parameter values in zones
p_PMIN3(select=(s_PMINPar3 == 3)) = p_PMIN3 * conc2
    # Substituting parameter values in zones
p_ANGLE11(select=(s_ANGLE1Par1 == 3)) = p_ANGLE11 * conc2
    # Substituting parameter values in zones
p_ANGLE12(select=(s_ANGLE1Par2 == 3)) = p_ANGLE12 * conc2
    # Substituting parameter values in zones
p_ANGLE13(select=(s_ANGLE1Par3 == 3)) = p_ANGLE13 * conc2
    # Substituting parameter values in zones
p_ANGLE21(select=(s_ANGLE2Par1 == 3)) = p_ANGLE21 * conc2
    # Substituting parameter values in zones
p_ANGLE22(select=(s_ANGLE2Par2 == 3)) = p_ANGLE22 * conc2
    # Substituting parameter values in zones
p_ANGLE23(select=(s_ANGLE2Par3 == 3)) = p_ANGLE23 * conc2
    # Substituting parameter values in zones
p_ANGLE31(select=(s_ANGLE3Par1 == 3)) = p_ANGLE31 * conc2
    # Substituting parameter values in zones
p_ANGLE32(select=(s_ANGLE3Par2 == 3)) = p_ANGLE32 * conc2
    # Substituting parameter values in zones
p_ANGLE33(select=(s_ANGLE3Par3 == 3)) = p_ANGLE33 * conc2
    # Substituting parameter values in zones
p_ALMAX1(select=(s_ALMAXPar1 == 3)) = p_ALMAX1 * conc2
    # Substituting parameter values in zones
p_ALMAX2(select=(s_ALMAXPar2 == 3)) = p_ALMAX2 * conc2
    # Substituting parameter values in zones
p_ALMAX3(select=(s_ALMAXPar3 == 3)) = p_ALMAX3 * conc2
    # Substituting parameter values in zones
p_ALMID1(select=(s_ALMIDPar1 == 3)) = p_ALMID1 * conc2
    # Substituting parameter values in zones
p_ALMID2(select=(s_ALMIDPar2 == 3)) = p_ALMID2 * conc2
    # Substituting parameter values in zones
p_ALMID3(select=(s_ALMIDPar3 == 3)) = p_ALMID3 * conc2
    # Substituting parameter values in zones
p_ALMIN1(select=(s_ALMINPar1 == 3)) = p_ALMIN1 * conc2
    # Substituting parameter values in zones
p_ALMIN2(select=(s_ALMINPar2 == 3)) = p_ALMIN2 * conc2
    # Substituting parameter values in zones
p_ALMIN3(select=(s_ALMINPar3 == 3)) = p_ALMIN3 * conc2
    # Substituting parameter values in zones
p_ATMAX1(select=(s_ATMAXPar1 == 3)) = p_ATMAX1 * conc2
    # Substituting parameter values in zones
p_ATMAX2(select=(s_ATMAXPar2 == 3)) = p_ATMAX2 * conc2
    # Substituting parameter values in zones
p_ATMAX3(select=(s_ATMAXPar3 == 3)) = p_ATMAX3 * conc2
    # Substituting parameter values in zones
p_ATMID1(select=(s_ATMIDPar1 == 3)) = p_ATMID1 * conc2
    # Substituting parameter values in zones
p_ATMID2(select=(s_ATMIDPar2 == 3)) = p_ATMID2 * conc2
    # Substituting parameter values in zones
p_ATMID3(select=(s_ATMIDPar3 == 3)) = p_ATMID3 * conc2
    # Substituting parameter values in zones
p_ATMIN1(select=(s_ATMINPar1 == 3)) = p_ATMIN1 * conc2
    # Substituting parameter values in zones
p_ATMIN2(select=(s_ATMINPar2 == 3)) = p_ATMIN2 * conc2
    # Substituting parameter values in zones
p_ATMIN3(select=(s_ATMINPar3 == 3)) = p_ATMIN3 * conc2

# Write new data values
write_column_data_file(header = 'no', &
  file='SutraTest1a.15B_1';delim="space", &
  select=(s_Active_1 == 1), &
  slist='s_EN3D1', &
  slist=s_LREG1, &
  plist=p_PMAX1, &
  plist=p_PMID1, &
  plist=p_PMIN1, &
  plist=p_ANGLE11, &
  plist=p_ANGLE21, &
  plist=p_ANGLE31, &
  plist=p_ALMAX1, &
  plist=p_ALMID1, &
  plist=p_ALMIN1, &
  plist=p_ATMAX1, &
  plist=p_ATMID1, &
  plist=p_ATMIN1)
write_column_data_file(header = 'no', &
  file='SutraTest1a.15B_2';delim="space", &
  select=(s_Active_2 == 1), &
  slist='s_EN3D2', &
  slist=s_LREG2, &
  plist=p_PMAX2, &
  plist=p_PMID2, &
  plist=p_PMIN2, &
  plist=p_ANGLE12, &
  plist=p_ANGLE22, &
  plist=p_ANGLE32, &
  plist=p_ALMAX2, &
  plist=p_ALMID2, &
  plist=p_ALMIN2, &
  plist=p_ATMAX2, &
  plist=p_ATMID2, &
  plist=p_ATMIN2)
write_column_data_file(header = 'no', &
  file='SutraTest1a.15B_3';delim="space", &
  select=(s_Active_3 == 1), &
  slist='s_EN3D3', &
  slist=s_LREG3, &
  plist=p_PMAX3, &
  plist=p_PMID3, &
  plist=p_PMIN3, &
  plist=p_ANGLE13, &
  plist=p_ANGLE23, &
  plist=p_ANGLE33, &
  plist=p_ALMAX3, &
  plist=p_ALMID3, &
  plist=p_ALMIN3, &
  plist=p_ATMAX3, &
  plist=p_ATMID3, &
  plist=p_ATMIN3)