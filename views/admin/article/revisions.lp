
<h2>Article <?= article.system_name ?> history</h2>

<div class="container">
  <div class="row">

    <div class="col-md-6" style="padding-left: 0">
      <div class="form-group">
        <label>Current revision:</label>
        <h4><?= article.modify_time ?> <small>(<?= article.revision ?>)</small></h4>
      </div>
    </div>

    <div class="col-md-6" style="padding-left: 0">
      <div class="form-group">
        <label>Article global ID</label>
        <p><small><?= article.global_id ?></small></p>
      </div>
    </div>

  </div>
</div>

<div class="form-group">
  <label>Current content</label>
  <textarea cols="80" rows="5" readonly class="form-control"><?= article.content ?></textarea>
</div>

<h3>Another revisions</h3>

<?lua for revision_path, revision in pairs(revisions) do ?>
  <?lua if article.revision ~= revision.revision then ?>

    <h4><?= revision.modify_time ?> <small>(<?= revision.revision ?>)</small></h4>

<!--    <div class="form-group">
      <label>revision path:</label>
      <p><small><?= revision_path ?></small></p>
    </div> -->

    <!-- <div class="form-group">
      <label>name</label>
      <p><?= revision.name ?></p>
    </div> -->

    <div class="form-group">
      <label>Content</label>
      <textarea cols="80" rows="5" readonly class="form-control"><?= revision.content ?></textarea>
    </div>

    <p>
      <a href="/admin/article_restore_revision?article_global_id=<?= article.global_id ?>&revision_file_path=<?= revision_path ?>"
      >restore to this revision</a>
    </p>

    <hr />
  <?lua end --[[ another revision --]] ?>
<?lua end ?>