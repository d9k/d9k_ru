<?lua
  local table_helpers = require 'helpers.table'
?>

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
  <textarea cols="80" rows="14" readonly class="form-control" style="font-size: 11px"><?= article.content ?></textarea>
</div>

<h3>Another revisions</h3>

<?lua
  local sorted_revisions_keys = table_helpers.sorted_keys(revisions, function(t, a, b)
    return a > b
  end)
?>

<?lua for _, revision_path in ipairs(sorted_revisions_keys) do ?>
  <?lua local revision = revisions[revision_path] ?>
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
      <textarea cols="80" rows="14" readonly class="form-control"  style="font-size: 11px"><?= revision.content ?></textarea>
    </div>

    <p>
      <a href="/admin/article_restore_revision?revision_file_path=<?= revision_path ?>"
      >restore to this revision</a>
    </p>

    <hr />
  <?lua end --[[ another revision --]] ?>
<?lua end ?>