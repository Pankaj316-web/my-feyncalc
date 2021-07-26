 
(* ::Section:: *)
(*D0 *)
(* ::Text:: *)
(*`D0[p10, p12, p23, p30, p20, p13, m1^2, m2^2, m3^2, m4^2 ]` is the Passarino-Veltman $D_0$ function. The convention for the arguments is that if the denominator of the integrand has the form $([q^2-m1^2] [(q+p1)^2-m2^2] [(q+p2)^2-m3^2] [(q+p3)^2-m4^2])$, the first six arguments of `D0` are the scalar products $p10 = p1^2$, $p12 = (p1-p2)^2$, $p23 = (p2-p3)^2$, $p30 = p3^2$, $p20 = p2^2$, $p13 = (p1-p3)^2$.*)


(* ::Subsection:: *)
(*See also*)
(* ::Text:: *)
(*[B0](B0), [C0](C0), [PaVe](PaVe), [PaVeOrder](PaVeOrder).*)



(* ::Subsection:: *)
(*Examples*)


D0[p10,p12,p23,p30,p20,p13,m1^2,m2^2,m3^2,m4^2]


PaVeOrder[D0[p10,p12,p23,p30,p20,p13,m1^2,m2^2,m3^2,m4^2],PaVeOrderList->{p13,p20}]


PaVeOrder[%]
