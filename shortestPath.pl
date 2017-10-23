edge(uster, zurich, 8).
edge(zurich, winterthur, 12).
edge(winterthur, frauenfeld, 10).
edge(zurich, schaffhausen, 30).
edge(schaffhausen, frauenfeld, 30).

accReverse([],L,L).
accReverse([H|T],Acc,Rev):-
    accReverse(T,[H|Acc],Rev).
reverse(L1,L2):- accReverse(L1,[],L2).

connection(From, To, (Distance, [From, To])) :- edge(From, To, Distance).
connection(From, To, (Distance, [From | Stations])) :- 
  edge(From, Intermediate, Distance1),
  connection(Intermediate, To, (Distance2, Stations)),
  Distance is Distance1 + Distance2.

findConnection(From, To, Result) :- connection(From, To, Result).
findConnection(From, To, (Distance, StationsReversed)) :-
  connection(To, From, (Distance, Stations)),
  reverse(Stations, StationsReversed).

minConnection([(Distance1, Path1), (Distance2, Path2)], Min) :-
  Distance1 =< Distance2, 
  Min = (Distance1, Path1).
minConnection([(Distance1, Path1), (Distance2, Path2)], Min) :-
  Distance1 > Distance2, 
  Min = (Distance2, Path2).
minConnection([(Distance, Path) | T], (MinDistance, MinPath)) :-
  minConnection(T, (MinDistanceOld, _)), 
  Distance =< MinDistanceOld,
  MinDistance = Distance,
  MinPath = Path.
minConnection([(Distance, Path) | T], (MinDistance, MinPath)) :-
  minConnection(T, (MinDistanceOld, MinPathOld)), 
  Distance > MinDistanceOld,
  MinDistance = MinDistanceOld,
  MinPath = MinPathOld.

shortestConnection(From, To, Shortest) :- 
  findall(Connection, findConnection(From, To, Connection), AllConnections),
  minConnection(AllConnections, Shortest).
