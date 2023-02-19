@react.component
let make = () => {
    let url = RescriptReactRouter.useUrl();
    Js.log(url.path);

    switch url.path {
        | list{"battle"} =>
            <BattleStore.Store.Provider store={BattleStore.makeStore()}>
                <BattleComponent />
            </BattleStore.Store.Provider>

        | list{"result"} =>
            <ResultComponent />

        | _ =>
            <div>{"not found"->React.string}</div>
    }
}
