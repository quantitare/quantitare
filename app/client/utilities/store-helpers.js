export function promiseForDispatch(dispatch, mutationName, payload) {
  return new Promise((resolve, reject) => {
    dispatch(mutationName, payload)
      .then(() => resolve())
  })
}
