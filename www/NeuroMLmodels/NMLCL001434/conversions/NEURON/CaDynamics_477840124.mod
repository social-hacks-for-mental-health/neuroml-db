TITLE Mod file for component: Component(id=CaDynamics_477840124 type=concentrationModelHayEtAl)

COMMENT

    This NEURON file has been generated by org.neuroml.export (see https://github.com/NeuroML/org.neuroml.export)
         org.neuroml.export  v1.5.3
         org.neuroml.model   v1.5.3
         jLEMS               v0.9.9.0

ENDCOMMENT

NEURON {
    SUFFIX CaDynamics_477840124
    USEION ca READ cai, cao, ica WRITE cai VALENCE 2
    RANGE cai
    RANGE cao
    GLOBAL initialConcentration
    GLOBAL initialExtConcentration
    RANGE gamma                             : parameter
    RANGE minCai                            : parameter
    RANGE decay                             : parameter
    RANGE depth                             : parameter
    RANGE Faraday                           : parameter
    RANGE AREA_SCALE                        : parameter
    RANGE LENGTH_SCALE                      : parameter
    RANGE currDensCa                        : derived variable
    
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
    surfaceArea (um2)
    iCa (nA)
    initialConcentration (mM)
    initialExtConcentration (mM)
    
    gamma = 0.0018666933 
    minCai = 1.0E-4 (mM)
    decay = 435.92764 (ms)
    depth = 0.1 (um)
    Faraday = 0.0964853 (C / umol)
    AREA_SCALE = 1.0E12 (um2)
    LENGTH_SCALE = 1000000 (um)
}

ASSIGNED {
    cai (mM)
    cao (mM)
    ica (mA/cm2)
    diam (um)
    area (um2)
    
    currDensCa (nA / um2)                  : derived variable
    rate_concentration (mM/ms)
    
}

STATE {
    concentration (mM) 
    extConcentration (mM) 
    
}

INITIAL {
    initialConcentration = cai
    initialExtConcentration = cao
    rates()
    rates() ? To ensure correct initialisation.
    
    concentration = initialConcentration
    
    extConcentration = initialExtConcentration
    
}

BREAKPOINT {
    
    SOLVE states METHOD cnexp
    
    
}

DERIVATIVE states {
    rates()
    concentration' = rate_concentration
    cai = concentration 
    
}

PROCEDURE rates() {
    
    surfaceArea = area   : surfaceArea has units (um2), area (built in to NEURON) is in um^2...
    
    iCa = -1 * (0.01) * ica * surfaceArea :   iCa has units (nA) ; ica (built in to NEURON) has units (mA/cm2)...
    
    currDensCa = iCa / surfaceArea ? evaluable
    rate_concentration = (  currDensCa  *  gamma  /(2*  Faraday  *  depth  )) - ((  concentration   -   minCai  ) /   decay  ) ? Note units of all quantities used here need to be consistent!
    
     
    
}

