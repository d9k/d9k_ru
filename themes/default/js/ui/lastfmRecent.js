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
      if (attrs.tracksCount == null) {
        attrs.tracksCount = 7;
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
          //console.log 'updated data: ' + JSON.stringify(result)
          self.setData(result);
          m.redraw();
          return self.setAutoUpdateTimer();
        }).catch(function (e) {
          console.log('LastFmRecent mithril component onAutoUpdateTimer ajax error: ' + e.message);
          return self.setAutoUpdateTimer();
        });
      }
    },
    getData: function getData() {
      return storeGet(this.getAttrs().recentTracksStorePath) || {};
    },
    setData: function setData(data) {
      return storeSet(this.getAttrs().recentTracksStorePath, data);
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
      var attrs, data, i, len, ref, ref1, ref2, ref3, ref4, self, showedTracksCount, track, tracksLines, userLink, userName;
      attrs = this.getAttrs();
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
      data = this.getData();
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
      tracksLines = [];
      if ((ref = data.recenttracks) != null ? ref.track : void 0) {
        showedTracksCount = 0;
        ref1 = data.recenttracks.track;
        for (i = 0, len = ref1.length; i < len; i++) {
          track = ref1[i];
          if ((ref2 = track['@attr']) != null ? ref2.nowplaying : void 0) {
            continue;
          }
          tracksLines.push(m(
            'p',
            { style: 'margin-bottom: 3px; margin-top: 3px;' },
            m(
              'small',
              null,
              track.artist.name,
              ' - ',
              track.name
            )
          ));
          showedTracksCount++;
          if (showedTracksCount >= attrs.tracksCount) {
            break;
          }
        }
      }
      userName = (ref3 = data.recenttracks) != null ? (ref4 = ref3['@attr']) != null ? ref4.user : void 0 : void 0;
      userLink = '. . .';
      if (userName) {
        userLink = ['пользователя ', m(
          'a',
          { href: 'https://last.fm/user/' + userName, target: '_blank' },
          userName
        )];
      }
      return m(
        'div',
        { style: 'min-height: 200px; min-width: 350px; border: 1px solid grey; display: inline-block; padding: 7px;' },
        m(
          'h5',
          null,
          '\u041F\u043E\u0441\u043B\u0435\u0434\u043D\u0438\u0435 \u0442\u0440\u044D\u043A\u0438 \u043D\u0430 lastfm ',
          userLink
        ),
        tracksLines
      );
    }
  };

  window.uiComponents.types['lastfm-recent'] = LastfmRecent;
}).call(undefined);