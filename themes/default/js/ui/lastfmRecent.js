'use strict';

(function () {
  var LastfmRecent;

  LastfmRecent = {
    AUTO_UPDATE_TIMEOUT_SEC: 5,
    initAttrs: function initAttrs() {
      var attrs;
      attrs = this.getAttrs();
      if (attrs.recentTracksStorePath == null) {
        attrs.recentTracksStorePath = 'lastfm.recent';
      }
      // attrs.recentMetaStorePath
      if (attrs.serverRequestUrl == null) {
        attrs.serverRequestUrl = '/components/lastfm_recent';
      }
      if (attrs.updateIntervalSec == null) {
        attrs.updateIntervalSec = 30;
      }
      this.setAttrs(attrs);
      return attrs;
    },
    getAttrs: function getAttrs() {
      return storeGet('ui.' + this.domElementId);
    },
    setAttrs: function setAttrs(attrs) {
      return storeSet('ui.' + this.domElementId, attrs);
    },
    setAutoUpdateTimer: function setAutoUpdateTimer() {
      var attrs;
      attrs = this.getAttrs();
      clearTimeout(this.autoUpdateTimer);
      if (attrs.updateIntervalSec) {
        return setTimeout(this.onAutoUpdateTimer.bind(this), attrs.updateIntervalSec * 1000);
      }
    },
    onAutoUpdateTimer: function onAutoUpdateTimer() {
      var attrs, self;
      attrs = this.getAttrs();
      self = this;
      if (attrs.updateIntervalSec) {
        return m.request({
          method: "GET",
          url: attrs.serverRequestUrl,
          timeout: this.AUTO_UPDATE_TIMEOUT_SEC
          //data: {}
        }).then(function (result) {
          console.log('LastFmRecent mithril component onAutoUpdateTimer ajax updated');
          console.log('updated data: ' + JSON.stringify(result));
          return self.setAutoUpdateTimer();
        }).catch(function (e) {
          console.log('LastFmRecent mithril component onAutoUpdateTimer ajax error: ' + e.message);
          return self.setAutoUpdateTimer();
        });
      }
    },
    oninit: function oninit(vnode) {
      this.domElementId = vnode.attrs.domElementId;
      this.initAttrs();
      this.onAutoUpdateTimer();
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