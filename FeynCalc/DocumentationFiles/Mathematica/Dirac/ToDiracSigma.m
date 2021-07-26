 
(* ::Section:: *)
(*ToDiracSigma*)
(* ::Text:: *)
(*`ToDiracSigma[exp, x, y]` substitutes the neighboring Dirac matrices $x$ and $y$ by `DiracSigma` and the metric tensor.*)


(* ::Subsection:: *)
(*See also*)
(* ::Text:: *)
(*[DiracGamma](DiracGamma), [DiracSigma](DiracSigma), [DiracSigmaExplicit](DiracSigmaExplicit).*)



(* ::Subsection:: *)
(*Examples*)



GA[\[Mu],\[Nu]]
ToDiracSigma[%,GA[\[Mu]],GA[\[Nu]]]


GA[\[Mu],\[Nu],\[Alpha],\[Beta],\[Rho],\[Sigma]]
ToDiracSigma[%,GA[\[Alpha]],GA[\[Beta]]]
