let store = Remporium.makeStore(State.empty, State.reduce)

module Store = Remporium.CreateModule(State);