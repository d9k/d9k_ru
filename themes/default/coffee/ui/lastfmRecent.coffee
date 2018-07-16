
LastfmRecent =

  AUTO_UPDATE_TIMEOUT_SEC: 5,

  initAttrs: () ->
    attrs = @getAttrs()
    attrs.recentTracksStorePath ?= 'lastfm.recent'
    # attrs.recentMetaStorePath
    attrs.serverRequestUrl ?= '/components/lastfm_recent'
    attrs.updateIntervalSec ?= 30
    attrs.tracksCount ?= 7
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
          console.log 'LastFmRecent mithril component onAutoUpdateTimer ajax updated'
          #console.log 'updated data: ' + JSON.stringify(result)
          self.setData(result)
          m.redraw()
          self.setAutoUpdateTimer()
      )
      .catch(
        (e) ->
          console.log 'LastFmRecent mithril component onAutoUpdateTimer ajax error: ' + e.message
          self.setAutoUpdateTimer()
      )

  getData: () ->
    return storeGet(@getAttrs().recentTracksStorePath) or {}

  setData: (data) ->
    storeSet(@getAttrs().recentTracksStorePath, data)

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

    tracksLines = []

    if data.recenttracks?.track
      showedTracksCount = 0

      for track in data.recenttracks.track

        if track['@attr']?.nowplaying
          continue

        tracksLines.push <p style="margin-bottom: 3px; margin-top: 3px;">
          <small>{track.artist.name} - {track.name}</small>
        </p>

        showedTracksCount++

        if showedTracksCount >= attrs.tracksCount
          break

    userName = data.recenttracks?['@attr']?.user

    userLink = '. . .'

    if userName
      userLink = ['пользователя ', <a href={'https://last.fm/user/' + userName} target="_blank">{userName}</a>]

    <div style="min-height: 200px; min-width: 350px; border: 1px solid grey; display: inline-block; padding: 7px;">
      <h5>Последние трэки на lastfm {userLink}</h5>
      {tracksLines}
    </div>


window.uiComponents.types['lastfm-recent'] = LastfmRecent
