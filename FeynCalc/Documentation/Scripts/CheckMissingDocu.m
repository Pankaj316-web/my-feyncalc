(* ::Package:: *)

$FeynCalcStartupMessages=False;
<<FeynCalc`


fcSymbols=Names["FeynCalc`*"];
docFiles=FileBaseName/@FileNames["*.m",FileNameJoin[{$FeynCalcDirectory,"Documentation","Mathematica"}],Infinity];


mdFiles=FileNames["*.md",FileNameJoin[{$FeynCalcDirectory,"Documentation","Markdown"}],Infinity];
mdFilesImported=Import[#,"Text"]&/@mdFiles;
aux2=First[StringSplit[#,"\n"]]&/@mdFilesImported;
aux2=FileBaseName/@Extract[mdFiles,MapIndexed[If[StringFreeQ[#1,"#"],#2,Unevaluated[Sequence[]]]&,aux2]];
Print["Documentation pages missing titles:"];


Print[""]; Print[""];
Print["FeynCalc symbols missing documentation pages:"];
Print[StringRiffle[Complement[SelectFree[fcSymbols,{"FerSolve",
"FeynCalc","SharedObjects","FCLoopBasis","ToSymbol"}],docFiles],"\n"]];

Print[""]; Print[""];
Print["Documentation pages for nonexisting FeynCalc symbols:"];
Print[StringRiffle[SelectFree[Complement[docFiles,fcSymbols],"Vectors"],"\n"]];


in=Import[FileNameJoin[{$FeynCalcDirectory,"Documentation","Markdown","Extra","FeynCalc.md"}],"Text"];
str=StringCases[in,"- "~~Shortest[x__]~~" - "/;!StringFreeQ[x,"["] && StringFreeQ[x,"\n"] :>x];
overviewSymbols=SelectFree[StringReplace[Union[Flatten[StringCases[#,"["~~Shortest[x__]~~"]":>x]&/@StringSplit[str,","]]],"\\"->""],
{"Upper and lower indices","FeynArts sign conventions"}];


Print[""]; Print[""];
Print["FeynCalc symbols missing in the overview:"];
Print[StringRiffle[Complement[SelectFree[fcSymbols,{"FerSolve",
"FeynCalc","SharedObjects","FCLoopBasis","ToSymbol"}],overviewSymbols],"\n"]];


Print[""]; Print[""];
Print["Nonexisting FeynCalc symbols in the overview:"];
Print[StringRiffle[Complement[overviewSymbols,fcSymbols],"\n"]];



