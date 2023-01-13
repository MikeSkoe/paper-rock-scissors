type t = Rock | Paper | Scissors;

let getCoeff = (a, b) => switch (a, b) {
    | (Rock, Paper)
    | (Paper, Scissors)
    | (Scissors, Rock) => 1.
    | _ => 0.5
}

let toString = element => switch element {
    | Rock => "Rock"
    | Paper => "Paper"
    | Scissors => "Scissors"
}
