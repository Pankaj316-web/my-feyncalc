 
(* ::Section:: *)
(*Trick*)
(* ::Text:: *)
(*`Trick[exp]` performs several basic simplifications without expansion. `Trick[exp]` uses `Contract`, `DotSimplify` and `SUNDeltaContract`.*)


(* ::Subsection:: *)
(*See also*)
(* ::Text:: *)
(*[Calc](Calc), [Contract](Contract), [DiracTrick](DiracTrick), [DotSimplify](DotSimplify), [DiracTrick](DiracTrick).*)



(* ::Subsection:: *)
(*Examples*)
(* ::Text:: *)
(*This calculates $g^{mu  nu }gamma _{mu }$and $g_{nu }^{nu }$ in D dimensions.*)


Trick[{GA[\[Mu]] MT[\[Mu],\[Nu]], MTD[\[Nu],\[Nu]]}]

FV[p+r,\[Mu]] MT[\[Mu],\[Nu]] FV[q-p,\[Nu]]

Trick[%]

Trick[c.b.a . GA[d].GA[e]]

%//FCE//StandardForm
