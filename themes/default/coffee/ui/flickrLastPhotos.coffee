FlickrLastPhotos =

  AUTO_UPDATE_TIMEOUT_SEC: 5,

  initAttrs: () ->
    attrs = @getAttrs()
    attrs.lastPhotosStorePath ?= 'flickr.lastPhotos'
    # attrs.recentMetaStorePath
    attrs.serverRequestUrl ?= '/components/flickr_last_public_photos'
    attrs.updateIntervalSec ?= 60
    attrs.photoSidePx ?= 150
    attrs.photosRows ?= 4
    attrs.photosColumns ?= 4
    @setAttrs(attrs)

    return attrs

  getAttrs: () ->
    return storeGet('ui.' + @domElementId )

  setAttrs: (attrs) ->
    storeSet('ui.' + @domElementId, attrs)

  setAutoUpdateTimer: () ->
    attrs = @getAttrs()

    clearTimeout(@autoUpdateTimer)
    if attrs.updateIntervalSec
      setTimeout(
        @onAutoUpdateTimer.bind(@),
        attrs.updateIntervalSec * 1000
      )

  onAutoUpdateTimer: () ->
    attrs = @getAttrs()

    self = @

    if attrs.updateIntervalSec
      m.request({
        method: "GET",
        url: attrs.serverRequestUrl,
        timeout: @AUTO_UPDATE_TIMEOUT_SEC,
        #data: {}
      })
      .then(
        (result) ->
          console.log 'FlickrLastPhotos mithril component onAutoUpdateTimer ajax updated'
          #console.log 'updated data: ' + JSON.stringify(result)
          self.setData(result)
          m.redraw()
          self.setAutoUpdateTimer()
      )
      .catch(
        (e) ->
          console.log 'FlickrLastPhotos mithril component onAutoUpdateTimer ajax error: ' + e.message
          self.setAutoUpdateTimer()
      )

  getData: () ->
    return storeGet(@getAttrs().lastPhotosStorePath) or {}

  setData: (data) ->
    storeSet(@getAttrs().lastPhotosStorePath, data)

  oninit: (vnode) ->
    @domElementId = vnode.attrs.domElementId
    @initAttrs()
    @onAutoUpdateTimer()

    #if vnode.attrs.updateIntervalSec

    # m.request({
    #   method: "PUT",
    #   url: "/api/v1/users/:id",
    #   data: {id: 1, name: "test"}
    # })
    # .then(function(result) {
    #     console.log(result)
    # })
#
    #   @autoUpdateTimer = setInterval(
    #     () ->
    #       console.log('timer')
    #       return
    #     ,
    #     3000
    #   );
    #this.store = vnode.attrs.store;
    return

  view: (vnode) ->
    attrs = @getAttrs()

    #console.log(JSON.stringify(vnode.attrs) + ' rerender')
    self = this
    #m("main", [
    #m("h1", {class: "title"}, "My first app"),
    # changed the next line
#
    #m 'button', { onclick: ->
      #count = storeGet(self.count_path)
      #storeSet self.count_path, count + self.delta
      #return
    #}, self.count_path + ': ' + storeGet(self.count_path)

    data = @getData()
    #userName = userInfo.name or 'unknown user'
    #userScrobblesCount = userInfo.scrobblesCount or '?'

    #if not count?
      #storeSet(counterPath, attrs.defaultCounterValue)

    # <button
    #   onclick = {() ->
    #     count = storeGet(counterPath)
    #     storeSet(counterPath, count + delta)
    #   }
    # >
    #   {counterPath + ': ' + deltaCaption + storeGet(counterPath)}
    # </button>
    #,
    #)

    tableRows = []
    desiredPhotosCount = attrs.photosRows * attrs.photosColumns
    tableRowCells = []

    if data.photos?.photo?[0]?
      outputtedCount = 0
      availablePhotos = data.photos?.photo.length

      for photo in data.photos?.photo

        #https://www.flickr.com/photos/d9k/34670036102

        tableRowCells.push <td>
            <a
              href={'https://www.flickr.com/photos/' + photo.pathalias + '/' + photo.id}
              target='_blank'
            >
              <img src={photo.url_q} style={width: attrs.photoSidePx + 'px', height: attrs.photoSidePx + 'px'} />
            </a>
          </td>

        outputtedCount++

        if tableRowCells.length >= attrs.photosColumns or outputtedCount >= availablePhotos
          tableRows.push <tr>{tableRowCells}</tr>
          tableRowCells = []

        if outputtedCount >= desiredPhotosCount then break

    <table
      class="flickrLastPhotosComponent"
      style={
        #border: if outputtedCount > 0 then '1px solid grey' else '',
        display: 'inline-block';
        minWidth: (attrs.photoSidePx * attrs.photosColumns) + 'px',
        minHeight: (attrs.photoSidePx * attrs.photosRows) + 'px',
        fontSize: '14px',
      }
    >
      {tableRows}
    </table>

window.uiComponents.types['flickr-last-photos'] = FlickrLastPhotos
