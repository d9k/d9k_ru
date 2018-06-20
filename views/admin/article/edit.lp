<?lua local form = require "sailor.form" ?>

<?lua if article.id then ?>
  <h1>Article #<?= article.id ?> edit</h1>
<?lua else ?>
  <h1>New article</h1>
<?lua end ?>

<form method="post">
  <div class="form-group">
    <label>Caption</label>
    <?= form.text(article, 'name', [[class="form-control" placeholder="name"]]) ?>
    <span class="help-block"> <?= article.errors.name or '' ?> </span>
  </div>

  <div class="form-group">
    <label>System name</label>
    <?= form.text(article, 'system_name', [[class="form-control" placeholder="system name"]]) ?>
    <span class="help-block"> <?= article.errors.system_name or '' ?> </span>
  </div>

  <div class="form-group">
    <label>Url alias</label>
    <?= form.text(article, 'url_alias', [[class="form-control" placeholder="name"]]) ?>
    <span class="help-block"> <?= article.errors.url_alias or '' ?> </span>
  </div>

  <div class="form-group">
    <label>Content Type</label>
    <%= form.dropdown(
          article,
          'content_type',
          { ['html+markdown'] = 'html+markdown', html = 'html' },
          'Select...',
          [[class="form-control"]]
       )
    %>
    <span class="help-block"> <?= article.errors.content_type or '' ?> </span>
  </div>

  <div class="form-group">
    <label>Content</label>
    <?= form.textarea(article, 'content', [[class="form-control" rows="10"]]) ?>
    <span class="help-block"> <?= article.errors.content or '' ?> </span>
  </div>

  <div class="form-group">
    <?= form.checkbox(article, 'active', 'Active', false, [[]]) ?>
    <span class="help-block"> <?lua page:print( article.errors.active or '') ?> </span>
  </div>

  <?lua if article.id then ?>
    <div class="form-group">
      <label>Global ID</label>
      <p><small><?= article.global_id ?></small></p>
    </div>
  <?lua end ?>

	<input type="submit" value="Save" class="btn btn-primary btn-lg"/>
</form>