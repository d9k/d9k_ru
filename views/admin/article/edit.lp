<?lua local form = require "sailor.form" ?>

<?lua if article.system_name then ?>
  <h1>Article <?= article.system_name ?> edit</h1>
  <p><a href="<?= article:build_url() ?>">see on site</a></p>
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

  <?lua if article.global_id then ?>
    <p><a href="/admin/article_revisions?global_id=<?= article.global_id ?>">article revisions</a></p>
  <?lua end ?>

  <div class="form-group">
    <?= form.checkbox(article, 'active', 'Active', false, [[]]) ?>
    <span class="help-block"> <?lua page:print( article.errors.active or '') ?> </span>
  </div>

	<input type="submit" value="Save" class="btn btn-primary btn-lg"/>

  <?lua if article.id then ?>
    <p></p>
    <div class="form-group">
      <label>Global ID</label>
      <p><small><?= article.global_id ?></small></p>
    </div>
    <div class="form-group">
      <label>Revision</label>
      <p><small><?= article.revision ?></small></p>
    </div>
    <div class="form-group">
      <label>Create time</label>
      <p><small><?= article.create_time ?></small></p>
    </div>
    <div class="form-group">
      <label>Modify time</label>
      <p><small><?= article.modify_time ?></small></p>
    </div>
  <?lua end ?>
</form>