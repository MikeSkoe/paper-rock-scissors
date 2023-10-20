let initStore = () => {
    let appAction: ReX.t<BattleState.action, BattleState.action> = ReX.make(ReX.id);
    let app = appAction->ReX.reduce(BattleState.empty, BattleState.reduce);

    let unsubApply = 
        app
        ->ReX.map(state =>
            state
            ->BattleState.Select.choosing
            ->Choosing.foldConfirmed(false, (_, _) => true)
        )
        ->ReX.debounce(1000)
        ->ReX.sub(bothConfirmed => {
            if bothConfirmed == true {
                appAction->ReX.call(BattleState.Apply);
            }
        });

    let unsubResult =
        ReX.either(
            app->ReX.map(BattleState.Select.left),
            app->ReX.map(BattleState.Select.right)
        )
        ->ReX.map(player => player.health)
        ->ReX.sub(health => {
            if health <= 0. {
                RescriptReactRouter.replace("result");
                appAction->ReX.call(BattleState.Init);
            }
        });
    
    (appAction, app, () => ()->unsubApply->unsubResult);
}

let useSync = (t, initial) => {
    let snapshot = React.useRef(initial);

    React.useSyncExternalStore(
        ~subscribe = sub => {
            let unsub = t->ReX.sub(value => {
                snapshot.current = value;
                sub();
            });
            (.) => unsub();
        },
        ~getSnapshot = () => snapshot.current,
    );
}

module AppContext = {
    let (appAction, app, _) = initStore();

    let appActionContext = React.createContext(appAction);
    let appContext = React.createContext(app);

    let useSelect = (selector) => {
        let input = React.useRef(ReX.make(selector));

        React.useEffect0(() => {
            let unsub = app->ReX.sub(ReX.call(input.current));
            Some(unsub);
        })

        input.current->useSync(BattleState.empty->selector);
    }

    module AppActionProvider = {
        let make = React.Context.provider(appActionContext);
    }

    module AppProvider = {
        let make = React.Context.provider(appContext);
    }
}

