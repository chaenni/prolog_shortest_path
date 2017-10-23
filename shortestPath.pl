edge(uster, zurich, 8).
edge(zurich, winterthur, 12).
edge(winterthur, frauenfeld, 10).
edge(zurich, schaffhausen, 30).
edge(schaffhausen, frauenfeld, 30).
/*edge(X, Y, Distance) :- edge(Y, X, Distance).*/

connection(X, Y, [Distance, [X, Y]]) :- edge(X, Y, Distance).
connection(X, Y, [Distance, [X | L]]) :- 
  edge(X, Z, Distance1),
  connection(Z, Y, [Distance2, L]),
  Distance is Distance1 + Distance2.

minConnection([[Distance1, Path1], [Distance2, Path2]], Min) :-
  Distance1 =< Distance2, 
  Min = [Distance1, Path1].

minConnection([[Distance1, Path1], [Distance2, Path2]], Min) :-
  Distance1 > Distance2, 
  Min = [Distance2, Path2].

minConnection([[Distance, Path] | T], [MinDistance, MinPath]) :-
  minConnection(T, [MinDistanceOld, _]), 
  Distance <= MinDistanceOld,
  MinDistance = Distance,
  MinPath = Path.

minConnection([[Distance, Path] | T], [MinDistance, MinPath]) :-
  minConnection(T, [MinDistanceOld, MinPathOld]), 
  Distance > MinDistanceOld,
  MinDistance = MinDistanceOld,
  MinPath = MinPathOld.

shortestConnection(X, Y, Shortest) :- 
  findall(Connection, connection(X, Y, Connection), Connections),
  minConnection(Connections, Shortest).

/* http://www.learnprolognow.org/lpnpage.php?pagetype=html&pageid=lpn-htmlse49 */