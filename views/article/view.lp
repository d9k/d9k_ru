<?lua if article.name then ?>
  <h2><?= article.name ?></h2>
  <?lua if user then ?>
    <p><a href="/admin/article_edit?pk=<?= article.system_name ?>">edit</a></p>
  <?lua end ?>
<?lua end ?>

<?= article.content ?>