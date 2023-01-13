ReactDOM.render(
  <React.StrictMode>
    <Store.Store.Provider store={Store.store}>
      <App />
    </Store.Store.Provider>
  </React.StrictMode>,
  ReactDOM.querySelector("#root")->Belt.Option.getExn,
)
