TITLE Mod file for component: Component(id=Kdrfast type=ionChannelHH)

COMMENT

    This NEURON file has been generated by org.neuroml.export (see https://github.com/NeuroML/org.neuroml.export)
         org.neuroml.export  v1.5.3
         org.neuroml.model   v1.5.3
         jLEMS               v0.9.9.0

ENDCOMMENT

NEURON {
    SUFFIX Kdrfast
    USEION k WRITE ik VALENCE 1 ? Assuming valence = 1; TODO check this!!
    
    RANGE gion                           
    RANGE gmax                              : Will be changed when ion channel mechanism placed on cell!
    RANGE conductance                       : parameter
    
    RANGE g                                 : exposure
    
    RANGE fopen                             : exposure
    RANGE n_instances                       : parameter
    
    RANGE n_alpha                           : exposure
    
    RANGE n_beta                            : exposure
    
    RANGE n_tau                             : exposure
    
    RANGE n_inf                             : exposure
    
    RANGE n_rateScale                       : exposure
    
    RANGE n_fcond                           : exposure
    RANGE n_forwardRate_rate                : parameter
    RANGE n_forwardRate_midpoint            : parameter
    RANGE n_forwardRate_scale               : parameter
    
    RANGE n_forwardRate_r                   : exposure
    RANGE n_reverseRate_TIME_SCALE          : parameter
    RANGE n_reverseRate_VOLT_SCALE          : parameter
    
    RANGE n_reverseRate_r                   : exposure
    RANGE n_q10Settings_q10Factor           : parameter
    RANGE n_q10Settings_experimentalTemp    : parameter
    RANGE n_q10Settings_TENDEGREES          : parameter
    
    RANGE n_q10Settings_q10                 : exposure
    RANGE n_forwardRate_x                   : derived variable
    RANGE n_reverseRate_V                   : derived variable
    RANGE conductanceScale                  : derived variable
    RANGE fopen0                            : derived variable
    
}

UNITS {
    
    (nA) = (nanoamp)
    (uA) = (microamp)
    (mA) = (milliamp)
    (A) = (amp)
    (mV) = (millivolt)
    (mS) = (millisiemens)
    (uS) = (microsiemens)
    (molar) = (1/liter)
    (kHz) = (kilohertz)
    (mM) = (millimolar)
    (um) = (micrometer)
    (umol) = (micromole)
    (S) = (siemens)
    
}

PARAMETER {
    
    gmax = 0  (S/cm2)                       : Will be changed when ion channel mechanism placed on cell!
    
    conductance = 1.0E-6 (uS)
    n_instances = 4 
    n_forwardRate_rate = 0.42000002 (kHz)
    n_forwardRate_midpoint = -18 (mV)
    n_forwardRate_scale = 6 (mV)
    n_reverseRate_TIME_SCALE = 1 (ms)
    n_reverseRate_VOLT_SCALE = 1 (mV)
    n_q10Settings_q10Factor = 3 
    n_q10Settings_experimentalTemp = 307.15 (K)
    n_q10Settings_TENDEGREES = 10 (K)
}

ASSIGNED {
    
    gion   (S/cm2)                          : Transient conductance density of the channel? Standard Assigned variables with ionChannel
    v (mV)
    celsius (degC)
    temperature (K)
    ek (mV)
    ik (mA/cm2)
    
    
    n_forwardRate_x                        : derived variable
    
    n_forwardRate_r (kHz)                  : conditional derived var...
    
    n_reverseRate_V                        : derived variable
    
    n_reverseRate_r (kHz)                  : derived variable
    
    n_q10Settings_q10                      : derived variable
    
    n_rateScale                            : derived variable
    
    n_alpha (kHz)                          : derived variable
    
    n_beta (kHz)                           : derived variable
    
    n_fcond                                : derived variable
    
    n_inf                                  : derived variable
    
    n_tau (ms)                             : derived variable
    
    conductanceScale                       : derived variable
    
    fopen0                                 : derived variable
    
    fopen                                  : derived variable
    
    g (uS)                                 : derived variable
    rate_n_q (/ms)
    
}

STATE {
    n_q  
    
}

INITIAL {
    ek = -90.0
    
    temperature = celsius + 273.15
    
    rates()
    rates() ? To ensure correct initialisation.
    
    n_q = n_inf
    
}

BREAKPOINT {
    
    SOLVE states METHOD cnexp
    
    ? DerivedVariable is based on path: conductanceScaling[*]/factor, on: Component(id=Kdrfast type=ionChannelHH), from conductanceScaling; null
    ? Path not present in component, using factor: 1
    
    conductanceScale = 1 
    
    ? DerivedVariable is based on path: gates[*]/fcond, on: Component(id=Kdrfast type=ionChannelHH), from gates; Component(id=n type=gateHHrates)
    ? multiply applied to all instances of fcond in: <gates> ([Component(id=n type=gateHHrates)]))
    fopen0 = n_fcond ? path based, prefix = 
    
    fopen = conductanceScale  *  fopen0 ? evaluable
    g = conductance  *  fopen ? evaluable
    gion = gmax * fopen 
    
    ik = gion * (v - ek)
    
}

DERIVATIVE states {
    rates()
    n_q' = rate_n_q 
    
}

PROCEDURE rates() {
    
    n_forwardRate_x = (v -  n_forwardRate_midpoint ) /  n_forwardRate_scale ? evaluable
    if (n_forwardRate_x  != 0)  { 
        n_forwardRate_r = n_forwardRate_rate  *  n_forwardRate_x  / (1 - exp(0 -  n_forwardRate_x )) ? evaluable cdv
    } else if (n_forwardRate_x  == 0)  { 
        n_forwardRate_r = n_forwardRate_rate ? evaluable cdv
    }
    
    n_reverseRate_V = v /  n_reverseRate_VOLT_SCALE ? evaluable
    n_reverseRate_r = ((0.264) / (exp(( n_reverseRate_V +43)/40))) /  n_reverseRate_TIME_SCALE ? evaluable
    n_q10Settings_q10 = n_q10Settings_q10Factor ^((temperature -  n_q10Settings_experimentalTemp )/ n_q10Settings_TENDEGREES ) ? evaluable
    ? DerivedVariable is based on path: q10Settings[*]/q10, on: Component(id=n type=gateHHrates), from q10Settings; Component(id=null type=q10ExpTemp)
    ? multiply applied to all instances of q10 in: <q10Settings> ([Component(id=null type=q10ExpTemp)]))
    n_rateScale = n_q10Settings_q10 ? path based, prefix = n_
    
    ? DerivedVariable is based on path: forwardRate/r, on: Component(id=n type=gateHHrates), from forwardRate; Component(id=null type=HHExpLinearRate)
    n_alpha = n_forwardRate_r ? path based, prefix = n_
    
    ? DerivedVariable is based on path: reverseRate/r, on: Component(id=n type=gateHHrates), from reverseRate; Component(id=null type=Bezaire_Kdrfast_betaq)
    n_beta = n_reverseRate_r ? path based, prefix = n_
    
    n_fcond = n_q ^ n_instances ? evaluable
    n_inf = n_alpha /( n_alpha + n_beta ) ? evaluable
    n_tau = 1/(( n_alpha + n_beta ) *  n_rateScale ) ? evaluable
    
     
    rate_n_q = ( n_inf  -  n_q ) /  n_tau ? Note units of all quantities used here need to be consistent!
    
     
    
     
    
     
    
     
    
}

