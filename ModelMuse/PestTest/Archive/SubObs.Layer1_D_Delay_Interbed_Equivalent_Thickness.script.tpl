ptf @
#Script for PLPROC

#Read MODFLOW-2005 grid information file
cl_Discretization = read_mf_grid_specs(file="SubObs.gsf")
#Read data to modify
read_list_file(reference_clist='cl_Discretization',skiplines=1, &
  slist=s_PIndex1;column=2, &
  plist=p_Value1;column=3, &
  file='SubObs.Layer1_D_Delay_Interbed_Equivalent_Thickness.PstValues')

#Read parameter values
Sub = @                        Sub@
# Pilot points are not used with Sub.

# Modfify data values
temp1=new_plist(reference_clist=cl_Discretization,value=0.0)
# Setting values for layer     1
  # Setting values for parameter Sub
    # Substituting parameter values in zones
    p_Value1(select=(s_PIndex1 == 1)) = p_Value1 * Sub

#Write new data values
write_column_data_file(header='no', &
  file='arrays\SubObs.Layer1_D_Delay_Interbed_Equivalent_Thickness_1.arrays';delim="space", &
  plist=p_Value1)