
<h2>Article <?= article.system_name ?> history</h2>

<div class="form-group">
  <label>current rev. modify time (UTC)</label>
  <p><?= article.modify_time ?></p>
</div>

<div class="form-group">
  <label>article global ID</label>
  <p><small><?= article.global_id ?></small></p>
</div>

<div class="form-group">
  <label>current revision</label>
  <p><small><?= article.revision ?></small></p>
</div>

<h3>Another revisions</h3>

<?lua for revision_path, revision in pairs(revisions) do ?>
  <?lua if article.revision ~= revision.revision then ?>

    <div class="form-group">
      <label>modify time (UTC)</label>
      <p><?= revision.modify_time ?></p>
    </div>

    <div class="form-group">
      <label>revision</label>
      <p><small><?= revision.revision ?></small></p>
    </div>

<!--    <div class="form-group">
      <label>revision path:</label>
      <p><small><?= revision_path ?></small></p>
    </div> -->

    <!-- <div class="form-group">
      <label>name</label>
      <p><?= revision.name ?></p>
    </div> -->

    <div class="form-group">
      <label>content</label>
      <textarea cols="80" rows="5" class="form-control"><?= revision.content ?></textarea>
    </div>

    <hr />
  <?lua end --[[ another revision --]] ?>
<?lua end ?>