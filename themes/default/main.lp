<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="">
    <link rel="shortcut icon" href="../../docs-assets/ico/favicon.png">

    <title><%=page.title%></title>

    <!-- Bootstrap core CSS -->
    <link href="<%=page.theme_path%>/css/bootstrap.css" rel="stylesheet">

    <!-- Custom styles for this template -->
    <link href="<%=page.theme_path%>/css/sticky-footer-navbar.css" rel="stylesheet">
    <link href="<%=page.theme_path%>/css/style.css" rel="stylesheet">
	<!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
      <script src="https://oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>
    <![endif]-->
  </head>

  <body>

    <!-- Wrap all page content here -->
    <div id="wrap">

      <!-- Fixed navbar -->
      <div class="navbar navbar-default navbar-fixed-top" role="navigation">
        <div class="container">
          <div class="navbar-header">
            <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
              <span class="sr-only">Toggle navigation</span>
              <span class="icon-bar"></span>
              <span class="icon-bar"></span>
              <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="/"><%=page.title%></a>
          </div>
          <div class="collapse navbar-collapse">
            <ul class="nav navbar-nav">
              <li class="active"><a href="#">Home</a></li>
<!--              <li class="dropdown">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown">Dropdown <b class="caret"></b></a>
                <ul class="dropdown-menu">
                  <li><a href="#">Action</a></li>
                  <li><a href="#">Another action</a></li>
                  <li><a href="#">Something else here</a></li>
                  <li class="divider"></li>
                  <li class="dropdown-header">Nav header</li>
                  <li><a href="#">Separated link</a></li>
                  <li><a href="#">One more separated link</a></li>
                </ul>
              </li> -->

              <!--
                <?lua if user then ?>
                  <li class=""><a href="/test">Test</a></li>
                <? end ?>
              -->

              <?lua if user then ?>
                <li class="dropdown">
                  <a href="#" class="dropdown-toggle" data-toggle="dropdown">Admin <b class="caret"></b></a>
                  <ul class="dropdown-menu">
                    <li><a href="/admin/index">Index</a></li>
                    <li><a href="/admin/article">Articles</a></li>
                    <li class="divider"></li>
                    <!-- <li class="dropdown-header">Nav header</li> -->
                    <li><a href="/test">Test</a></li>
                  </ul>
                </li>
              <?lua end ?>
            </ul>

            <ul class="nav navbar-nav navbar-right">
              <?lua if user then ?>
                <p class="navbar-text"><?= user.login ?></p>
                <li><a href="/auth/logout">(Logout)</a></li>
              <?lua else ?>
                <li><a href="/auth/login">Login</a></li>
              <?lua end ?>
            </ul>


          </div><!--/.nav-collapse -->
        </div>
      </div>

      <!-- Begin page content -->
      <div class="container">
        <?lua if page.breadcrumbs and page.breadcrumbs[1] then ?>
          <ul class="breadcrumb">
            <?lua for i, b_crumb in ipairs(page.breadcrumbs) do ?>
              <li><a href="<?= b_crumb.url ?>"
                     class="<?= i == #(page.breadcrumbs) and 'active' or '' ?>"
                  ><?= b_crumb.caption ?></a></li>
            <?lua end ?>
          </ul>
        <?lua end ?>

        <script src="<%=page.theme_path%>/js/jquery-1.10.2.min.js"></script>
        <script src="<%=page.theme_path%>/js/bootstrap.min.js"></script>
        <script src="<%=page.theme_path%>/js/mithril_1_1_6.js"></script>

        <script src="<%=page.theme_path%>/js/docready.js"></script>
        <script src="<%=page.theme_path%>/js/store.js"></script>
        <script src="<%=page.theme_path%>/js/uiComponents.js"></script>
        <script src="<%=page.theme_path%>/js/ui/counter.js"></script>
        <script src="<%=page.theme_path%>/js/ui/lastfmRecent.js"></script>
        <script src="<%=page.theme_path%>/js/ui/flickrLastPhotos.js"></script>
        <script src="<%=page.theme_path%>/js/onDocReady.js"></script>
        {{content}}
      </div>
    </div>

    <div id="footer">
      <div class="container">
      	<!-- Yes, you are allowed to remove this -->
        <p class="text-muted">
          Powered with
          <a href="http://sailorproject.org" target="_blank">Sailor framework</a>
          (made by <a href="https://twitter.com/etiene_d" target="_blank">Etiene Dalcol</a>)
          and <a href="http://lua.org" target="_blank">Lua</a>
        </p>
      </div>
    </div>

  </body>
</html>
