 
(* ::Section:: *)
(*FCShowEpsilon*)
(* ::Text:: *)
(*`FCShowEpsilon[expr]` substitutes `SMP["Delta"]` with `1/Epsilon - EulerGamma + Log[4 Pi]`.*)


(* ::Subsection:: *)
(*See also*)


(* ::Text:: *)
(*[FCHideEpsilon](FCHideEpsilon).*)


(* ::Subsection:: *)
(*Examples*)


SMP["Delta"]
FCShowEpsilon[%]


SMP["Delta_UV"]
FCShowEpsilon[%]


SMP["Delta_IR"]
FCShowEpsilon[%]
