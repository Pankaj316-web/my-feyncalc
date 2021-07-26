(* ::Package:: *)

(* ::Section:: *)
(*SIS*)


(* ::Text:: *)
(*`SIS[p]` can be used as input for $3$-dimensional $\sigma^{\mu } p_{\mu }$ with 4-dimensional Lorentz vector $p$ and is transformed into `PauliSigma[Momentum[p]]` by FeynCalcInternal.*)


(* ::Subsection:: *)
(*See also*)


(* ::Text:: *)
(*[PauliSigma](PauliSigma), [SISD](SISD).*)


(* ::Subsection:: *)
(*Examples*)


SIS[p]


SIS[p]//FCI//StandardForm


SIS[p,q,r,s]


SIS[p,q,r,s]//StandardForm


SIS[q] . (SIS[p]+m) . SIS[q]
