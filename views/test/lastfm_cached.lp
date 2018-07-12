<h1>Last FM cached</h1>

<p><b>
  <?lua if cached then ?>
    (Cached in redis)
  <?lua else ?>
    (New api request made)
  <?lua end ?>
</b></p>


<p>Tracks:</p>

<pre>
<%= recent_tracks %>
</pre>
