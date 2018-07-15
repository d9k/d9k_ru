docReady ->

  storeSet 'clicksCount', 5
  storeSet 'secondBranch.clicksCount', -2

  window.uiComponents.mountToDom()
