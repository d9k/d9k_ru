'use strict';

(function () {
  docReady(function () {
    storeSet('clicksCount', 5);
    storeSet('secondBranch.clicksCount', -2);
    return window.uiComponents.mountToDom();
  });
}).call(undefined);