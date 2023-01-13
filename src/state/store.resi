let store: Remporium.store<
  State.state,
  State.action,
>

module Store: {
  let context: React.Context.t<option<Remporium.store<State.state, State.action>>>
  let provider: React.component<
    {
      "children": React.element,
      "value": option<
        Remporium.store<
          State.state,
          State.action,
        >,
      >,
    },
  >

  module Provider: {
    @react.component
    let make: (
      ~store: Remporium.store<
        State.state,
        State.action,
      >,
      ~children: React.element,
    ) => React.element
  }

  let useDispatch: (unit, State.action) => unit
  let useSelector: (State.state => 'a) => 'a
}
