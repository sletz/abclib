//--------------------------------------------------------------------------------------//
//----------------------------------------abclib----------------------------------------//
//
//-------------------------------FAUST CODE FOR MIXED MUSIC-----------------------------//
//
//-------------------------------- BY ALAIN BONARDI - 2019 -----------------------------//
//--------------------------------------------------------------------------------------//

declare name "abc2Dscope3";
declare author "Alain Bonardi";
declare licence "GPLv3";

import("stdfaust.lib");
import("../abccommon/abcd2dscope.dsp");

//--------------------------------------------------------------------------------------//
//AMBISONIC ORDER TO BE MODIFIED
//--------------------------------------------------------------------------------------//
n = 3;//ambisonic order 3 here//

process = (rho <: (_, _) : (*(sin(theta)), *(cos(theta))) : (*(-1), _));