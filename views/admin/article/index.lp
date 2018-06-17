<h1>Admin panel: articles</h1>

<?lua for _, article in pairs(articles) do ?>
  <p><a href="/admin/article_edit?id=<?= article.id ?>"><?= article.name ?></a></p>
<?lua end ?>