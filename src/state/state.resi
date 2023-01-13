type action =
  | UpdateLeft(Choosing.move)
  | UpdateRight(Choosing.move)
  | ConfirmLeft
  | ConfirmRight

type state = {
  left: Player.t,
  right: Player.t,
  choosing: Choosing.t,
}

let reduce: (state, action) => state

let empty: state

module Select: {
  let left: state => Player.t
  let right: state => Player.t
  let choosing: state => Choosing.t
}
