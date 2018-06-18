<?lua local form = require "sailor.form" ?>

<h1>Article #<?= article.id ?> edit</h1>

<form method="post">
  <div class="form-group">
    <label>name</label>
    <?lua page:print( form.text(article,'name', 'class="form-control" placeholder="name"') ) ?>
    <span class="help-block"> <?lua page:print( article.errors.name or '') ?> </span>
  </div>

  <div class="form-group">
    <label>system name</label>
    <?lua page:print( form.text(article,'system_name', 'class="form-control" placeholder="name"') ) ?>
    <span class="help-block"> <?lua page:print( article.errors.system_name or '') ?> </span>
  </div>

  <div class="form-group">
    <label>url alias</label>
    <?lua page:print( form.text(article,'url_alias', 'class="form-control" placeholder="name"') ) ?>
    <span class="help-block"> <?lua page:print( article.errors.url_alias or '') ?> </span>
  </div>

  <!-- TODO content type, content, published !-->

</form>