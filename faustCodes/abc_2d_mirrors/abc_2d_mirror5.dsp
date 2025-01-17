//--------------------------------------------------------------------------------------//
//----------------------------------------abclib----------------------------------------//
//
//-------------------------FAUST CODE AND UTILITIES FOR MIXED MUSIC---------------------//
//
//----------------------------- BY ALAIN BONARDI - 2019-2021 ---------------------------//
//---------------------CICM - MUSIDANSE LABORATORY - PARIS 8 UNIVERSITY-----------------//
//--------------------------------------------------------------------------------------//
//
declare author "Alain Bonardi";
declare licence "LGPLv3";
declare name "abc_2d_mirror5";
//
//--------------------------------------------------------------------------------------//
//FX MIRROR APPLIES A FACTOR AS A WEIGHT TO THE NEGATIVE HARMONICS
//TO CREATE THE MIRROR SOUNDFIELD TO ITSELF
//
//H					WEIGHT
//0					1				
//-1				FACTOR				
//1					1				
//-2				FACTOR				
//2					1				
//...
//-(N-1)			FACTOR
//(N-1)				1			
//-N				FACTOR
//N					1				
//
//THE FACTOR CAN TAKE 3 VALUES:
//1 => ORIGINAL SOUND FIELD
//0 => ORIGINAL + MIRROR SOUND FIELD
//-1 => MIRROR SOUND FIELD
//--------------------------------------------------------------------------------------//
//
import("stdfaust.lib");
//
//--------------------------------------------------------------------------------------//
//CONTROL PARAMETERS
//--------------------------------------------------------------------------------------//
//
factor = hslider("v:fxmirror/factor", 1, -1, 1, 1) : si.smoo;
//
//--------------------------------------------------------------------------------------//
//COMPUTES THE FXMIRROR AT AMBISONIC ORDER N
//(with 2*N+1) components
//--------------------------------------------------------------------------------------//
//
mirror(n, fa) = (*(1), par(i, n, (*(fa), *(1))));
//
process = mirror(5, factor);
