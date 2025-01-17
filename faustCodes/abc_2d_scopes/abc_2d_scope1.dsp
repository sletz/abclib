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
declare name "abc_2d_scope1";
//
//--------------------------------------------------------------------------------------//
//SCOPE OBJECTS FOR AMBISONIC VIZUALISATION USING MAX SCOPE~ OBJECT
//--------------------------------------------------------------------------------------//
//
import("stdfaust.lib");
//--------------------------------------------------------------------------------------//
//CONTROL PARAMETERS: NUMBER OF COMPLETE CYCLES (COMPLETE DRAWINGS) PER SECOND
//--------------------------------------------------------------------------------------//
refresh = hslider("v:scope/refresh [unit:msec]", 10, 1, 2000, 1) * 0.001;//refresh time, default is 10 msec

//--------------------------------------------------------------------------------------//
//ANGLE SWEEPING PERIODICALLY 0 TO 2*PI INTERVAL
//--------------------------------------------------------------------------------------//
theta = os.phasor(1, 1/refresh) * 2 * ma.PI;

//--------------------------------------------------------------------------------------//
//SPATIAL HARMONIC VECTOR
//--------------------------------------------------------------------------------------//
//we get the vector of harmonic functions thanks to the encoding function//
harmonicsVector = ho.encoder(n, 1, theta);

//--------------------------------------------------------------------------------------//
//INPUT DISPATCHING
//--------------------------------------------------------------------------------------//
//
//starting with 2n values sigA1, sigA2, ... sigAn, sigB1, sigB2, ... sigBn
//the result is the vector sigA1, sigB1, sigA2, sigB2, ..., sigAn, sigBn
//--------------------------------------------------------------------------------------//
inputSort(n) = si.bus(2*n) <: par(i, n, (ba.selector(i, 2*n), ba.selector(i+n, 2*n)));

//--------------------------------------------------------------------------------------//
//BUILDING A (2N+1) NORMALIZED VECTOR
//--------------------------------------------------------------------------------------//
connect2nplus1 = par(i, (2*n+1), _);
connect4nplus2 = par(i, (4*n+2), _);
connect2nplus1Vers4nplus2 = connect2nplus1 <: connect4nplus2;
div2nplus1 = par(i, (2*n+1), /);
norm2nplus1 = par(i, (2*n+1), _ <:(_,_) : *) :> _ : sqrt <: ((_ == 0), (_ > 0), _) : (_, *) : + <: connect2nplus1;
normalizedInput = connect2nplus1Vers4nplus2 : (connect2nplus1, norm2nplus1) : inputSort(2*n+1) : div2nplus1;
//--------------------------------------------------------------------------------------//
//BUILDING THE 2 NORMALIZED VECTORS: HARMONIC WEIGHTS CAPTURED AS INPUTS AND SPATIAL HARMONICS
//--------------------------------------------------------------------------------------//
inputVector = (*(0.5), par(i, (2*n), _)) : normalizedInput;
normalizedHarmonics = harmonicsVector : normalizedInput;

//--------------------------------------------------------------------------------------//
//BUILDING RHO
//--------------------------------------------------------------------------------------//
rho = (inputVector, normalizedHarmonics) : si.dot(2*n+1) ;
//
n = 1;//ambisonic order//
process = (rho <: (ma.fabs, (_ >= 0))) : ((_ <: (_, _)), _) : (*(sin(theta)), *(cos(theta)), _) : (*(-1), _, _);
