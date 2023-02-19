let makeStore = () => Remporium.makeStore(BattleState.empty, BattleState.reduce)

module Store = Remporium.CreateModule(BattleState);