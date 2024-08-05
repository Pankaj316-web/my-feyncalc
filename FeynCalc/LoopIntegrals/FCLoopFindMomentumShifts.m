(* ::Package:: *)

(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: FCLoopFindMomentumShifts											*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 1990-2024 Rolf Mertig
	Copyright (C) 1997-2024 Frederik Orellana
	Copyright (C) 2014-2024 Vladyslav Shtabovenko
*)

(* :Summary:  	Finds loop momentum shifts									*)

(* ------------------------------------------------------------------------ *)

FCLoopFindMomentumShifts::usage =
"FCLoopFindMomentumShifts[source, target, {p1, p2, ...}] finds loop momentum
shifts that bring loop integrals or topologies in the list source to the form
specified in target. The integrals/topologies in intFrom and intTo are assumed
to be equivalent and their denominators must be properly ordered via
FCLoopToPakForm. Here the loop momenta p1, p2, ... belong to the source
topologies.

target must be provided as a list of FeynAmpDenominator objects, while intFrom
is a list of such lists.

It is also possible to invoke the function as
FCLoopFindMomentumShifts[{FCTopology[...], FCTopology[...]}, FCTopology[...]].

For topologies involving kinematic constraints some mappings may require
shifts not only in the loop but also in the external
momenta. Such shifts are disabled by default but can be activated by setting
the option Momentum to All.

Normally, FCLoopFindMomentumShifts will abort the evaluation if it fails to
find any suitable shifts. Setting the option
Abort to False will force the function to merely return an empty list in such
situations.";

FCLoopFindMomentumShifts::failmsg =
"Error! FCLoopFindMomentumShifts has encountered a fatal problem and must abort the computation. \
The problem reads: `1`";

FCLoopFindMomentumShifts::shifts =
"Error! FCLoopFindMomentumShifts has encountered a fatal problem and must abort the computation. \
The problem reads: Failed to find momentum shifts for one of the topologies.";

Begin["`Package`"]
End[]

Begin["`FCLoopFindMomentumShifts`Private`"]

fcflsVerbose::usage = "";
optMomentum::usage = "";
optAbort::usage = "";

Options[FCLoopFindMomentumShifts] = {
	Abort						-> True,
	FCI 						-> False,
	FCVerbose 					-> False,
	"Kinematics"				-> {},
	"TopologyNames"				-> {},
	InitialSubstitutions		-> {},
	Momentum					-> {}
};

FCLoopFindMomentumShifts[fromRaw:{__FCTopology}, toRaw_FCTopology/;!OptionQ[toRaw], opts:OptionsPattern[]] :=
	Block[{from,to,optKinematics},

		optKinematics = {#[[5]]&/@fromRaw, toRaw[[5]]};

		If[OptionValue[FCI],
			{from, to} = {fromRaw, toRaw},
			{from, to, optKinematics} = FCI[{fromRaw, toRaw, FRH[optKinematics]}]
		];

		If[	!FCLoopValidTopologyQ[from],
			Message[FCLoopFindMomentumShifts::failmsg, "The list of source topologie is incorrect."];
			Abort[]
		];

		If[	!FCLoopValidTopologyQ[to],
			Message[FCLoopFindMomentumShifts::failmsg, "The target topology is incorrect."];
			Abort[]
		];

		optMomentum = OptionValue[Momentum];


		If[	optMomentum===All,
			optMomentum = to[[4]]
		];


		FCLoopFindMomentumShifts[#[[2]]&/@from, to[[2]], to[[3]], Join[{FCI->True,Momentum->optMomentum,"Kinematics"->optKinematics,
			"TopologyNames"->{#[[1]]&/@from,to[[1]]}}, FilterRules[{opts}, Except[FCI|Momentum|"Kinematics"|"TopologyNames"]]]]
	];


FCLoopFindMomentumShifts[fromRaw_List/;FreeQ[fromRaw,FCTopology], toRaw_/;FreeQ[toRaw,FCTopology], lmoms_List, OptionsPattern[]] :=
	Block[	{from, to, res, time, shifts, optInitialSubstitutions, optKinematics, optTopologyNames},

		If[	OptionValue[FCVerbose] === False,
			fcflsVerbose = $VeryVerbose,
			If[MatchQ[OptionValue[FCVerbose], _Integer],
			fcflsVerbose = OptionValue[FCVerbose]];
		];

		optInitialSubstitutions = OptionValue[InitialSubstitutions];
		optKinematics 			= OptionValue["Kinematics"];
		optTopologyNames		= OptionValue["TopologyNames"];

		FCPrint[1, "FCLoopFindMomentumShifts: Entering.", FCDoControl -> fcflsVerbose];
		FCPrint[2, "FCLoopFindMomentumShifts: Kinematics:", optKinematics, " ", FCDoControl -> fcflsVerbose];



		If[	optTopologyNames==={},
			optTopologyNames = {ConstantArray["unnamedSourceTopo",Length[fromRaw]],"unnamedTargetTopo"}
		];

		If[optKinematics==={},
			optKinematics = {ConstantArray[{},Length[fromRaw]], {}}
		];

		If[OptionValue[FCI],
			{from, to, optInitialSubstitutions,optKinematics} = {fromRaw, toRaw, optInitialSubstitutions, FRH[optKinematics]},
			{from, to, optInitialSubstitutions,optKinematics} = FCI[{fromRaw, toRaw, optInitialSubstitutions, FRH[optKinematics]}]
		];

		optMomentum = OptionValue[Momentum];

		If[	optMomentum===All,
			Message[FCLoopFindMomentumShifts::failmsg,"The option Momentum can be set to All only when using FCTopology objects as input."];
			Abort[]
		];

		optAbort 	= OptionValue[Abort];


		FCPrint[3, "FCLoopFindMomentumShifts: List of source topologies: ", from, FCDoControl -> fcflsVerbose];
		FCPrint[3, "FCLoopFindMomentumShifts: Target topology: ", to, FCDoControl -> fcflsVerbose];
		FCPrint[2, "FCLoopFindMomentumShifts: Allowing kinematic shifts for the following external momenta: ", optMomentum, FCDoControl -> fcflsVerbose];


		{from, to, optInitialSubstitutions} = MomentumCombine[{from, to, optInitialSubstitutions},FCI->True, NumberQ -> False];

		{from, to} = {from, to} /. optInitialSubstitutions;

		FCPrint[3, "FCLoopFindMomentumShifts: Source topologies after InitialSubstitutions: ", from, FCDoControl -> fcflsVerbose];
		FCPrint[3, "FCLoopFindMomentumShifts: Target topology  after InitialSubstitutions: ", to, FCDoControl -> fcflsVerbose];

		If[	!MatchQ[from,{{__FeynAmpDenominator}..}],
			Message[FCLoopFindMomentumShifts::failmsg,"The list of source topologies is not a list of lists of FeynAmpDenominator objects."];
			Abort[]
		];

		If[	!MatchQ[to,{__FeynAmpDenominator}],
			Message[FCLoopFindMomentumShifts::failmsg,"The target topology is not a list of FeynAmpDenominator objects."];
			Abort[]
		];

		time=AbsoluteTime[];
		FCPrint[1, "FCLoopFindMomentumShifts: Finding loop momentum shifts.", FCDoControl -> fcflsVerbose];
		shifts = MapThread[findShifts[#1,to,lmoms,#2,optKinematics[[2]],#3,optTopologyNames[[2]]]&,{from, optKinematics[[1]], optTopologyNames[[1]]}];
		FCPrint[1, "FCLoopFindMomentumShifts: Done finding loop momentum shifts, timing: ", N[AbsoluteTime[] - time, 4], FCDoControl->fcflsVerbose];


		FCPrint[1, "FCLoopFindMomentumShifts: Leaving.", FCDoControl -> fcflsVerbose];
		FCPrint[3, "FCLoopFindMomentumShifts: Leaving with: ", shifts, FCDoControl -> fcflsVerbose];

		shifts
	];


findShifts[from:{__FeynAmpDenominator},to:{__FeynAmpDenominator}, lmomsRaw_List, fromKininematis_List, toKinematics_List, topoNamesFrom_, topoNamesTo_]:=
	Block[{lhs, rhs, eq, mark, vars, sol, res, lmoms, allmoms, extmoms, tmp, auxFrom, auxTo, mixedProps, rule},

		{lhs, rhs} = {from, to} /. {
			FeynAmpDenominator[PropagatorDenominator[Momentum[mom_, _], _]] :> mom,
			FeynAmpDenominator[PropagatorDenominator[Complex[0,(1|-1)] Momentum[mom_, _], _]] :> mom,
			FeynAmpDenominator[StandardPropagatorDenominator[Momentum[mom_, _], 0, _, {1, _}]] :> mom,
			FeynAmpDenominator[StandardPropagatorDenominator[Complex[0,(1|-1)] Momentum[mom_, _], 0, _, {1, _}]] :> mom,
			FeynAmpDenominator[CartesianPropagatorDenominator[CartesianMomentum[mom_, _], 0, _, {1, _}]] :> mom,
			FeynAmpDenominator[CartesianPropagatorDenominator[Complex[0,(1|-1)] CartesianMomentum[mom_, _], 0, _, {1, _}]] :> mom
		};

		FCPrint[3, "FCLoopFindMomentumShifts: Initial lhs: ", lhs, FCDoControl -> fcflsVerbose];
		FCPrint[3, "FCLoopFindMomentumShifts: Initial rhs: ", rhs, FCDoControl -> fcflsVerbose];

		FCPrint[3, "FCLoopFindMomentumShifts: Kinematics lhs: ", fromKininematis, ".", FCDoControl -> fcflsVerbose];
		FCPrint[3, "FCLoopFindMomentumShifts: Kinematics rhs: ", toKinematics, ".", FCDoControl -> fcflsVerbose];

		tmp = Transpose[{lhs, rhs}];
		mixedProps = Union[Cases[tmp, FeynAmpDenominator[(StandardPropagatorDenominator|CartesianPropagatorDenominator)[a_ /; a =!= 0, b_ /; b =!= 0, ___]], Infinity]];

		(* Remove all propagators where we failed to extract the momentum flow *)
		tmp = SelectFree[tmp,FeynAmpDenominator];

		If[	mixedProps=!={},
			FCPrint[0, "FCLoopFindMomentumShifts: ", FCStyle["The topologies contain following mixed quadratic-eikonal propagators that complicate the determination of the shifts: " , {Darker[Yellow,0.55], Bold}],
					mixedProps,  FCDoControl -> fcflsVerbose];
			FCPrint[0, "FCLoopFindMomentumShifts: ", FCStyle["You can try to trade them for purely quadratic propagators using FCLoopReplaceQuadraticEikonalPropagators." , {Darker[Yellow,0.55], Bold}],
					FCDoControl -> fcflsVerbose];
		];

		If[	tmp==={},
			Message[FCLoopFindMomentumShifts::shifts];
			FCPrint[0, "FCLoopFindMomentumShifts: ", FCStyle["Failed to derive the momentum shifts between topologies " <>
					ToString[topoNamesFrom] <> " and " <> ToString[topoNamesTo] <> " due to the presence of nonquadratic propagators.", {Darker[Yellow,0.55], Bold}],
					FCDoControl -> fcflsVerbose];

			If[optAbort,
				Abort[],
				Return[{}]
			]
		];

		{lhs, rhs} = Transpose[tmp];

		FCPrint[3, "FCLoopFindMomentumShifts: Preliminary lhs: ", lhs, FCDoControl -> fcflsVerbose];
		FCPrint[3, "FCLoopFindMomentumShifts: Preliminary rhs: ", rhs, FCDoControl -> fcflsVerbose];

		If[	!FreeQ[{lhs,rhs},FeynAmpDenominator],
			Message[FCLoopFindMomentumShifts::failmsg, "Failed to determine the momentum flow in the propagator(s) " <>
				ToString[Cases2[{lhs,rhs},FeynAmpDenominator],InputForm]];
			Abort[]
		];

		lmoms = Select[lmomsRaw,!FreeQ[lhs,#]&];
		extmoms = Select[optMomentum,!FreeQ[lhs,#]&];
		allmoms = Join[lmoms,extmoms];
		vars = mark/@(allmoms);
		lhs = lhs /. Thread[Rule[allmoms,vars]];

		FCPrint[3, "FCLoopFindMomentumShifts: Final lhs: ", lhs, FCDoControl -> fcflsVerbose];
		FCPrint[3, "FCLoopFindMomentumShifts: Final rhs: ", rhs, FCDoControl -> fcflsVerbose];
		FCPrint[3, "FCLoopFindMomentumShifts: Variables to solve for: ", vars, FCDoControl -> fcflsVerbose];



		eq = Thread[Equal[lhs^2,rhs^2]];

		sol = Solve[eq,vars];

		FCPrint[3, "FCLoopFindMomentumShifts: Possible shifts: ", sol, FCDoControl -> fcflsVerbose];

		If[	sol==={},
			Message[FCLoopFindMomentumShifts::shifts];
			FCPrint[0, "FCLoopFindMomentumShifts: ", FCStyle["Failed to derive the momentum shifts between topologies " <>
					ToString[topoNamesFrom] <> " and " <> ToString[topoNamesTo] <>
					". This can be due to the presence of nonquadratic propagators or because shifts in external momenta are also necessary.", {Darker[Yellow,0.55], Bold}],
					FCDoControl -> fcflsVerbose];
			If[optAbort,
				Abort[],
				Return[{}]
			]
		];

		(*We need to pick a solution that doesn't mix external momenta into loop momenta*)



		If[	optMomentum=!={},
			sol = Map[	If[FreeQ2[(mark/@extmoms)/.#, lmoms],
					#,
					Unevaluated[Sequence[]]
					]&,	sol
			];
		FCPrint[3, "FCLoopFindMomentumShifts: Remaining shifts: ", sol, FCDoControl -> fcflsVerbose],

			If[	sol==={},
				Message[FCLoopFindMomentumShifts::shifts];
				If[	optAbort,
					Abort[],
					Return[{}]
				]
			];

		];



		(*
			In the case of multiple solutions we should select the correct one. For example, in the case of
			[l^2][l1^2-m^2][l1.q2] and [(l2+q2)^2][l1^2-m^2][l1.q2], a set of shifts containing l1->-l2 is not
			acceptable.
		*)
		sol = Map[If[
			auxFrom = FeynAmpDenominatorExplicit[(from /. #),FCI->True] /. fromKininematis;
			auxTo = FeynAmpDenominatorExplicit[to,FCI->True] /. toKinematics;
			MatchQ[Together[auxFrom-auxTo],{0..}],
			#,
			Unevaluated[Sequence[]]
		]&, sol/. mark -> Identity];

		FCPrint[3, "FCLoopFindMomentumShifts: Valid shifts: ", sol, FCDoControl -> fcflsVerbose];

		(*Remove trivial rules of the type k1->k1*)
		sol = sol /. Rule->rule/. rule[a_,a_]:> Unevaluated[Sequence[]]/.rule->Rule;

		If[	sol==={},
			Message[FCLoopFindMomentumShifts::shifts];
			FCPrint[0, "FCLoopFindMomentumShifts: ", FCStyle["Failed to derive the momentum shifts between topologies " <>
					ToString[topoNamesFrom] <> " and " <> ToString[topoNamesTo] <>
					". This can be due to the presence of nonquadratic propagators or because shifts in external momenta are also necessary.", {Darker[Yellow,0.55], Bold}],
					FCDoControl -> fcflsVerbose];
			If[optAbort,
				Abort[],
				Return[{}]
			]
		];

		res = First[SortBy[sol, {Length, LeafCount}]];

		res

	]/; Length[from]===Length[to];


findShifts[from:{__FeynAmpDenominator},to:{__FeynAmpDenominator}, _List]:=
	{}/; Length[from]=!=Length[to];

FCPrint[1,"FCLoopFindMomentumShifts.m loaded."];
End[]
