let initStore = () => {
    let { make, id, reduce, map, sub, debounce, call, either } = module(ReX);

    let dispatch = make(id);
    let app = dispatch->reduce(BattleState.empty, BattleState.reduce);

    let unsubApply = 
        app
        ->map(state =>
            state
            ->BattleState.Select.choosing
            ->Choosing.foldConfirmed(false, (_, _) => true)
        )
        ->debounce(1000)
        ->sub(bothConfirmed => {
            if bothConfirmed == true {
                dispatch->call(BattleState.Apply);
            }
        });

    let unsubResult =
        either(
            app->map(BattleState.Select.left),
            app->map(BattleState.Select.right)
        )
        ->sub(player => {
            if player.health <= 0. {
                RescriptReactRouter.replace("result");
                dispatch->call(BattleState.Init);
            }
        });

    (dispatch, app, () => ()->unsubApply->unsubResult);
}

let useSync: (ReX.t<BattleState.action, BattleState.state>, 'a, BattleState.state => 'a) => 'a
    =
    (t, initial, selector) => {
        let snapshot = React.useRef(initial);

        React.useSyncExternalStore(
            ~subscribe = sub => {
                let unsub = t->ReX.sub(value => {
                    snapshot.current = selector(value);
                    sub();
                });
                (.) => unsub();
            },
            ~getSnapshot = () => snapshot.current,
        );
    }

%%private(
    let (appAction, app, _) = initStore();
)

let dispatchContext = React.createContext(appAction);
let appContext = React.createContext(app);

module AppActionProvider = {
    let make = React.Context.provider(dispatchContext);
}

module AppProvider = {
    let make = React.Context.provider(appContext);
}
