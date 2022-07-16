(* ::Package:: *)



(* :Title: PairContract														*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 1990-2022 Rolf Mertig
	Copyright (C) 1997-2022 Frederik Orellana
	Copyright (C) 2014-2022 Vladyslav Shtabovenko
*)

(* :Summary:	Local contraction rules										*)

(* ------------------------------------------------------------------------ *)

PairContract::usage =
"PairContract is like Pair, but with (local) contraction properties.";

CartesianPairContract::usage =
"CartesianPairContract is like CartesianPair, but with (local) contraction
properties.";

PairContract3::usage =
"PairContract3 is like Pair, but with local contraction properties among
PairContract3s.";

CartesianPairContract::failmsg =
"Error! CartesianPairContract has encountered a fatal problem and must abort the computation. \
The problem reads: `1`";

PairContract::failmsg =
"Error! PairContract has encountered a fatal problem and must abort the computation. \
The problem reads: `1`";

(* ------------------------------------------------------------------------ *)

Begin["`Package`"]

End[]

Begin["`PairContract`Private`"]

SetAttributes[CartesianPairContract,Orderless];

CartesianPairContract[0,_]:=
	0;

CartesianPairContract[CartesianIndex[x_, dim1_:3], CartesianIndex[x_, dim2_:3] ] :=
	dimEval[dim1,dim2]/; Head[dimEval[dim1,dim2]]=!=dimEval;

CartesianPairContract[
	(h1: CartesianIndex | CartesianMomentum)[x_, dim1_:3],
	(h2: CartesianIndex | CartesianMomentum)[y_, dim2_:3]
	]/;({dim1}=!={dim2}) :=
	CartesianPairContract[h1[x, dimEval[dim1,dim2]], h2[y, dimEval[dim1,dim2]]]/; Head[dimEval[dim1,dim2]]=!=dimEval;

CartesianPairContract/:
	CartesianPairContract[_CartesianIndex,x_]^2 :=
		CartesianPairContract[x,x];

CartesianPairContract /:
	CartesianPairContract[a_, b_CartesianIndex]^(n_ /; n > 2) :=
		(
		Message[CartesianPairContract::failmsg, "The expression " <> ToString[CartesianPair[a, b]^n, InputForm] <> " violates Einstein summation."];
		Abort[]
		) /; a =!= b;

(*here f could be anything (Dirac matrix, tensor function etc.) carrying a Cartesian index*)
CartesianPairContract/: CartesianPairContract[CartesianIndex[z_,dim___],(h:CartesianIndex|CartesianMomentum)[x_,dim___]] f_[a__] :=
	(f[a] /. CartesianIndex[z, ___]->h[x,dim]) /;(!FreeQ[f[a], CartesianIndex[z,___]]);

(* #################################################################### *)

SetAttributes[PairContract,Orderless];

PairContract[0,_]:=
	0;

PairContract[LorentzIndex[x_, dim1_:4], LorentzIndex[x_, dim2_:4] ] :=
	dimEval[dim1,dim2]/; Head[dimEval[dim1,dim2]]=!=dimEval;

PairContract[CartesianIndex[x_, dim1_:3], CartesianIndex[x_, dim2_:3] ] :=
	dimEval[dim1,dim2]* FeynCalc`Package`MetricS/; Head[dimEval[dim1,dim2]]=!=dimEval;

PairContract[
	(h1: LorentzIndex | Momentum | TemporalMomentum | ExplicitLorentzIndex)[x_, dim1_:4],
	(h2: LorentzIndex | Momentum | TemporalMomentum | ExplicitLorentzIndex)[y_, dim2_:4]
	]/;({dim1}=!={dim2}) :=
	PairContract[h1[x, dimEval[dim1,dim2]], h2[y, dimEval[dim1,dim2]]]/; Head[dimEval[dim1,dim2]]=!=dimEval;

PairContract[
	(h1: LorentzIndex | Momentum | TemporalMomentum | ExplicitLorentzIndex)[x_, dim1_:4],
	(h2: CartesianIndex | CartesianMomentum)[y_, dim2_:3]
	]/;({dim1}=!={dim2}) :=
	Block[{dims=dimEvalLorentzCartesian[dim1,dim2]},
		PairContract[h1[x, dims[[1]]], h2[y, dims[[2]]]]
	]/; Head[dimEvalLorentzCartesian[dim1,dim2]]=!=dimEvalLorentzCartesian;

PairContract[
	(h1: CartesianIndex | CartesianMomentum)[x_, dim1_:3],
	(h2: CartesianIndex | CartesianMomentum)[y_, dim2_:3]
	]/;({dim1}=!={dim2}) :=
	PairContract[h1[x, dimEval[dim1,dim2]], h2[y, dimEval[dim1,dim2]]]/; Head[dimEval[dim1,dim2]]=!=dimEval;

PairContract /:
	PairContract[_LorentzIndex,x_]^2 :=
		PairContract[x,x];

PairContract /:
	PairContract[a_, b_LorentzIndex]^(n_ /; n > 2) :=
		(
		Message[PairContract::failmsg, "The expression " <> ToString[Pair[a, b]^n, InputForm] <> " violates Einstein summation."];
		Abort[]
		) /; a =!= b;

(*here f could be anything (Dirac matrix, tensor function etc.) carrying a Lorentz index*)
PairContract/: PairContract[LorentzIndex[z_,dim___],(h:LorentzIndex|Momentum|ExplicitLorentzIndex)[x_,dim___]] f_[a__] :=
	(f[a] /. LorentzIndex[z, ___]->h[x,dim]) /;(!FreeQ[f[a], LorentzIndex[z,___]]);

PairContract/: PairContract[LorentzIndex[z_,dimL_:4],(h:CartesianIndex|CartesianMomentum)[x_,dimC_:3]] f_[a__] :=
	(f[a] /. LorentzIndex[z, ___]->h[x,dimC]) /;(!FreeQ[f[a], LorentzIndex[z,___]]) && MatchQ[{dimL,dimC},{4,3}|{_Symbol,_Symbol-1}|{_Symbol-4,_Symbol-4}];



(*	covers cases such as PairContract[Momentum[(a + b + c) + (-b - c)], Momentum[f]]
	or
	FCClearScalarProducts[];
	SP[p1, p2] = s2;
	SP[p1, p3] = s3;
	FCI[SP[p1, p2 + p3]] /. Pair -> PairContract
	(*s2+s3*)
 *)
PairContract[a_, b_]:=
	Block[{pairExpanded = FCUseCache[ExpandScalarProduct,{Pair[a,b]},{FCI->True}]},
		If[	FreeQ2[pairExpanded,{Pair,CartesianPair}] || Head[pairExpanded]=!=Plus,
			pairExpanded,
			Pair[a,b]
		]
	]/;FreeQ2[{a,b},{LorentzIndex,CartesianIndex}]


(* #################################################################### *)

(*
	The main difference between PairContract and PairContract3 is that the latter immediately expands all scalar products,
	while PairContract only does this for some special cases.
*)
SetAttributes[PairContract3,Orderless];

PairContract3[0,_]:=
	0;

PairContract3[LorentzIndex[x_, dim1_:4], LorentzIndex[x_, dim2_:4] ] :=
	dimEval[dim1,dim2]/; Head[dimEval[dim1,dim2]]=!=dimEval;

PairContract3[CartesianIndex[x_, dim1_:3], CartesianIndex[x_, dim2_:3] ] :=
	dimEval[dim1,dim2]* FeynCalc`Package`MetricS/; Head[dimEval[dim1,dim2]]=!=dimEval;

PairContract3[
	(h1: LorentzIndex | Momentum | TemporalMomentum | ExplicitLorentzIndex)[x_, dim1_:4],
	(h2: LorentzIndex | Momentum | TemporalMomentum | ExplicitLorentzIndex)[y_, dim2_:4]
	]/;({dim1}=!={dim2}) :=
	PairContract3[h1[x, dimEval[dim1,dim2]], h2[y, dimEval[dim1,dim2]]]/; Head[dimEval[dim1,dim2]]=!=dimEval;

PairContract3[
	(h1: LorentzIndex | Momentum | TemporalMomentum | ExplicitLorentzIndex)[x_, dim1_:4],
	(h2: CartesianIndex | CartesianMomentum)[y_, dim2_:3]
	]/;({dim1}=!={dim2}) :=
	Block[{dims=dimEvalLorentzCartesian[dim1,dim2]},
		PairContract3[h1[x, dims[[1]]], h2[y, dims[[2]]]]
	]/; Head[dimEvalLorentzCartesian[dim1,dim2]]=!=dimEvalLorentzCartesian;

PairContract3[
	(h1: CartesianIndex | CartesianMomentum)[x_, dim1_:3],
	(h2: CartesianIndex | CartesianMomentum)[y_, dim2_:3]
	]/;({dim1}=!={dim2}) :=
	PairContract3[h1[x, dimEval[dim1,dim2]], h2[y, dimEval[dim1,dim2]]]/; Head[dimEval[dim1,dim2]]=!=dimEval;


PairContract3 /:
	PairContract3[_LorentzIndex,x_]^2 :=
		PairContract3[x,x];

PairContract3 /:
	PairContract3[a_, b_LorentzIndex]^(n_ /; n > 2) :=
		(
		Message[PairContract::failmsg, "The expression " <> ToString[Pair[a, b]^n, InputForm] <> " violates Lorentz covariance!"];
		Abort[]
		) /; a =!= b;

(*here f could be anything (Dirac matrix, tensor function etc.) carrying a Lorentz index*)
PairContract3/: PairContract3[LorentzIndex[z_,dim___],(h:LorentzIndex|Momentum|ExplicitLorentzIndex)[x_,dim___]] f_[a__] :=
	(f[a] /. LorentzIndex[z, ___]->h[x,dim]) /;(!FreeQ[f[a], LorentzIndex[z,___]]);

PairContract3/: PairContract3[LorentzIndex[z_,dimL_:4],(h:CartesianIndex|CartesianMomentum)[x_,dimC_:3]] f_[a__] :=
	(f[a] /. LorentzIndex[z, ___]->h[x,dimC]) /;(!FreeQ[f[a], LorentzIndex[z,___]]) && MatchQ[{dimL,dimC},{4,3}|{_Symbol,_Symbol-1}|{_Symbol-4,_Symbol-4}];


PairContract3[a_, b_]:=
	FCUseCache[ExpandScalarProduct,{Pair[a,b]},{FCI->True}]/;FreeQ2[{a,b},{LorentzIndex,CartesianIndex}];

(* #################################################################### *)

(*Obviously memoization safe*)
SetAttributes[dimEval, Orderless];

(*{4,4}, {D,D}, {D-4,D-4} *)
dimEval[d_,d_]:=
	MemSet[dimEval[d,d],
		d
	];

(* {D,4} -> 4*)
dimEval[d_Symbol,4]:=
	MemSet[dimEval[d,4],
		4
	];

(* {D-4,4} -> 0*)
dimEval[d_Symbol-4,4]:=
	MemSet[dimEval[d-4,4],
		0
	];

(* {D-4,D} -> D-4*)
dimEval[d_Symbol-4,d_Symbol]:=
	MemSet[dimEval[d-4,d],
		d-4
	];

(* {D-1,3} -> 3*)
dimEval[d_Symbol-1,3]:=
	MemSet[dimEval[d-1,3],
		3
	];

(* {D-4,3} -> 0*)
dimEval[d_Symbol-4,3]:=
	MemSet[dimEval[d-4,3],
		0
	];

(* {D-4,D-1} -> D-4*)
dimEval[d_Symbol-4,d_Symbol-1]:=
	MemSet[dimEval[d-4,d-1],
		d-4
	];

(* #################################################################### *)

(*Obviously memoization safe*)
SetAttributes[dimEvalLorentzCartesian, Orderless];

(*The function only returns something if a simplification is possible*)

(* {4, D-1} -> {4, 3}*)
dimEvalLorentzCartesian[4, d_Symbol-1]:=
	MemSet[dimEvalLorentzCartesian[4, d-1],
		{4,3}
	];

(* {4, D-4} -> {0, 0}*)
dimEvalLorentzCartesian[4, d_Symbol-4]:=
	MemSet[dimEvalLorentzCartesian[4, d-4],
		{0,0}
	];

(* {D, D-4} -> {D-4, D-4}*)
dimEvalLorentzCartesian[d_Symbol, d_Symbol-4]:=
	MemSet[dimEvalLorentzCartesian[d, d-4],
		{d-4,d-4}
	];

(* {D, 3} -> {4, 3}*)
dimEvalLorentzCartesian[d_Symbol, 3]:=
	MemSet[dimEvalLorentzCartesian[d, 3],
		{4,3}
	];

(* {D-4,3} -> {0,0}*)
dimEvalLorentzCartesian[d_Symbol-4,3]:=
	MemSet[dimEvalLorentzCartesian[d-4,3],
		{0,0}
	];

(* {D-4,D-1} -> {D-4,D-4}*)
dimEvalLorentzCartesian[d_Symbol-4,d_Symbol-1]:=
	MemSet[dimEvalLorentzCartesian[d-4,d-1],
		{d-4,d-4}
	];

FCPrint[1,"PairContract.m loaded."];
End[]
