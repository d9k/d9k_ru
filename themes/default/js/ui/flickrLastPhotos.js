'use strict';

(function () {
  var FlickrLastPhotos;

  FlickrLastPhotos = {
    AUTO_UPDATE_TIMEOUT_SEC: 5,
    initAttrs: function initAttrs() {
      var attrs;
      attrs = this.getAttrs();
      if (attrs.lastPhotosStorePath == null) {
        attrs.lastPhotosStorePath = 'flickr.lastPhotos';
      }
      // attrs.recentMetaStorePath
      if (attrs.serverRequestUrl == null) {
        attrs.serverRequestUrl = '/components/flickr_last_public_photos';
      }
      if (attrs.updateIntervalSec == null) {
        attrs.updateIntervalSec = 60;
      }
      if (attrs.photoSidePx == null) {
        attrs.photoSidePx = 150;
      }
      if (attrs.photosRows == null) {
        attrs.photosRows = 4;
      }
      if (attrs.photosColumns == null) {
        attrs.photosColumns = 4;
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
          console.log('FlickrLastPhotos mithril component onAutoUpdateTimer ajax updated');
          //console.log 'updated data: ' + JSON.stringify(result)
          self.setData(result);
          m.redraw();
          return self.setAutoUpdateTimer();
        }).catch(function (e) {
          console.log('FlickrLastPhotos mithril component onAutoUpdateTimer ajax error: ' + e.message);
          return self.setAutoUpdateTimer();
        });
      }
    },
    getData: function getData() {
      return storeGet(this.getAttrs().lastPhotosStorePath) || {};
    },
    setData: function setData(data) {
      return storeSet(this.getAttrs().lastPhotosStorePath, data);
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
      var attrs, availablePhotos, data, desiredPhotosCount, i, len, outputtedCount, photo, ref, ref1, ref2, ref3, ref4, self, tableRowCells, tableRows;
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
      tableRows = [];
      desiredPhotosCount = attrs.photosRows * attrs.photosColumns;
      tableRowCells = [];
      if (((ref = data.photos) != null ? (ref1 = ref.photo) != null ? ref1[0] : void 0 : void 0) != null) {
        outputtedCount = 0;
        availablePhotos = (ref2 = data.photos) != null ? ref2.photo.length : void 0;
        ref4 = (ref3 = data.photos) != null ? ref3.photo : void 0;
        for (i = 0, len = ref4.length; i < len; i++) {
          photo = ref4[i];
          //https://www.flickr.com/photos/d9k/34670036102
          tableRowCells.push(m(
            'td',
            null,
            m(
              'a',
              { href: 'https://www.flickr.com/photos/' + photo.pathalias + '/' + photo.id, target: '_blank' },
              m('img', { src: photo.url_q, style: {
                  width: attrs.photoSidePx + 'px',
                  height: attrs.photoSidePx + 'px'
                } })
            )
          ));
          outputtedCount++;
          if (tableRowCells.length >= attrs.photosColumns || outputtedCount >= availablePhotos) {
            tableRows.push(m(
              'tr',
              null,
              tableRowCells
            ));
            tableRowCells = [];
          }
          if (outputtedCount >= desiredPhotosCount) {
            break;
          }
        }
      }
      return m(
        'table',
        { 'class': 'flickrLastPhotosComponent', style: {
            //border: if outputtedCount > 0 then '1px solid grey' else '',
            display: 'inline-block',
            minWidth: attrs.photoSidePx * attrs.photosColumns + 'px',
            minHeight: attrs.photoSidePx * attrs.photosRows + 'px',
            fontSize: '14px'
          } },
        tableRows
      );
    }
  };

  window.uiComponents.types['flickr-last-photos'] = FlickrLastPhotos;
}).call(undefined);