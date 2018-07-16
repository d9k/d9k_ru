
LastfmRecent =

  oninit: (vnode) ->
    @domElementId = vnode.attrs.domElementId
    attrs = storeGet('ui.' + @domElementId )

    attrs.recentTracksStorePath ?= 'lastfm.recent'
    # attrs.recentMetaStorePath
    attrs.serverRequestUrl ?= '/components/lastfm_recent'
    attrs.updateIntervalSec = 30
    storeSet('ui.' + @domElementId, attrs)

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
    attrs = storeGet('ui.' + @domElementId )

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

    recentTracks = storeGet(attrs.recentTracksStorePath) or {}
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


    <div style="border: 1px solid grey; display: inline-block; padding: 7px; min-height: 200px">
      <h4>Последние трэки на lastfm</h4>
      {[
        <p>te</p>
        <p>st</p>
      ]}
    </div>


window.uiComponents.types['lastfm-recent'] = LastfmRecent
