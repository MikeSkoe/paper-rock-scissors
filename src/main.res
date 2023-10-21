open ReactDOM;

let root = querySelector("#root")
    ->Belt.Option.getExn
    ->Client.createRoot
    ->Client.Root.render(
        <React.StrictMode>
            <App />
        </React.StrictMode>
    );
