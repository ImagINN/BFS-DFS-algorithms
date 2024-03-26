import 'package:odev1_gokhan_sal/action.dart';
import 'package:odev1_gokhan_sal/coordinate.dart';
import 'package:odev1_gokhan_sal/node.dart';
import 'package:odev1_gokhan_sal/problem.dart';
import 'package:odev1_gokhan_sal/queue.dart';
import 'package:odev1_gokhan_sal/stack.dart';
import 'package:odev1_gokhan_sal/state.dart';

void main() {
  List<List<State>> grid = List<List<State>>.generate(
      10,
      (i) => List<State>.generate(10, (index) => State(Coordinate(i, index), 1),
          growable: false),
      growable: false);
  grid[2][0].color = 0;
  grid[1][1].color = 0;
  grid[2][1].color = 0;
  grid[4][1].color = 0;
  grid[8][1].color = 0;
  grid[5][2].color = 0;
  grid[7][2].color = 0;
  grid[6][3].color = 0;
  grid[2][4].color = 0;
  grid[2][5].color = 0;
  grid[8][5].color = 0;
  grid[1][6].color = 0;
  grid[2][6].color = 0;
  grid[3][6].color = 0;
  grid[7][6].color = 0;
  grid[9][6].color = 0;
  grid[5][7].color = 0;
  grid[7][7].color = 0;
  grid[0][8].color = 0;
  grid[6][8].color = 0;
  grid[9][8].color = 0;
  grid[5][9].color = 0;
  //Görseldeki 10x10 ızgara grafiği elle oluşturuyoruz.

  Problem problem = Problem(10, 10, Coordinate(1, 7), Coordinate(6, 2),
      grid); // Görseldeki başlangıç ve amaç durumlarına göre problemi oluşturuyoruz.

  graphSearchBFS(
      problem); // Toplam derinliği, toplam maliyeti ve eylemlerin Başlangıç durumundan Amaç durumuna kadar olan sıralı listesini yazdıracak.
  print(
      '-------------------------------------------------------------------------------------------------------');
  graphSearchDFS(
      problem); // Eylem listesi -> [[0,1], [1,1], ...., [0,-1]] şeklinde listeyi yazdması yeterli.
}

List<Action> graphSearchBFS(Problem problem) {
  List<State> closed = [];
  Queue<Node> open = Queue();
  List<Action> path = [];

  List<Action> actions = [
    Action(0, 1, 1), // Aşağı
    Action(0, -1, 1), // Yukarı
    Action(1, 0, 1), // Sağa
    Action(-1, 0, 1), // Sola
  ];

  open.push(Node.initState(problem.start, Action(0, 0, 0),
      problem.grid[problem.start.x][problem.start.y]));

  while (true) {
    if (open.length() == 0) {
      print('Failure');
      return [];
    }
    Node n = open.pop();
    if (n.state.coor.x == problem.goal.x && n.state.coor.y == problem.goal.y) {
      getPath(path, n);
      print('Depth: ${n.depth} | Cost: ${n.cost * 100} | Path: $path');
      return path;
    }
    closed.add(n.state);
    List<Node> children = expand(n, problem, actions);
    for (Node child in children) {
      if (!closed.contains(child.state)) {
        open.push(child);
      }
    }
  }
}

List<Action> graphSearchDFS(Problem problem) {
  List<State> closed = [];
  Stack<Node> open = Stack();
  List<Action> path = [];
  open.push(Node.initState(problem.start, Action(0, 0, 0),
      problem.grid[problem.start.x][problem.start.y]));

  List<Action> actions = [
    Action(0, 1, 1), // Aşağı
    Action(0, -1, 1), // Yukarı
    Action(1, 0, 1), // Sağa
    Action(-1, 0, 1), // Sola
  ];

  while (true) {
    if (open.length() == 0) {
      print('Failure');
      return [];
    }
    Node n = open.pop();
    if (n.state.coor.x == problem.goal.x && n.state.coor.y == problem.goal.y) {
      getPath(path, n);
      print('Depth: ${n.depth} | Cost: ${n.cost * 100} | Path: $path');
      return path;
    }
    closed.add(n.state);
    List<Node> children = expand(n, problem, actions);
    for (Node child in children) {
      if (!closed.contains(child.state)) {
        open.push(child);
      }
    }
  }
}

List<Node> expand(Node n, Problem p, List<Action> actions) {
  List<Node> children = [];
  for (Action a in actions) {
    int x = n.coor.x + a.x;
    int y = n.coor.y + a.y;
    if (x >= 0 && x < p.h && y >= 0 && y < p.w) {
      State s = p.grid[x][y];
      if (s.color != 0) {
        Node child = Node(Coordinate(x, y), a, n, s);
        children.add(child);
      }
    }
  }
  return children;
}

void getPath(List<Action> path, Node n) {
  // Burayı doldurun
  // Girilen çözüm düğümü için, ilk düğüme ulaşana kadar ebeveyn düğümleri ziyaret edip
  // Ziyaret edilen düğümlerdeki Action öğesini path listesine ekleyecek.
  // Recursive yazmak daha kolay, içine girilen path listesini sonuç olarak yazdırabilirsiniz.

  if (n.parent != null) {
    path.add(n.action);
    getPath(path, n.parent);
  }
}
