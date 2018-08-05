TITLE Mod file for component: Component(id=izIntegrator type=generalizedIzhikevichCell)

COMMENT

    This NEURON file has been generated by org.neuroml.export (see https://github.com/NeuroML/org.neuroml.export)
         org.neuroml.export  v1.5.3
         org.neuroml.model   v1.5.3
         jLEMS               v0.9.9.0

ENDCOMMENT

NEURON {
    POINT_PROCESS izIntegrator
    
    
    NONSPECIFIC_CURRENT i                    : To ensure v of section follows v_I
    RANGE v0                                : parameter
    RANGE a                                 : parameter
    RANGE b                                 : parameter
    RANGE c                                 : parameter
    RANGE d                                 : parameter
    RANGE X                                 : parameter
    RANGE Y                                 : parameter
    RANGE Z                                 : parameter
    RANGE thresh                            : parameter
    RANGE MSEC                              : parameter
    RANGE MVOLT                             : parameter
    
    RANGE copy_v                           : copy of v on section
    RANGE ISyn                              : derived variable
    
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
    
    v0 = -60 (mV)
    a = 0.02 
    b = -0.1 
    c = -55 
    d = 6 
    X = 0.04 
    Y = 4.1 
    Z = 108 
    thresh = 30 (mV)
    MSEC = 1 (ms)
    MVOLT = 1 (mV)
}

ASSIGNED {
    v (mV)
    i (mA/cm2)
    
    copy_v (mV)
    
    v_I (nA) 
    
    ISyn                                   : derived variable
    rate_v (mV/ms)
    rate_U (/ms)
    
}

STATE {
    U  
    
}

INITIAL {
    rates()
    rates() ? To ensure correct initialisation.
    
    net_send(0, 1) : go to NET_RECEIVE block, flag 1, for initial state
    
    U = v0  *  b  /  MVOLT
    
}

BREAKPOINT {
    
    SOLVE states METHOD cnexp
    
    
    copy_v = v
    i = v_I
}

NET_RECEIVE(flag) {
    
    if (flag == 1) { : Setting watch for top level OnCondition...
        WATCH (v >  thresh) 1000
    }
    if (flag == 1000) {
    
        v = c  *  MVOLT
    
        v_I = 0 : Setting rate of change of v to 0
    
        U = U  +  d
    }
    if (flag == 1) { : Set initial states
    
        v = v0
    }
    
}

DERIVATIVE states {
    rates()
    U' = rate_U 
    
}

PROCEDURE rates() {
    
    ? DerivedVariable is based on path: synapses[*]/I, on: Component(id=izIntegrator type=generalizedIzhikevichCell), from synapses; null
    ISyn = 0 ? Was: synapses[*]_I but insertion of currents from external attachments not yet supported ? path based, prefix = 
    
    rate_v = (  X   * v^2 /  MVOLT  +  Y  * v + (  Z   -  U  +   ISyn  ) *   MVOLT  )/  MSEC ? Note units of all quantities used here need to be consistent!
    rate_U = a  * (  b   * v /  MVOLT  -   U  ) /  MSEC ? Note units of all quantities used here need to be consistent!
    
    v_I = -1 * rate_v
     
    
}

