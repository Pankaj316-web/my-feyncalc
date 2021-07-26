(* ::Package:: *)

 


(* ::Section:: *)
(*LeftRightPartialD*)


(* ::Text:: *)
(*`LeftRightPartialD[mu]` denotes $\overleftrightarrow {\partial }_{\mu }$, acting to the left and right.*)


(* ::Text:: *)
(*`ExplicitPartialD[LeftRightPartialD[\[Mu]]]` gives `1/2 (RightPartialD[\[Mu]] - LeftPartialD[\[Mu]])`.*)


(* ::Subsection:: *)
(*See also*)


(* ::Text:: *)
(*[ExplicitPartialD](ExplicitPartialD), [ExpandPartialD](ExpandPartialD), [FCPartialD](FCPartialD), [LeftPartialD](LeftPartialD), [LeftRightPartialD2](LeftRightPartialD2), [RightPartialD](RightPartialD).*)


(* ::Subsection:: *)
(*Examples*)


LeftRightPartialD[\[Mu]]
ExplicitPartialD[%]


LeftRightPartialD[\[Mu]] . QuantumField[A,LorentzIndex[\[Nu]]]
ExpandPartialD[%]


QuantumField[A,LorentzIndex[\[Mu]]] . LeftRightPartialD[\[Nu]] . QuantumField[A,LorentzIndex[\[Rho]]]
ExpandPartialD[%]
