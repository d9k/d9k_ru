
<h2>Article <?= article.global_id ?> revisions</h2>

<?lua for revision_path, revision in pairs(revisions) do ?>
  <p>revision path: <?= revision_path ?></p>
  <p>revision: <?= revision.revision ?></p>
  <p>name: <?= revision.name ?></p>
  <p>text: </p>
  <pre><?= revision.content ?></pre>
<?lua end ?>