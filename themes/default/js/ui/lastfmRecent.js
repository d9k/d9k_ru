'use strict';

(function () {
  var LastfmRecent;

  LastfmRecent = {
    oninit: function oninit(vnode) {
      var attrs;
      this.domElementId = vnode.attrs.domElementId;
      attrs = storeGet('ui.' + this.domElementId);
      if (attrs.recentTracksStorePath == null) {
        attrs.recentTracksStorePath = 'lastfm.recent';
      }
      // attrs.recentMetaStorePath
      if (attrs.serverRequestUrl == null) {
        attrs.serverRequestUrl = '/components/lastfm_recent';
      }
      attrs.updateIntervalSec = 30;
      storeSet('ui.' + this.domElementId, attrs);
    },
    //if vnode.attrs.updateIntervalSec

    // m.request({
    //   method: "PUT",
    //   url: "/api/v1/users/:id",
    //   data: {id: 1, name: "test"}
    // })
    // .then(function(result) {
    //     console.log(result)
    // })

    //   @autoUpdateTimer = setInterval(
    //     () ->
    //       console.log('timer')
    //       return
    //     ,
    //     3000
    //   );
    //this.store = vnode.attrs.store;
    view: function view(vnode) {
      var attrs, recentTracks, self;
      attrs = storeGet('ui.' + this.domElementId);
      //console.log(JSON.stringify(vnode.attrs) + ' rerender')
      self = this;
      //m("main", [
      //m("h1", {class: "title"}, "My first app"),
      // changed the next line

      //m 'button', { onclick: ->
      //count = storeGet(self.count_path)
      //storeSet self.count_path, count + self.delta
      //return
      //}, self.count_path + ': ' + storeGet(self.count_path)
      recentTracks = storeGet(attrs.recentTracksStorePath) || {};
      //userName = userInfo.name or 'unknown user'
      //userScrobblesCount = userInfo.scrobblesCount or '?'

      //if not count?
      //storeSet(counterPath, attrs.defaultCounterValue)

      // <button
      //   onclick = {() ->
      //     count = storeGet(counterPath)
      //     storeSet(counterPath, count + delta)
      //   }
      // >
      //   {counterPath + ': ' + deltaCaption + storeGet(counterPath)}
      // </button>
      //,
      //)
      return m(
        'div',
        { style: 'border: 1px solid grey; display: inline-block; padding: 7px; min-height: 200px' },
        m(
          'h4',
          null,
          '\u041F\u043E\u0441\u043B\u0435\u0434\u043D\u0438\u0435 \u0442\u0440\u044D\u043A\u0438 \u043D\u0430 lastfm'
        ),
        [m(
          'p',
          null,
          'te'
        ), m(
          'p',
          null,
          'st'
        )]
      );
    }
  };

  window.uiComponents.types['lastfm-recent'] = LastfmRecent;
}).call(undefined);