<h1>Admin panel: articles</h1>

<p><a href="/admin/article_new">+ New article</a></p>

<?lua for _, article in pairs(articles) do ?>
  <p><a href="/admin/article_edit?pk=<?= article.system_name ?>"><?= article.name or article.system_name ?></a></p>
<?lua end ?>