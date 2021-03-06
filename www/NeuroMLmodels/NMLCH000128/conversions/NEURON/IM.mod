TITLE Mod file for component: Component(id=IM type=ionChannelHH)

COMMENT

    This NEURON file has been generated by org.neuroml.export (see https://github.com/NeuroML/org.neuroml.export)
         org.neuroml.export  v1.5.3
         org.neuroml.model   v1.5.3
         jLEMS               v0.9.9.0

ENDCOMMENT

NEURON {
    SUFFIX IM
    USEION k READ ek WRITE ik VALENCE 1 ? Assuming valence = 1; TODO check this!!
    
    RANGE gion                           
    RANGE gmax                              : Will be changed when ion channel mechanism placed on cell!
    RANGE conductance                       : parameter
    
    RANGE g                                 : exposure
    
    RANGE fopen                             : exposure
    RANGE p_instances                       : parameter
    
    RANGE p_tau                             : exposure
    
    RANGE p_inf                             : exposure
    
    RANGE p_rateScale                       : exposure
    
    RANGE p_fcond                           : exposure
    RANGE p_timeCourse_TIME_SCALE           : parameter
    RANGE p_timeCourse_VOLT_SCALE           : parameter
    RANGE p_timeCourse_tmax                 : parameter
    
    RANGE p_timeCourse_t                    : exposure
    RANGE p_steadyState_TIME_SCALE          : parameter
    RANGE p_steadyState_VOLT_SCALE          : parameter
    
    RANGE p_steadyState_x                   : exposure
    RANGE p_timeCourse_V                    : derived variable
    RANGE p_steadyState_V                   : derived variable
    RANGE p_tauUnscaled                     : derived variable
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
    
    conductance = 1.0E-5 (uS)
    p_instances = 1 
    p_timeCourse_TIME_SCALE = 1 (ms)
    p_timeCourse_VOLT_SCALE = 1 (mV)
    p_timeCourse_tmax = 1000 
    p_steadyState_TIME_SCALE = 1 (ms)
    p_steadyState_VOLT_SCALE = 1 (mV)
}

ASSIGNED {
    
    gion   (S/cm2)                          : Transient conductance density of the channel? Standard Assigned variables with ionChannel
    v (mV)
    celsius (degC)
    temperature (K)
    ek (mV)
    ik (mA/cm2)
    
    
    p_timeCourse_V                         : derived variable
    
    p_timeCourse_t (ms)                    : derived variable
    
    p_steadyState_V                        : derived variable
    
    p_steadyState_x                        : derived variable
    
    p_rateScale                            : derived variable
    
    p_fcond                                : derived variable
    
    p_inf                                  : derived variable
    
    p_tauUnscaled (ms)                     : derived variable
    
    p_tau (ms)                             : derived variable
    
    conductanceScale                       : derived variable
    
    fopen0                                 : derived variable
    
    fopen                                  : derived variable
    
    g (uS)                                 : derived variable
    rate_p_q (/ms)
    
}

STATE {
    p_q  
    
}

INITIAL {
    temperature = celsius + 273.15
    
    rates()
    rates() ? To ensure correct initialisation.
    
    p_q = p_inf
    
}

BREAKPOINT {
    
    SOLVE states METHOD cnexp
    
    ? DerivedVariable is based on path: conductanceScaling[*]/factor, on: Component(id=IM type=ionChannelHH), from conductanceScaling; null
    ? Path not present in component, using factor: 1
    
    conductanceScale = 1 
    
    ? DerivedVariable is based on path: gates[*]/fcond, on: Component(id=IM type=ionChannelHH), from gates; Component(id=p type=gateHHtauInf)
    ? multiply applied to all instances of fcond in: <gates> ([Component(id=p type=gateHHtauInf)]))
    fopen0 = p_fcond ? path based, prefix = 
    
    fopen = conductanceScale  *  fopen0 ? evaluable
    g = conductance  *  fopen ? evaluable
    gion = gmax * fopen 
    
    ik = gion * (v - ek)
    
}

DERIVATIVE states {
    rates()
    p_q' = rate_p_q 
    
}

PROCEDURE rates() {
    
    p_timeCourse_V = v /  p_timeCourse_VOLT_SCALE ? evaluable
    p_timeCourse_t = ( p_timeCourse_tmax  / ( (3.3 * (exp (( p_timeCourse_V +35)/20))) + (exp (-1 * ( p_timeCourse_V +35) /20)))) *  p_timeCourse_TIME_SCALE ? evaluable
    p_steadyState_V = v /  p_steadyState_VOLT_SCALE ? evaluable
    p_steadyState_x = 1/(1+ (exp (-1 * ( p_steadyState_V +35)/10))) ? evaluable
    ? DerivedVariable is based on path: q10Settings[*]/q10, on: Component(id=p type=gateHHtauInf), from q10Settings; null
    ? Path not present in component, using factor: 1
    
    p_rateScale = 1 
    
    p_fcond = p_q ^ p_instances ? evaluable
    ? DerivedVariable is based on path: steadyState/x, on: Component(id=p type=gateHHtauInf), from steadyState; Component(id=null type=IM_p_inf_inf)
    p_inf = p_steadyState_x ? path based, prefix = p_
    
    ? DerivedVariable is based on path: timeCourse/t, on: Component(id=p type=gateHHtauInf), from timeCourse; Component(id=null type=IM_p_tau_tau)
    p_tauUnscaled = p_timeCourse_t ? path based, prefix = p_
    
    p_tau = p_tauUnscaled  /  p_rateScale ? evaluable
    
     
    
     
    
     
    
     
    
     
    
     
    
     
    
     
    
     
    
     
    
     
    
     
    rate_p_q = ( p_inf  -  p_q ) /  p_tau ? Note units of all quantities used here need to be consistent!
    
     
    
     
    
     
    
}

