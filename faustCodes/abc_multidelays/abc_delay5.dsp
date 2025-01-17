//--------------------------------------------------------------------------------------//
//----------------------------------------abclib----------------------------------------//
//
//-------------------------FAUST CODE AND UTILITIES FOR MIXED MUSIC---------------------//
//
//-----------------------BY ALAIN BONARDI & PAUL GOUTMANN - 2019-2021 ------------------//
//---------------------CICM - MUSIDANSE LABORATORY - PARIS 8 UNIVERSITY-----------------//
//--------------------------------------------------------------------------------------//
//
declare author "Alain Bonardi & Paul Goutmann";
declare licence "LGPLv3";
declare name "abc_delay5";
//
import("stdfaust.lib");
//
//uses abcdoublelay.dsp and abcdbcontrol.dsp
//
//THESE PARALLEL DELAY LINES WORK WITH MUSICAL DURATIONS AND A TEMPO
//TO EXPRESS THE DURATIONS OF DELAYS AS THE DURATION OF NOTES
//
//--------------------------------------------------------------------------------------//
//CONTROL PARAMETERS
//--------------------------------------------------------------------------------------//
//
updatefreq = hslider("h:multidelays/v:general/updatefreq [unit:Hz]", 30, 0.0001, 1000, 0.0001);
fdbk(ind) = hslider("h:multidelays/v:fdbks/fdbk%2ind", 0, 0, 0.99999, 0.0001) : si.smoo;
//
tempo = nentry("h:multidelays/v:general/tempo [unit:bpm]", 60, 1, 600, 0.01);
//--------------------------------------------------------------------------------------//
//Maximum number of samples if a common delay line
//corresponding to a bit more than 21,8 seconds at 48 KHz
Ndelsamp = 1048576;
//--------------------------------------------------------------------------------------//
dur(ind)=((hslider("h:multidelays/v:durations/dur%2ind [unit:musicaldur]", 1, 0, 32, 0.0001) * 60 / tempo * ma.SR), Ndelsamp) : min ;
gain(ind) = hslider("h:multidelays/v:dynamics/gain%2ind [unit:dB]", 0, -127, 18, 0.001) : dbtogain;
//--------------------------------------------------------------------------------------//
//DEFINITION OF A DOUBLE DELAY LINE FOR PARALLEL IMPLEMENTATION
//--------------------------------------------------------------------------------------//
delpar(ind) = fdOverlappedDoubleDelay(dur(ind), Ndelsamp, updatefreq, fdbk(ind));
//
delparset(n) = par(i, n, (delpar(i) : *(gain(i))));
//
//


//
//--------------------------------------------------------------------------------------//
//DOUBLE OVERLAPPED DELAY
//--------------------------------------------------------------------------------------//
//nsamp is the number of samples of delay
//freq is the frequency of envelopping for the overlapping between the 2 delay lines
//
//--------------------------------------------------------------------------------------//
// PHASOR THAT ACCEPTS BOTH NEGATIVE AND POSITIVE FREQUENCES
//--------------------------------------------------------------------------------------//
pdPhasor(f) = os.phasor(1, f);
//
//An overlapped delay without reinjection//
//
overlappedDoubleDelay(nsamp, nmax, freq) = doubleDelay
	with {
			env1 = freq : pdPhasor : sinusEnvelop : *(0.5) : +(0.5);
			env1c = 1 - env1;
			th1 = (env1 > 0.001) * (env1@1 <= 0.001); //env1 threshold crossing
			th2 = (env1c > 0.001) * (env1c@1 <= 0.001); //env1c threshold crossing
			nsamp1 = nsamp : ba.sAndH(th1);
			nsamp2 = nsamp : ba.sAndH(th2);
			doubleDelay =	_ <: (de.delay(nmax, nsamp1), de.delay(nmax,nsamp2)) : (*(env1), *(env1c)) : + ;
		};
//
//A double overlapped delay with reinjection//
//
fdOverlappedDoubleDelay(nsamp, nmax, freq, fd) = (+ : overlappedDoubleDelay(nsamp, nmax, freq)) ~ (*(fd));
//
//--------------------------------------------------------------------------------------//
// SINUS ENVELOPE
//--------------------------------------------------------------------------------------//
//
tablesize = 1 << 16;
sinustable = os.sinwaveform(tablesize);
//
sinusEnvelop(phase) = s1 + d * (s2 - s1)
	with {
			zeroToOnePhase = phase : ma.decimal;
			myIndex = zeroToOnePhase * float(tablesize);
			i1 = int(myIndex);
			d = ma.decimal(myIndex);
			i2 = (i1+1) % int(tablesize);
			s1 = rdtable(tablesize, sinustable, i1);
			s2 = rdtable(tablesize, sinustable, i2);
};
//
//--------------------------------------------------------------------------------------//
// CONVERSION DB=>LINEAR
//--------------------------------------------------------------------------------------//
dbcontrol = _ <: ((_ > -127.0), ba.db2linear) : *;
//
//--------------------------------------------------------------------------------------//
//CONTROL PARAMETER: GAIN IN DB
//--------------------------------------------------------------------------------------//
dbtogain = si.smoo : dbcontrol;
//
//
process = delparset(5);
